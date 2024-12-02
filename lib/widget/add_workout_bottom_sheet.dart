import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_overload/providers/date_provider.dart';
import 'package:progressive_overload/providers/workout_provider.dart';
import 'package:progressive_overload/shared/styles.dart';
import 'package:progressive_overload/widget/load_workout_bottom_sheet.dart';
import 'package:progressive_overload/widget/name_text_field.dart';
import 'package:progressive_overload/widget/typo.dart';
import 'package:progressive_overload/model/workout_model.dart';
import 'package:progressive_overload/model/set_model.dart';
import 'package:progressive_overload/widget/workout_set.dart';
import 'package:provider/provider.dart';

class AddWorkoutBottomSheet extends StatefulWidget {
  Function(Workout workout, List<Set> sets)? onAdd;

  AddWorkoutBottomSheet({
    super.key,
    this.onAdd,
  });

  @override
  _AddWorkoutBottomSheetState createState() => _AddWorkoutBottomSheetState();
}

class _AddWorkoutBottomSheetState extends State<AddWorkoutBottomSheet> {
  final ScrollController _scrollController = ScrollController();
  List<Set> sets = [];
  TextEditingController _nameController = TextEditingController();

  String get workoutName {
    return _nameController.text;
  }

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
    final workoutProvider =
        Provider.of<WorkoutProvider>(context, listen: false);
    final dateProvider = Provider.of<DateProvider>(context, listen: false);
    final selectedDate = dateProvider.selectedDate;

    Workout newWorkout = Workout(
      name: workoutName,
      workoutDate: DateTime.now(),
      createdAt: DateTime.now(),
    );

    List<Set> newSets = List.generate(sets.length, (i) {
      return Set(
        reps: sets[i].reps,
        weight: sets[i].weight,
        sequence: i + 1,
      );
    });

    await workoutProvider.addWorkout(newWorkout, newSets);
    await workoutProvider.fetchWorkouts(workoutDate: selectedDate);
    Navigator.pop(context);
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

  void _openLoadWorkoutBottomSheet() async {
    final workout = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      useSafeArea: true,
      builder: (BuildContext context) {
        return const LoadWorkoutBottomSheet();
      },
    );

    if (workout == null) {
      return;
    }

    setState(() {
      _nameController.text = workout.name;
      sets = workout.sets;
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
              padding: const EdgeInsets.only(left: 4, right: 4),
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
                    onPressed: _openLoadWorkoutBottomSheet,
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
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  children: [
                                    NameTextField(
                                      controller: _nameController,
                                    ),
                                    const SizedBox(height: 24),
                                    if (sets.isEmpty)
                                      Column(
                                        children: [
                                          const SizedBox(height: 48),
                                          Typo.headingTwoBold(
                                            '저런! 아직 세트가 없어요..',
                                            color: darkgrey,
                                          ),
                                          Typo.headingThreeMedium(
                                            '세트를 추가해서 운동을 기록해보세요.',
                                            color: grey,
                                          ),
                                        ],
                                      ),
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
                                ),
                              ),
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
              padding: const EdgeInsets.only(
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
