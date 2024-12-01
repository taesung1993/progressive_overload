import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_overload/database/workout_repository.dart';

import 'package:progressive_overload/model/workout_model.dart';
import 'package:progressive_overload/shared/styles.dart';
import 'package:progressive_overload/widget/add_workout_bottom_sheet.dart';

import 'package:progressive_overload/widget/empty_workout.dart';
import 'package:progressive_overload/widget/workout_calendar.dart';
import 'package:progressive_overload/widget/workout_log.dart';
import 'package:progressive_overload/widget/workout_log_list.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({Key? key}) : super(key: key);

  @override
  _WorkoutScreenState createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final repository = WorkoutRepository();
  DateTime workoutDate = DateTime.now();

  Future<List<Workout>> getWorkouts({DateTime? workoutDate}) async {
    final repository = WorkoutRepository();
    return await repository.getWorkouts(
      workoutDate: workoutDate,
    );
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Expanded(
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: WorkoutCalendar(
                            onSelectedDate: (selectedDate) {
                              setState(() {
                                workoutDate = selectedDate;
                              });
                            },
                          ),
                        ),
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: FutureBuilder(
                            future: getWorkouts(
                              workoutDate: workoutDate,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (snapshot.hasError) {
                                final error = (snapshot.error).toString();

                                return Center(
                                  child: Text('에러가 발생했습니다. $error'),
                                );
                              }

                              if (snapshot.hasData) {
                                if (snapshot.data == null) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                if (snapshot.data!.isEmpty) {
                                  return EmptyWorkout(
                                    openAddBottomSheet: openAddBottomSheet,
                                  );
                                }

                                return WorkoutLogList(
                                  workoutList: snapshot.data ?? [],
                                  load: load,
                                );
                              }

                              return const Center(
                                child: Text('데이터가 없습니다.'),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
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
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
