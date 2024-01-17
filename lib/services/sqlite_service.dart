import 'package:progressive_overload/models/training_set_item_model.dart';
import 'package:progressive_overload/models/workout_item_model.dart';
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

  Future<int> insertWorkoutItem(WorkoutItemModel item) async {
    final db = await init();

    return await db.insert(
      'workout_list',
      item.toMap(),
      // conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getWorkoutList({
    List<int>? durations,
  }) async {
    final db = await init();
    final List<String> conditions = [];
    final List<String> arguments = [];

    if (durations != null && durations.isNotEmpty) {
      conditions.add('workedoutAt >= ? AND workedoutAt <= ?');
      arguments.addAll([durations[0].toString(), durations[1].toString()]);
    }

    String query = 'SELECT * FROM workout_list';

    if (conditions.isNotEmpty) {
      query += ' WHERE ${conditions.join(' AND ')}';
    }

    print(query);
    print(arguments);

    final list = await db.rawQuery(
      query,
      arguments,
    );

    return list;
  }

  Future<List<Map<String, dynamic>>> loadWorkoutListInMonth(
      DateTime firstDay, DateTime lastDay) async {
    final db = await init();
    final list = await db.rawQuery('SELECT * FROM workout_list');
    // final list2 = await db.query('training_set');

    // 'SELECT * FROM workout_list JOIN training_set ON workout_list.id = training_set.workout_list_id WHERE workedoutAt >= ? AND workedoutAt <= ?',
    // [firstDay.microsecondsSinceEpoch, lastDay.microsecondsSinceEpoch],

    print(list);
    // print(list2);

    return list;
  }

  Future<void> insertTrainingSet(
      int workoutId, int workedoutAt, List<TrainingSetItemModel> set) async {
    final db = await init();
    final Batch batch = db.batch();

    for (int index = 0; index < set.length; index++) {
      final TrainingSetItemModel item = set[index];
      batch.insert(
        'training_set',
        item.toMap(
          workoutId,
          index + 1,
          workedoutAt,
        ),
      );
    }

    await batch.commit();
  }

  Future<List<Map<String, dynamic>>> getTrainingSet() async {
    final db = await init();
    final list = await db.query('training_set');

    return list;
  }
}
