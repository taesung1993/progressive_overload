import 'package:progressive_overload/widgets/training_set_item.dart';

class WorkoutItem {
  WorkoutItem({
    required this.name,
    required this.weight,
    required this.count,
    required this.workedoutAt,
    required this.set,
  });

  final String name;
  final double weight;
  final int count;
  final DateTime workedoutAt;
  final List<TrainingSetItem> set;
}
