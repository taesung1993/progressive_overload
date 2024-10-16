class Set {
  int? id;
  int workoutId;
  int reps;
  double weight;
  DateTime createdAt;

  Set({
    this.id,
    required this.workoutId,
    required this.reps,
    required this.weight,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'workout_id': workoutId,
      'reps': reps,
      'weight': weight,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
