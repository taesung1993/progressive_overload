import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_overload/model/set_model.dart';
import 'package:progressive_overload/shared/styles.dart';
import 'package:progressive_overload/widget/reps_text_field.dart';
import 'package:progressive_overload/widget/typo.dart';
import 'package:progressive_overload/widget/weight_text_field.dart';

class WorkoutSet extends StatefulWidget {
  final Set set;
  final int sequence;
  final Function() onDelete;

  Function(String value)? onRepsChanged;
  Function(String value)? onWeightChanged;
  bool? isEdit;

  WorkoutSet({
    super.key,
    required this.set,
    required this.sequence,
    required this.onDelete,
    this.onRepsChanged,
    this.onWeightChanged,
    this.isEdit,
  });

  @override
  _WorkoutSetState createState() => _WorkoutSetState();
}

class _WorkoutSetState extends State<WorkoutSet> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                '${widget.sequence} 세트',
                color: white,
              ),
            ),
          ),
          WeightTextField(
            initialValue: widget.set.weight.toString(),
            enabled: widget.isEdit ?? true,
            onChanged: (value) {
              if (widget.onWeightChanged != null) {
                widget.onWeightChanged!(value);
              }
            },
          ),
          RepsTextField(
            initialValue: widget.set.reps.toString(),
            enabled: widget.isEdit ?? true,
            onChanged: (value) {
              if (widget.onRepsChanged != null) {
                widget.onRepsChanged!(value);
              }
            },
          ),
          Material(
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: primary2Color,
              borderRadius: BorderRadius.circular(6),
              onTap: () => {widget.onDelete()},
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
    );
  }
}
