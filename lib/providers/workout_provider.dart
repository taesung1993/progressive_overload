import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progressive_overload/models/workout_item_model.dart';
import 'package:progressive_overload/services/sqlite_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final _sqlite = SQLiteService();

class WorkoutNotifier extends StateNotifier<Map<String, dynamic>> {
  WorkoutNotifier() : super({});

  Future<void> addWorkout(WorkoutItemModel newWorkoutItem) async {
    /**
     * 받아야 할 변수
     * 1. 운동 이름
     * 2. 운동 날짜(정수로 변환)
     * 3. training_set
     */
    final inserted = await _sqlite.insertWorkoutItem(newWorkoutItem);
    final list = await _sqlite.getWorkoutList();

    print(list);
  }
}

final workoutProvider =
    StateNotifierProvider<WorkoutNotifier, Map<String, dynamic>>(
        (ref) => WorkoutNotifier());
