import 'package:progressive_overload/models/workout_item.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SQLiteService {
  Future<Database> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'progressive_overload.db');

    // await deleteDatabase(path);
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
              CREATE TABLE workout_list(
                id INTEGER PRIMARY KEY AUTOINCREMENT, 
                name TEXT NOT NULL, 
                maxWeightInTrainingSet FLOAT NOT NULL, 
                maxCountInTrainingSet INTEGER NOT NULL, 
                workedoutAt INTEGER NOT NULL
              )
            ''');
        await db.execute('''
        CREATE TABLE training_set (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          sequence INTEGER NOT NULL,
          weight FLOAT NOT NULL,
          count INTEGER NOT NULL,
          workedoutAt INTEGER NOT NULL,
          workout_list_id INTEGER NOT NULL,
          FOREIGN KEY (workout_list_id) REFERENCES workout_list (id)
          ON DELETE CASCADE ON UPDATE CASCADE
        )
      ''');
      },
    );

    return database;
  }

  Future<int> insertWorkoutItem(WorkoutItem item) async {
    final db = await init();

    return await db.insert(
      'workout_list',
      item.toMap(),
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getWorkoutList() async {
    final db = await init();
    final list = await db.query('workout_list');

    return list;
  }
}
