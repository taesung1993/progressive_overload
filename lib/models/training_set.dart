class TrainingSet {
  const TrainingSet({
    required this.id,
    required this.sequence,
    required this.weight,
    required this.count,
  });

  final int id;
  final int sequence;
  final double weight;
  final int count;
}
