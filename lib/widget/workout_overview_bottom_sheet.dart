import 'dart:math';

import 'package:flutter/material.dart';
import 'package:progressive_overload/model/set_model.dart';

class WorkoutOverviewBottomSheet extends StatelessWidget {
  final String name;
  final List<Set> sets;

  const WorkoutOverviewBottomSheet({
    required this.name,
    required this.sets,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double height = max(MediaQuery.of(context).size.height, 534);

    return Container(
      height: height,
      child: const Center(
        child: Text('This is modal bottom sheet'),
      ),
    );
  }
}
