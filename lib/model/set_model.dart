class Set {
  int? id;
  int reps;
  double weight;
  DateTime? createdAt;

  Set({
    this.id,
    required this.reps,
    required this.weight,
    this.createdAt,
  });

  Map<String, dynamic> toMap(int workoutId) {
    return {
      'id': id,
      'reps': reps,
      'weight': weight,
      'workout_id': workoutId,
    };
  }
}
