class Set {
  int? id;
  int reps;
  double weight;
  DateTime createdAt;

  Set({
    this.id,
    required this.reps,
    required this.weight,
    required this.createdAt,
  });

  Map<String, dynamic> toMap(int workoutId) {
    return {
      'id': id,
      'reps': reps,
      'weight': weight,
      'workout_id': workoutId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
