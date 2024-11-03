import 'package:flutter/material.dart';
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
      child: FractionallySizedBox(
        heightFactor: 0.9,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            color: white,
          ),
          padding: const EdgeInsets.only(
            top: 48,
            bottom: 40,
          ),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Typo.headingOneBold('운동 기록하기', color: black),
                    Material(
                      child: Ink(
                        decoration: BoxDecoration(
                          color: drakgrey2,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          child: Container(
                            width: 76,
                            height: 36,
                            alignment: Alignment.center,
                            child: Typo.TextOneMedium(
                              '최근 기록',
                              color: white,
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
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
                                Material(
                                  child: Ink(
                                    width: double.infinity,
                                    height: 52,
                                    decoration: BoxDecoration(
                                      color: black,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: InkWell(
                                      onTap: _addSet,
                                      child: Center(
                                        child: Typo.headingThreeBold(
                                          '세트 추가',
                                          color: white,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
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
                  left: 16,
                  right: 16,
                ),
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
      ),
    );
  }
}
