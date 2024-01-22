import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progressive_overload/models/fitness.dart';
import 'package:progressive_overload/services/sqlite_service.dart';
import 'dart:math';

final _sqlite = SQLiteService();

class FitnessNotifier extends StateNotifier<Map<DateTime, List<Fitness>>> {
  FitnessNotifier() : super({});

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

    for (Fitness item in fitnessList) {
      final key = DateUtils.dateOnly(
          DateTime.fromMillisecondsSinceEpoch(item.fitnessDate));
      final Map<DateTime, List<Fitness>> newState = Map.from(state);

      if (state.containsKey(key)) {
        newState[key]!.add(item);
      } else {
        newState[key] = [item];
      }

      state = newState;
    }
  }

  Future<void> deleteTrainingSet(Fitness fitness, int setId) async {
    final Map<DateTime, List<Fitness>> newState = Map.from(state);
    final key = DateUtils.dateOnly(
        DateTime.fromMillisecondsSinceEpoch(fitness.fitnessDate));
    final trainingSet = await _sqlite.deleteTrainingSet(setId, fitness.id);

    int maxCount = 0;
    double maxWeight = 0.0;

    for (int i = 0; i < trainingSet.length; i++) {
      maxCount = max(maxCount, trainingSet[i].count);
      maxWeight = max(maxWeight, trainingSet[i].weight);
    }

    for (int i = 0; i < newState[key]!.length; i++) {
      if (newState[key]![i].id == fitness.id) {
        newState[key]![i] = Fitness(
          id: fitness.id,
          name: fitness.name,
          maxWeight: maxWeight,
          maxCount: maxCount,
          fitnessDate: fitness.fitnessDate,
          set: trainingSet,
        );
      }
    }

    state = newState;
  }
}

final fitnessProvider =
    StateNotifierProvider<FitnessNotifier, Map<DateTime, List<Fitness>>>(
        (ref) => FitnessNotifier());
