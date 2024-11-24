import 'package:flutter/material.dart';
import 'package:progressive_overload/shared/styles.dart';
import 'package:progressive_overload/widget/typo.dart';

class EmptyWorkout extends StatelessWidget {
  const EmptyWorkout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Typo.headingTwoBold(
          '아직 운동을 시작하지 않았어요!',
          color: black,
        ),
        Typo.TextOneRegular('오늘 하루도 힘차게 출발해보아요💪🏻', color: black),
        const SizedBox(
          height: 28,
        ),
        Material(
          child: Ink(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              color: primary1Color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              splashColor: Colors.transparent,
              highlightColor: primary2Color,
              child: Container(
                width: double.infinity,
                height: 48,
                child: Center(
                  child: Typo.TextOneBold(
                    '운동 시작하기',
                    color: white,
                  ),
                ),
              ),
              onTap: () {},
            ),
          ),
        ),
      ],
    );
  }
}
