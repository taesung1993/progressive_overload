import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_overload/database/workout_repository.dart';

import 'package:progressive_overload/model/workout_model.dart';
import 'package:progressive_overload/model/set_model.dart';
import 'package:progressive_overload/shared/styles.dart';
import 'package:progressive_overload/widget/add_workout_bottom_sheet.dart';

import 'package:progressive_overload/widget/empty_workout.dart';
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

  void openAddBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      useSafeArea: true,
      builder: (BuildContext context) {
        return AddWorkoutBottomSheet(
          load: load,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: white,
      child: Stack(
        children: [
          FutureBuilder(
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
                    child: EmptyWorkout(),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      for (int i = 0; i < snapshot.data!.length; i++) ...[
                        if (i > 0) ...[
                          const SizedBox(
                            width: double.infinity,
                            height: 12,
                          ),
                        ],
                        WorkoutLog(
                          name: snapshot.data![i].name,
                          workoutId: snapshot.data![i].id!,
                          sets: snapshot.data![i].sets!,
                          load: load,
                        ),
                      ]
                    ],
                  ),
                );
              }

              return const Center(
                child: Text('데이터가 없습니다.'),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: 83,
              decoration: BoxDecoration(
                color: white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.09),
                    offset: const Offset(0, -1),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Material(
                    child: Ink(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        color: primary1Color,
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        splashColor: Colors.transparent,
                        highlightColor: primary2Color,
                        onTap: openAddBottomSheet,
                        child: Center(
                          child: SvgPicture.asset(
                            'assets/svg/add.svg',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
