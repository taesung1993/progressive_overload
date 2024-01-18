import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progressive_overload/models/fitness.dart';
import 'package:progressive_overload/services/sqlite_service.dart';

final _sqlite = SQLiteService();

class FitnessNotifier extends StateNotifier<List<Fitness>> {
  FitnessNotifier() : super([]);

  Future<void> addFitness({
    required String name,
    required double maxWeight,
    required int maxCount,
    required int fitnessDate,
    required List<Map<String, String>> trainingSet,
  }) async {
    final fitnessId = await _sqlite.insertFitness(
      name: name,
      maxCount: maxCount,
      maxWeight: maxWeight,
      fitnessDate: fitnessDate,
    );
    await _sqlite.insertTrainingSet(fitnessId, trainingSet);
  }

  Future<void> loadFitnessList() async {
    List<Fitness> fitnessList = await _sqlite.getFitnessList();

    state = fitnessList;
  }
}

final fitnessProvider = StateNotifierProvider<FitnessNotifier, List<Fitness>>(
    (ref) => FitnessNotifier());
