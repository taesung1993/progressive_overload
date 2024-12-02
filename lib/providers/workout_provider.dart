import 'package:flutter/material.dart';
import 'package:progressive_overload/database/workout_repository.dart';
import 'package:progressive_overload/model/workout_model.dart';
import 'package:progressive_overload/model/set_model.dart';

enum LoadingStatus { idle, loading, success, error }

class WorkoutProvider with ChangeNotifier {
  final repository = WorkoutRepository();
  LoadingStatus _loadingStatus = LoadingStatus.idle;
  List<Workout> _workouts = [];

  get loadingStatus => _loadingStatus;
  get workout => _workouts;

  Future<void> fetchWorkouts({DateTime? workoutDate}) async {
    try {
      _loadingStatus = LoadingStatus.loading;
      notifyListeners();
      _workouts = await repository.getWorkouts(workoutDate: workoutDate);
      _loadingStatus = LoadingStatus.success;
    } catch (error) {
      _loadingStatus = LoadingStatus.error;
    } finally {
      notifyListeners();
    }
  }

  Future<void> addWorkout(Workout workout, List<Set> sets) async {
    await repository.insert(workout, sets);
  }
}
