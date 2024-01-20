import 'package:flutter/material.dart';
import 'package:progressive_overload/models/fitness.dart';
import 'package:progressive_overload/widgets/fitness_item.dart';

class FitnessList extends StatelessWidget {
  const FitnessList({
    super.key,
    required this.fitnessList,
  });

  final List<Fitness> fitnessList;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 32.0,
      ),
      child: Column(
        children: [
          for (int i = 0; i < fitnessList.length; i++)
            Column(
              children: [
                FitnessItem(
                  name: fitnessList[i].name,
                  totalSetCount: fitnessList[i].set.length,
                ),
                if (i < fitnessList.length - 1) const SizedBox(height: 16),
              ],
            ),
        ],
      ),
    );
  }
}
