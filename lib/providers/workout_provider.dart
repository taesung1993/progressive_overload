import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> _initDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'progressive_overload.db');

  await deleteDatabase(path);
  Database database = await openDatabase(
    path,
    version: 1,
    onCreate: (Database db, int version) async {
      await db.execute(
          'CREATE TABLE workout_list(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, weight FLOAT NOT NULL, count INTEGER NOT NULL, workedoutAt TEXT NOT NULL)');
      await db.execute('''
        CREATE TABLE training_set (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          sequence INTEGER NOT NULL,
          workout_list_id INTEGER NOT NULL,
          weight FLOAT NOT NULL,
          count INTEGER NOT NULL,
          FOREIGN KEY (workout_list_id) REFERENCES workout_list (id)
          ON DELETE CASCADE ON UPDATE CASCADE
        )
      ''');
    },
  );

  return database;
}

class WorkoutNotifier extends StateNotifier<Map<String, dynamic>> {
  WorkoutNotifier() : super({});

  Future<void> addWorkout() async {
    /**
     * 받아야 할 변수
     * 1. 운동 이름
     * 2. 운동 날짜(정수로 변환)
     * 3. training_set
     */
    final db = await _initDatabase();
  }
}

final workoutProvider =
    StateNotifierProvider<WorkoutNotifier, Map<String, dynamic>>(
        (ref) => WorkoutNotifier());
