import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_overload/model/set_model.dart';
import 'package:progressive_overload/shared/styles.dart';
import 'package:progressive_overload/widget/RepsTextField.dart';
import 'package:progressive_overload/widget/WeightTextField.dart';
import 'package:progressive_overload/widget/typo.dart';

class WorkoutOverviewBottomSheet extends StatefulWidget {
  final String name;
  final int workoutId;
  final List<Set> sets;

  const WorkoutOverviewBottomSheet({
    required this.name,
    required this.workoutId,
    required this.sets,
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

  String get editableText => isEdit ? '편집취소' : '편집하기';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void toggleEdit() {
    setState(() {
      isEdit = !isEdit;
      if (!isEdit) {
        widget.sets.retainWhere((item) => item.id != null);
      }
    });
  }

  void addSet() {
    setState(() {
      widget.sets.add(Set(weight: 0, reps: 0));
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = max(MediaQuery.of(context).size.height, 534);

    return Container(
      height: height,
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
                            for (int i = 0; i < widget.sets.length; i++) ...[
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 26,
                                      decoration: BoxDecoration(
                                        color: black,
                                        borderRadius: BorderRadius.circular(6),
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
                                          widget.sets[i].weight.toString(),
                                      enabled: isEdit,
                                    ),
                                    RepstTextField(
                                      initialValue:
                                          widget.sets[i].reps.toString(),
                                      enabled: isEdit,
                                    ),
                                    Material(
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: primary2Color,
                                        borderRadius: BorderRadius.circular(6),
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: Center(
                                            child: SvgPicture.asset(
                                              'assets/svg/trash.svg',
                                            ),
                                          ),
                                        ),
                                        onTap: () {},
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
                            child: Container(
                              height: 52,
                              child: Center(
                                child: Typo.headingThreeBold(
                                  '저장하기',
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
    );
  }
}
