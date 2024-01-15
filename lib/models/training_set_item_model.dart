import 'dart:ffi';

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
}
