import 'package:flutter/material.dart';
import 'package:progressive_overload/database/workout_repository.dart';

import 'package:progressive_overload/model/workout_model.dart';
import 'package:progressive_overload/model/set_model.dart';

import 'package:progressive_overload/widget/workout_log.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final repository = WorkoutRepository();

  Future<List<Workout>> getWorkouts() async {
    final repository = WorkoutRepository();
    // Workout workout1 = Workout(
    //   name: '데드리프트',
    //   workoutDate: DateTime.now(),
    //   createdAt: DateTime.now(),
    // );

    // List<Set> sets1 = [
    //   Set(reps: 10, weight: 60.5, sequence: 1),
    //   Set(reps: 10, weight: 70, sequence: 2),
    //   Set(reps: 10, weight: 80, sequence: 3),
    // ];

    // Workout workout2 = Workout(
    //   name: '스쿼트',
    //   workoutDate: DateTime.now(),
    //   createdAt: DateTime.now(),
    // );

    // List<Set> sets2 = [
    //   Set(reps: 10, weight: 60.5, sequence: 1),
    //   Set(reps: 10, weight: 70, sequence: 2),
    //   Set(reps: 10, weight: 80, sequence: 3),
    // ];

    // await repository.insert(workout1, sets1);
    // await repository.insert(workout2, sets2);

    return await repository.getWorkouts();
  }

  void load() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getWorkouts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasData) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data!.isEmpty) {
            return const Center(
              child: Text('데이터가 없습니다.'),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                for (int i = 0; i < snapshot.data!.length; i++)
                  WorkoutLog(
                    name: snapshot.data![i].name,
                    workoutId: snapshot.data![i].id!,
                    sets: snapshot.data![i].sets!,
                    load: load,
                  ),
              ],
            ),
          );
        }

        return const Center(
          child: Text('데이터가 없습니다.'),
        );
      },
    );
  }
}
