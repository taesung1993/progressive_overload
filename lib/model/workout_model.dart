import 'package:progressive_overload/model/set_model.dart';

class Workout {
  int? id;
  String name;
  DateTime workoutDate;
  DateTime createdAt;
  List<Set> sets;

  Workout({
    this.id,
    required this.name,
    required this.workoutDate,
    required this.createdAt,
    required this.sets,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'workout_date': workoutDate.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
