import 'package:progressive_overload/widgets/training_set_item.dart';

class WorkoutItem {
  WorkoutItem({
    required this.name,
    required this.maxWeightInTrainingSet,
    required this.maxCountInTrainingSet,
    required this.workedoutAt,
  });

  final String name;
  final double maxWeightInTrainingSet;
  final int maxCountInTrainingSet;
  final int workedoutAt;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'maxWeightInTrainingSet': maxWeightInTrainingSet,
      'maxCountInTrainingSet': maxCountInTrainingSet,
      'workedoutAt': workedoutAt,
    };
  }
}
