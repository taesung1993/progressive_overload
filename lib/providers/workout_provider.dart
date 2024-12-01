import 'package:flutter/material.dart';
import 'package:progressive_overload/database/workout_repository.dart';
import 'package:progressive_overload/model/workout_model.dart';

class WorkoutProvider with ChangeNotifier {
  final repository = WorkoutRepository();

  Future<List<Workout>> fetchWorkouts({DateTime? workoutDate}) async {
    return await repository.getWorkouts(workoutDate: workoutDate);
  }
}
