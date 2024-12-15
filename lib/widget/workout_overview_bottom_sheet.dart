import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_overload/model/set_model.dart';
import 'package:progressive_overload/providers/workout_provider.dart';
import 'package:progressive_overload/shared/styles.dart';
import 'package:progressive_overload/widget/confirm_dialog.dart';
import 'package:progressive_overload/widget/typo.dart';
import 'package:progressive_overload/widget/workout_set.dart';
import 'package:provider/provider.dart';

class WorkoutOverviewBottomSheet extends StatefulWidget {
  final String name;
  final int workoutId;
  final List<Set> sets;
  final Function()? close;

  const WorkoutOverviewBottomSheet({
    required this.name,
    required this.workoutId,
    required this.sets,
    this.close,
    super.key,
  });

  @override
  _WorkoutOverviewBottomSheetState createState() =>
      _WorkoutOverviewBottomSheetState();
}

class _WorkoutOverviewBottomSheetState
    extends State<WorkoutOverviewBottomSheet> {
  bool isEdit = false;
  ScrollController _scrollController = ScrollController();

  late List<Set> copiedSets;
  late WorkoutProvider workoutProvider;

  String get editableText => isEdit ? '편집취소' : '편집하기';

  @override
  void initState() {
    // TODO: implement initState
    copiedSets = widget.sets
        .map((set) => Set(
              weight: set.weight,
              reps: set.reps,
              sequence: set.sequence,
            ))
        .toList();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void deleteWorkout() {
    onConfirm() async {
      await workoutProvider.deleteWorkout(widget.workoutId);

      if (widget.close != null) {
        widget.close!();
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          title: '운동 삭제',
          description: '운동을 삭제하시겠습니까?',
          onConfirm: onConfirm,
        );
      },
    );
  }

  void toggleEdit() {
    setState(() {
      isEdit = !isEdit;
      copiedSets = widget.sets
          .map((set) => Set(
                weight: set.weight,
                reps: set.reps,
                sequence: set.sequence,
              ))
          .toList();
    });
  }

  void addSet() {
    setState(() {
      copiedSets.add(
        Set(weight: 0, reps: 0, sequence: copiedSets.length + 1),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void deleteSet(int index) {
    if (isEdit) {
      setState(() {
        copiedSets.removeAt(index);
      });
      return;
    }

    onConfirm() async {
      List<Set> newSets = List.from(copiedSets)
          .asMap()
          .entries
          .where((entry) => entry.key != index)
          .map((entry) => Set(
                weight: entry.value.weight,
                reps: entry.value.reps,
                sequence: entry.key + 1,
              ))
          .toList();

      await workoutProvider.replaceSets(
        workoutId: widget.workoutId,
        sets: newSets,
      );

      setState(() {
        copiedSets = List.from(newSets);
      });
    }

    showDialog(
      context: context,
      builder: (context) {
        return ConfirmDialog(
          title: '세트 삭제',
          description: '해당 세트를 삭제하시겠습니까?',
          onConfirm: onConfirm,
        );
      },
    );
  }

  void saveSet() async {
    List<Set> newSets = copiedSets
        .asMap()
        .entries
        .map((entry) => Set(
              sequence: entry.key + 1,
              weight: entry.value.weight,
              reps: entry.value.reps,
            ))
        .toList();

    await workoutProvider.replaceSets(
      workoutId: widget.workoutId,
      sets: newSets,
    );

    setState(() {
      isEdit = false;
      copiedSets = List.from(newSets);
    });
  }

  @override
  Widget build(BuildContext context) {
    workoutProvider = Provider.of<WorkoutProvider>(context, listen: false);

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        width: double.infinity,
        height: 534,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 54),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Typo.headingOneBold(
                  widget.name,
                  color: black,
                ),
                TextButton(
                  onPressed: toggleEdit,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Typo.TextOneRegular(editableText, color: black),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(
                top: 30,
                bottom: 40,
              ),
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return SingleChildScrollView(
                    controller: _scrollController,
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
                              for (int i = 0; i < copiedSets.length; i++) ...[
                                if (i > 0) ...[
                                  const SizedBox(
                                    width: double.infinity,
                                    height: 10,
                                  ),
                                ],
                                WorkoutSet(
                                  key: ObjectKey(copiedSets[i]),
                                  set: copiedSets[i],
                                  sequence: i + 1,
                                  isEdit: isEdit,
                                  onDelete: () {
                                    if (copiedSets.length > 1) {
                                      deleteSet(i);
                                      return;
                                    }

                                    deleteWorkout();
                                  },
                                  onRepsChanged: (value) {
                                    setState(() {
                                      copiedSets[i].reps = int.parse(
                                        value.isEmpty ? '0' : value,
                                      );
                                    });
                                  },
                                  onWeightChanged: (value) {
                                    setState(() {
                                      copiedSets[i].weight = double.parse(
                                        value.isEmpty ? '0' : value,
                                      );
                                    });
                                  },
                                )
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
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 40),
            child: isEdit
                ? Row(
                    children: [
                      Expanded(
                        child: Ink(
                          decoration: BoxDecoration(
                            color: black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: addSet,
                            child: SizedBox(
                              height: 52,
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
                        child: Ink(
                          decoration: BoxDecoration(
                            color: primary1Color,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: saveSet,
                            child: SizedBox(
                              height: 52,
                              child: Center(
                                child: Typo.headingThreeBold(
                                  '저장하기',
                                  color: white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : Ink(
                    decoration: BoxDecoration(
                      color: red1,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: deleteWorkout,
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: Center(
                          child: Typo.headingThreeBold(
                            '운동 삭제',
                            color: white,
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
        ]),
      ),
    );
  }
}
