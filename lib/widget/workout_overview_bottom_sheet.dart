import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_overload/database/workout_repository.dart';
import 'package:progressive_overload/model/set_model.dart';
import 'package:progressive_overload/shared/styles.dart';
import 'package:progressive_overload/widget/RepsTextField.dart';
import 'package:progressive_overload/widget/WeightTextField.dart';
import 'package:progressive_overload/widget/typo.dart';

class WorkoutOverviewBottomSheet extends StatefulWidget {
  final String name;
  final int workoutId;
  final List<Set> sets;
  final Function()? load;

  const WorkoutOverviewBottomSheet({
    required this.name,
    required this.workoutId,
    required this.sets,
    this.load,
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
  final repository = WorkoutRepository();

  String get editableText => isEdit ? '편집취소' : '편집하기';

  @override
  void initState() {
    // TODO: implement initState
    copiedSets = List.from(widget.sets);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void toggleEdit() {
    setState(() {
      isEdit = !isEdit;
      if (!isEdit) {
        copiedSets = List.from(widget.sets);
      }
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

    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            insetPadding: EdgeInsets.zero,
            clipBehavior: Clip.hardEdge,
            backgroundColor: white,
            child: SizedBox(
              width: 288,
              height: 133,
              child: Column(
                children: [
                  Container(
                    width: 288,
                    height: 86,
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 16,
                      right: 16,
                      bottom: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Typo.headingThreeBold("운동 삭제", color: black),
                        Typo.TextOneRegular('운동 기록을 삭제하시겠습니까?', color: black),
                      ],
                    ),
                  ),
                  Container(height: 1, width: 288, color: darkgrey),
                  Row(
                    children: [
                      Expanded(
                        child: Ink(
                          height: 46,
                          child: InkWell(
                            child: Center(
                              child: Typo.headingThreeMedium('취소',
                                  color: primary1Color),
                            ),
                            onTap: () {},
                          ),
                        ),
                      ),
                      Container(
                        height: 46,
                        width: 1,
                        color: darkgrey,
                      ),
                      Expanded(
                        child: Ink(
                          height: 46,
                          child: InkWell(
                            child: Center(
                              child: Typo.headingThreeMedium('삭제하기',
                                  color: primary1Color),
                            ),
                            onTap: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void saveSet() async {
    List<Set> newSets = List.from(copiedSets);

    for (int i = 0; i < newSets.length; i++) {
      newSets[i].sequence = i + 1;
    }

    await repository.replaceSets(newSets, widget.workoutId);
    await repository.getWorkouts();

    if (widget.load != null) {
      widget.load!();
    }

    setState(() {
      isEdit = false;
      copiedSets = List.from(newSets);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = max(MediaQuery.of(context).size.height, 534);

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: 534,
        child: Column(
          children: [
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
                  left: 16,
                  right: 16,
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
                          child: Column(
                            children: [
                              for (int i = 0; i < copiedSets.length; i++) ...[
                                if (i > 0) ...[
                                  const SizedBox(
                                    width: double.infinity,
                                    height: 10,
                                  ),
                                ],
                                Container(
                                  key: ValueKey(copiedSets[i].sequence),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                      WeightTextField(
                                        initialValue:
                                            copiedSets[i].weight.toString(),
                                        enabled: isEdit,
                                        onChanged: (value) {
                                          setState(() {
                                            copiedSets[i].weight = double.parse(
                                              value,
                                            );
                                          });
                                        },
                                      ),
                                      RepstTextField(
                                        initialValue:
                                            copiedSets[i].reps.toString(),
                                        enabled: isEdit,
                                        onChanged: (value) {
                                          setState(() {
                                            copiedSets[i].reps = int.parse(
                                              value,
                                            );
                                          });
                                        },
                                      ),
                                      Material(
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: primary2Color,
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          onTap: () => deleteSet(i),
                                          child: SizedBox(
                                            width: 24,
                                            height: 24,
                                            child: Center(
                                              child: SvgPicture.asset(
                                                'assets/svg/trash.svg',
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ]
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
                        child: Container(
                          width: double.infinity,
                          height: 52,
                          child: Center(
                            child: Typo.headingThreeBold(
                              '운동 삭제',
                              color: white,
                            ),
                          ),
                        ),
                        onTap: () {
                          print('삭제합니다.');
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
