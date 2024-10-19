import 'dart:math';

import 'package:flutter/material.dart';
import 'package:progressive_overload/model/set_model.dart';
import 'package:progressive_overload/shared/styles.dart';
import 'package:progressive_overload/widget/typo.dart';

class WorkoutOverviewBottomSheet extends StatelessWidget {
  final String name;
  final List<Set> sets;

  const WorkoutOverviewBottomSheet({
    required this.name,
    required this.sets,
    super.key,
  });

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
                  name,
                  color: black,
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                  ),
                  child: Typo.TextOneRegular('편집하기', color: black),
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
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            for (int i = 0; i < sets.length; i++) ...[
                              if (i > 0) ...[
                                const SizedBox(
                                  width: double.infinity,
                                  height: 10,
                                ),
                              ],
                              Row(
                                children: [
                                  Chip(
                                    label: Typo.TextTwoMedium(
                                      '${i + 1} 세트',
                                      color: white,
                                    ),
                                    backgroundColor: black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ],
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
            child: Ink(
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
