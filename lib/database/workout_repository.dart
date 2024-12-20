import 'dart:convert';

import 'package:progressive_overload/database/db_helper.dart';
import 'package:progressive_overload/model/workout_model.dart';
import 'package:progressive_overload/model/set_model.dart';

class WorkoutRepository {
  final _dbHelper = DBHelper.dbHero;

  Future<int> insert(Workout workout, List<Set> sets) async {
    final db = await _dbHelper.database;

    return await db.transaction((txn) async {
      int workoutId = await txn.insert('workout', workout.toMap());

      sets.forEach((set) async {
        await txn.insert('set', set.toMap(workoutId));
      });

      return workoutId;
    });
  }

  Future<List<Workout>> getWorkouts({String? name}) async {
    /**
     * To do
     * 1. 이름 별 검색 필요 (최근 기록)
     * 2. 캘린더를 채우기 위한 날짜별 검색 필요(단, 새로운 함수를 만들어야 함)
     */
    final db = await _dbHelper.database;
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
                  'weight', s.weight,
                  'sequence', s.sequence,
                  'created_at', s.created_at
                )
              ELSE NULL
            END
          ), '[]'
        ) as 'sets'
        FROM 'workout' w 
        LEFT JOIN 
        'set' s ON w.id = s.workout_id
        ${name != null ? "WHERE w.name Like '%${name}%'" : ''}
        GROUP BY w.id
        ORDER BY w.workout_date DESC;
      ''');

    return List.generate(maps.length, (i) {
      List<dynamic> raw = jsonDecode('[${maps[i]['sets']}]');
      List<dynamic> sets = raw.whereType<Map>().toList();

      return Workout(
        id: maps[i]['id'],
        name: maps[i]['name'],
        workoutDate: DateTime.parse(maps[i]['workout_date']),
        createdAt: DateTime.parse(maps[i]['created_at']),
        sets: List.generate(
          sets.length,
          (j) {
            final weight = (sets[j]['weight']).toDouble();
            final createdAt = DateTime.parse(sets[j]['created_at']);

            return Set(
              id: sets[j]['id'],
              reps: sets[j]['reps'],
              weight: weight,
              createdAt: createdAt,
              sequence: sets[j]['sequence'],
            );
          },
        ),
      );
    });
  }

  Future<void> deleteWorkout(int id) async {
    final db = await _dbHelper.database;

    return await db.transaction((txn) async {
      await txn.delete('set', where: 'workout_id = ?', whereArgs: [id]);
      await txn.delete('workout', where: 'id = ?', whereArgs: [id]);
    });
  }

  Future<int> replaceSets(List<Set> sets, int workoutId) async {
    final db = await _dbHelper.database;

    return await db.transaction((txn) async {
      await txn.delete('set', where: 'workout_id = ?', whereArgs: [workoutId]);

      sets.forEach((set) async {
        await txn.insert('set', set.toMap(workoutId));
      });

      return workoutId;
    });
  }
}
