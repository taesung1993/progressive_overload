import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_overload/shared/styles.dart';
import 'package:progressive_overload/widget/typo.dart';
import 'package:progressive_overload/model/set_model.dart';
import 'package:progressive_overload/widget/workout_overview_bottom_sheet.dart';

class WorkoutLog extends StatelessWidget {
  final String name;
  final int workoutId;
  final List<Set> sets;
  final Function()? load;

  const WorkoutLog({
    required this.name,
    required this.workoutId,
    required this.sets,
    this.load,
    super.key,
  });

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return WorkoutOverviewBottomSheet(
          name: name,
          workoutId: workoutId,
          sets: sets,
          load: load,
          close: () => Navigator.pop(context),
        );
      },
    );
  }

  get lengthOfSet {
    return sets.length;
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.08),
            offset: Offset(1, 2),
            blurRadius: 11,
            spreadRadius: 0,
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        splashColor: Colors.transparent,
        highlightColor: primary3Color,
        child: Container(
          width: double.infinity,
          height: 52,
          padding:
              const EdgeInsets.only(left: 16, right: 8, top: 16, bottom: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Typo.TextOneMedium(name, color: black),
                    Typo.TextOneMedium('$lengthOfSet 세트', color: black),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              SvgPicture.asset(
                'assets/svg/chevron_right.svg',
              ),
            ],
          ),
        ),
        onTap: () => showBottomSheet(context),
      ),
    );
  }
}
