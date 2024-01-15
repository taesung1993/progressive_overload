class TrainingSetItemModel {
  TrainingSetItemModel({
    this.enteredWeight = '',
    this.enteredCount = '',
  });

  String enteredWeight;
  String enteredCount;

  double get weight {
    return double.parse(enteredWeight);
  }

  int get count {
    return int.parse(enteredCount);
  }

  Map<String, dynamic> toMap(int workoutId, int sequence, int workedoutAt) {
    return {
      'sequence': sequence,
      'weight': weight,
      'count': count,
      'workedoutAt': workedoutAt,
      'workout_list_id': workoutId,
    };
  }
}
