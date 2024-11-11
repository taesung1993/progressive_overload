import 'package:flutter/material.dart';
import 'package:progressive_overload/model/workout_model.dart';
import 'package:progressive_overload/shared/styles.dart';
import 'package:progressive_overload/widget/typo.dart';
import 'package:progressive_overload/widget/workout_set.dart';

class WorkoutDetailBottomSheet extends StatelessWidget {
  final Workout workout;
  const WorkoutDetailBottomSheet({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        width: double.infinity,
        height: 534,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 54),
              child: Typo.headingOneBold(
                workout.name,
                color: black,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  bottom: 40,
                ),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            child: Column(
                              children: [
                                for (int i = 0;
                                    i < workout.sets!.length;
                                    i++) ...[
                                  if (i > 0) ...[
                                    const SizedBox(
                                      width: double.infinity,
                                      height: 10,
                                    ),
                                  ],
                                  Container(
                                    width: double.infinity,
                                    height: 52,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    decoration: BoxDecoration(
                                      color: white,
                                      borderRadius: BorderRadius.circular(7),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromRGBO(0, 0, 0, 0.08),
                                          offset: Offset(1, 2),
                                          blurRadius: 11,
                                          spreadRadius: 0,
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 60,
                                          height: 26,
                                          decoration: BoxDecoration(
                                            color: black,
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Center(
                                            child: Typo.TextTwoMedium(
                                              '${i + 1} 세트',
                                              color: white,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Typo.headingThreeMedium(
                                                '${workout.sets![i].weight} kg',
                                                color: black,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 4),
                                        SizedBox(
                                          width: 12,
                                          child: Center(
                                            child: Typo.headingThreeMedium(
                                              '/',
                                              color: black,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 40,
                                          alignment: Alignment.centerRight,
                                          child: Typo.headingThreeMedium(
                                            '${workout.sets![i].reps} 회',
                                            color: black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
