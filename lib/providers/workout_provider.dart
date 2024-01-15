import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progressive_overload/models/training_set_item_model.dart';
import 'package:progressive_overload/models/workout_item_model.dart';
import 'package:progressive_overload/services/sqlite_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final _sqlite = SQLiteService();

class WorkoutNotifier extends StateNotifier<Map<String, dynamic>> {
  WorkoutNotifier() : super({});

  Future<void> addWorkout(WorkoutItemModel newWorkout,
      List<TrainingSetItemModel> trainingSet, int workedoutAt) async {
    final workoutId = await _sqlite.insertWorkoutItem(newWorkout);
    await _sqlite.insertTrainingSet(workoutId, workedoutAt, trainingSet);

    final newWorkoutList = await _sqlite.getWorkoutList();
    final newTrainingSet = await _sqlite.getTrainingSet();

    print(newWorkoutList);
    print(newTrainingSet);
  }
}

final workoutProvider =
    StateNotifierProvider<WorkoutNotifier, Map<String, dynamic>>(
        (ref) => WorkoutNotifier());
