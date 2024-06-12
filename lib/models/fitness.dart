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

  Fitness copyWith({
    required int id,
    required String name,
    required double maxWeight,
    required int maxCount,
    required int fitnessDate,
    required List<TrainingSet> set,
  }) {
    return Fitness(
      id: id,
      name: name,
      maxWeight: maxWeight,
      maxCount: maxCount,
      fitnessDate: fitnessDate,
      set: set,
    );
  }

  void update({required int id}) {
    id = id;
  }

  final int id;
  final String name;
  double maxWeight;
  int maxCount;
  final int fitnessDate;
  List<TrainingSet> set;
}
