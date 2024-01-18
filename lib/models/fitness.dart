import 'package:progressive_overload/models/training_set.dart';

class Fitness {
  Fitness({
    required this.id,
    required this.name,
    required this.maxWeight,
    required this.maxCount,
    required this.fitnessDate,
    required this.set,
  });

  final int id;
  final String name;
  final double maxWeight;
  final int maxCount;
  final int fitnessDate;
  final List<TrainingSet> set;
}
