import 'package:flutter/material.dart';
import 'package:progressive_overload/model/workout_model.dart';
import 'package:progressive_overload/widget/workout_log.dart';

class WorkoutLogList extends StatefulWidget {
  final List<Workout> workoutList;

  const WorkoutLogList({
    super.key,
    required this.workoutList,
  });

  @override
  _WorkoutLogListState createState() => _WorkoutLogListState();
}

class _WorkoutLogListState extends State<WorkoutLogList> {
  List<Workout> get workoutList {
    return widget.workoutList;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 20, left: 16, right: 16),
      child: Column(
        children: [
          for (int i = 0; i < workoutList.length; i++) ...[
            if (i > 0) ...[
              const SizedBox(
                width: double.infinity,
                height: 12,
              ),
            ],
            WorkoutLog(
              name: workoutList[i].name,
              workoutId: workoutList[i].id!,
              sets: workoutList[i].sets!,
            ),
          ]
        ],
      ),
    );
  }
}
