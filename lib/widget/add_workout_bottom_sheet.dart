import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_overload/database/workout_repository.dart';
import 'package:progressive_overload/shared/styles.dart';
import 'package:progressive_overload/widget/name_text_field.dart';
import 'package:progressive_overload/widget/typo.dart';
import 'package:progressive_overload/model/workout_model.dart';
import 'package:progressive_overload/model/set_model.dart';
import 'package:progressive_overload/widget/workout_set.dart';

class AddWorkoutBottomSheet extends StatefulWidget {
  final Function()? load;

  const AddWorkoutBottomSheet({
    super.key,
    this.load,
  });

  @override
  _AddWorkoutBottomSheetState createState() => _AddWorkoutBottomSheetState();
}

class _AddWorkoutBottomSheetState extends State<AddWorkoutBottomSheet> {
  String workoutName = '';
  final ScrollController _scrollController = ScrollController();
  final List<Set> sets = [];

  bool get isValid {
    if (workoutName.isEmpty) {
      return false;
    }

    if (sets.isEmpty) {
      return false;
    }

    bool isEmpty = sets.every((set) => set.weight == 0 || set.reps == 0);

    if (isEmpty) {
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }

  void _createWorkout(BuildContext context) async {
    Workout workout = Workout(
      name: workoutName,
      workoutDate: DateTime.now(),
      createdAt: DateTime.now(),
    );

    final repository = WorkoutRepository();
    repository.insert(workout, sets);

    Navigator.pop(context);

    if (widget.load != null) {
      widget.load!();
    }
  }

  void _addSet() {
    setState(() {
      sets.add(Set(reps: 0, weight: 0, sequence: sets.length + 1));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _deleteSet(int index) {
    setState(() {
      sets.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: white,
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 56,
              padding: EdgeInsets.only(left: 4, right: 4),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 32),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Typo.headingThreeMedium(
                      '불러오기',
                      color: black,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 24,
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      controller: _scrollController,
                      child: ConstrainedBox(
                        constraints:
                            BoxConstraints(minHeight: constraints.maxHeight),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 8),
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Typo.headingOneBold('운동 기록하기',
                                        color: black),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Column(
                                    children: [
                                      NameTextField(
                                        initialValue: workoutName,
                                        onChanged: (value) {
                                          setState(() {
                                            workoutName = value;
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 24),
                                      for (int i = 0; i < sets.length; i++) ...[
                                        WorkoutSet(
                                          key: ObjectKey(sets[i]),
                                          set: sets[i],
                                          sequence: i + 1,
                                          onDelete: () {
                                            _deleteSet(i);
                                          },
                                          onWeightChanged: (value) {
                                            setState(() {
                                              sets[i].weight = double.parse(
                                                value.isEmpty ? '0' : value,
                                              );
                                            });
                                          },
                                          onRepsChanged: (value) {
                                            setState(() {
                                              sets[i].reps = int.parse(
                                                value.isEmpty ? '0' : value,
                                              );
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 12),
                                      ],
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 16,
                left: 20,
                right: 20,
                bottom: 40,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Material(
                      child: Ink(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          color: black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: _addSet,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/svg/plus.svg',
                              ),
                              const SizedBox(width: 8),
                              Typo.headingThreeBold(
                                '세트 추가',
                                color: white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Material(
                      child: Ink(
                        width: double.infinity,
                        height: 52,
                        decoration: BoxDecoration(
                          color: isValid ? primary1Color : grey,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: isValid ? () => _createWorkout(context) : null,
                          child: Center(
                            child: Typo.headingThreeBold(
                              '등록하기',
                              color: white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
