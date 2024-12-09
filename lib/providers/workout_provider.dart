import 'package:flutter/material.dart';
import 'package:progressive_overload/database/workout_repository.dart';
import 'package:progressive_overload/model/workout_model.dart';
import 'package:progressive_overload/model/set_model.dart';
import 'package:progressive_overload/providers/date_provider.dart';

enum LoadingStatus { idle, loading, success, error }

class WorkoutProvider with ChangeNotifier {
  WorkoutProvider(this.dateProvider);

  final repository = WorkoutRepository();
  final DateProvider? dateProvider;

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
    final selectedDate = this.dateProvider!.selectedDate;
    await repository.insert(workout, sets);
    await fetchWorkouts(workoutDate: selectedDate);
  }

  Future<void> deleteWorkout(int workoutId) async {
    final selectedDate = this.dateProvider!.selectedDate;
    await repository.deleteWorkout(workoutId);
    await fetchWorkouts(workoutDate: selectedDate);
  }
}
