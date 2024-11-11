import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_overload/model/workout_model.dart';
import 'package:progressive_overload/shared/styles.dart';
import 'package:progressive_overload/widget/typo.dart';
import 'package:intl/intl.dart';
import 'package:progressive_overload/widget/workout_detail_bottom_sheet.dart';

class LoadedWorkout extends StatefulWidget {
  final Workout workout;
  final bool checked;
  final Function(Workout? workout) onChecked;

  const LoadedWorkout({
    super.key,
    required this.workout,
    required this.checked,
    required this.onChecked,
  });

  @override
  _LoadedWorkoutState createState() => _LoadedWorkoutState();
}

class _LoadedWorkoutState extends State<LoadedWorkout> {
  void _openWorkoutDetailBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      backgroundColor: white,
      builder: (context) {
        return WorkoutDetailBottomSheet(
          workout: widget.workout,
        );
      },
    );
  }

  int get setLength {
    if (widget.workout.sets == null) {
      return 0;
    }

    return widget.workout.sets!.length;
  }

  String get workoutName {
    return widget.workout.name;
  }

  dynamic get workoutDate {
    return widget.workout.workoutDate;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 66,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            offset: const Offset(1, 2),
            blurRadius: 11,
            spreadRadius: 0,
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: white,
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          splashColor: Colors.transparent,
          highlightColor: primary3Color,
          onTap: () => widget.onChecked(widget.workout),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                fillColor: WidgetStateColor.resolveWith(
                  (states) {
                    if (!states.contains(WidgetState.selected)) {
                      return Colors.transparent;
                    }

                    return primary1Color;
                  },
                ),
                value: widget.checked,
                onChanged: (bool? val) => widget.onChecked(widget.workout),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Typo.TextOneMedium(
                        '[${setLength.toString()}세트] ${workoutName}',
                        color: black),
                    Typo.TextTwoMedium(
                      DateFormat('yyyy-MM-dd').format(workoutDate),
                      color: darkgrey,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _openWorkoutDetailBottomSheet,
                icon: SvgPicture.asset(
                  'assets/svg/info.svg',
                  color: darkgrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
