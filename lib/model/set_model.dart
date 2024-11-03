class Set {
  int? id;
  int reps;
  int sequence;
  double weight;
  DateTime? createdAt;

  Set({
    this.id,
    required this.reps,
    required this.sequence,
    required this.weight,
    this.createdAt,
  });

  Map<String, dynamic> toMap(int workoutId) {
    return {
      'id': id,
      'reps': reps,
      'weight': weight,
      'sequence': sequence,
      'workout_id': workoutId,
    };
  }
}
