import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_overload/shared/styles.dart';
import 'package:progressive_overload/widget/typo.dart';

class WorkoutLog extends StatelessWidget {
  const WorkoutLog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Typo.TextOneMedium('체스트 프레스', color: black),
                Typo.TextOneMedium('5세트', color: black),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SvgPicture.asset(
            'assets/svg/chevron_right.svg',
          ),
        ],
      ),
    );
  }
}
