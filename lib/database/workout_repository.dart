import 'package:progressive_overload/database/db_helper.dart';
import 'package:progressive_overload/model/workout_model.dart';
import 'package:progressive_overload/model/set_model.dart';

class WorkoutRepository {
  final dbHelper = DBHelper.dbHero;

  Future<int> insert(Workout workout) async {
    final db = await dbHelper.database;
    return await db.insert('workout', workout.toMap());
  }

  Future<List<Workout>> getWorkouts(String? where) async {
    /**
     * To do
     * 1. 이름 별 검색 필요 (최근 기록)
     * 2. 캘린더를 채우기 위한 날짜별 검색 필요(단, 새로운 함수를 만들어야 함)
     */
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        w.id as 'id', 
        w.name as 'name', 
        w.workout_date as 'workout_date', 
        w.created_at as 'created_at',
        COALESCE(
          GROUP_CONCAT(
            CASE
              WHEN s.id IS NOT NULL THEN
                json_object(
                  'id', s.id,
                  'workout_id', s.workout_id,
                  'reps', s.reps,
                  'created_at', s.created_at
                )
              ELSE NULL
            END
          ), '[]'
        ) as 'sets',
        FROM 'workout' w 
        JOIN 
        'set' s ON w.id = s.workout_id 
        GROUP BY w.id;
      ''');

    return List.generate(maps.length, (i) {
      return Workout(
        id: maps[i]['id'],
        name: maps[i]['name'],
        workoutDate: DateTime.parse(maps[i]['workout_date']),
        createdAt: DateTime.parse(maps[i]['created_at']),
        sets: List.generate(maps[i]['sets'].length, (j) {
          Map<String, dynamic> set = maps[i]['sets'][j];
          return Set(
            id: set['id'],
            workoutId: set['workout_id'],
            reps: set['reps'],
            weight: set['weight'],
            createdAt: DateTime.parse(set['created_at']),
          );
        }),
      );
    });
  }

  Future<int> delete(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'workout',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
