import 'dart:convert';

import 'package:progressive_overload/models/fitness.dart';
import 'package:progressive_overload/models/training_set.dart';
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
              CREATE TABLE fitness_list(
                id INTEGER PRIMARY KEY AUTOINCREMENT, 
                name TEXT NOT NULL, 
                maxWeight FLOAT NOT NULL, 
                maxCount INTEGER NOT NULL, 
                fitnessDate INTEGER NOT NULL
              )
            ''');
        await db.execute('''
        CREATE TABLE training_set (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          weight FLOAT NOT NULL,
          count INTEGER NOT NULL,
          fitness_id INTEGER NOT NULL,
          FOREIGN KEY (fitness_id) REFERENCES fitness_list (id)
          ON DELETE CASCADE ON UPDATE CASCADE
        )
      ''');
      },
    );

    return database;
  }

  Future<int> insertFitness({
    required String name,
    required double maxWeight,
    required int maxCount,
    required int fitnessDate,
  }) async {
    final db = await init();

    return await db.insert(
      'fitness_list',
      {
        "name": name,
        "maxWeight": maxWeight,
        "maxCount": maxCount,
        "fitnessDate": fitnessDate,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Fitness>> getFitnessList({
    List<int>? durations,
  }) async {
    final db = await init();
    final List<String> conditions = [];
    final List<String> arguments = [];

    if (durations != null && durations.isNotEmpty) {
      conditions.add('fitnessDate >= ? AND fitnessDate <= ?');
      arguments.addAll([durations[0].toString(), durations[1].toString()]);
    }

    String query = '''SELECT 
      F.*, 
      json_group_array(
          json_object(
              'id', T.id,
              'weight', T.weight,
              'count', T.count
          )
      ) AS trainingSet
      FROM fitness_list F
      LEFT JOIN training_set T ON F.id = T.fitness_id
      GROUP BY F.id
    ''';

    if (conditions.isNotEmpty) {
      query += ' WHERE ${conditions.join(' AND ')}';
    }

    final raw = await db.rawQuery(
      query,
      arguments,
    );

    final data =
        raw.toList().where((element) => element['id'] != null).toList();
    final List<Fitness> fitnessList = [];

    for (Map<String, Object?> item in data) {
      List<dynamic> trainingSet = json.decode(item['trainingSet'].toString());

      fitnessList.add(Fitness(
        id: int.parse(item["id"].toString()),
        name: item["name"].toString(),
        maxWeight: double.parse(item["maxWeight"].toString()),
        maxCount: int.parse(item["maxCount"].toString()),
        fitnessDate: int.parse(item["fitnessDate"].toString()),
        set: trainingSet
            .map(
              (setItem) => TrainingSet(
                id: int.parse(setItem["id"].toString()),
                weight: double.parse(setItem["weight"].toString()),
                count: int.parse(setItem["count"].toString()),
              ),
            )
            .toList(),
      ));
    }

    return fitnessList;
  }

  Future<void> deleteFitness(int fitness_id) async {
    final db = await init();
    await db.delete(
      'fitness_list',
      where: 'id = ?',
      whereArgs: [fitness_id],
    );
  }

  Future<void> insertTrainingSet(
      int fitnessId, List<Map<String, String>> set) async {
    final db = await init();
    final Batch batch = db.batch();

    for (int index = 0; index < set.length; index++) {
      final Map<String, String> item = set[index];
      batch.insert('training_set', {
        "weight": item["enteredWeight"]!,
        "count": item["enteredWeight"]!,
        "fitness_id": fitnessId,
      });
    }

    await batch.commit();
  }

  Future<List<Map<String, dynamic>>> getTrainingSet() async {
    final db = await init();
    final list = await db.rawQuery('SELECT * FROM training_set');

    return list;
  }

  Future<List<TrainingSet>> deleteTrainingSet(int id, int fitness_id) async {
    final db = await init();
    await db.delete(
      'training_set',
      where: 'id = ?',
      whereArgs: [id],
    );
    final raw = await db.rawQuery(
        'SELECT * FROM training_set T WHERE T.fitness_id = $fitness_id');

    final list = raw
        .map(
          (item) => TrainingSet(
              id: item["id"] as int,
              weight: item['weight'] as double,
              count: item['count'] as int),
        )
        .toList();

    return list;
  }
}
