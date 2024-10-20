import 'package:flutter/material.dart';
import 'package:progressive_overload/shared/styles.dart';
import 'package:progressive_overload/widget/typo.dart';

class RepstTextField extends StatefulWidget {
  final String? initialValue;
  final bool? enabled;
  RepstTextField({this.initialValue, this.enabled, super.key});

  @override
  _WeightTextFieldState createState() => _WeightTextFieldState();
}

class _WeightTextFieldState extends State<RepstTextField> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    if (widget.initialValue != null) {
      controller.text = widget.initialValue!;
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          height: 28,
          child: TextField(
            controller: controller,
            enabled: widget.enabled ?? true,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              isDense: false,
              contentPadding: EdgeInsets.all(0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: lightgrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: primary1Color),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: lightgrey),
              ),
            ),
            style: head3Medium.copyWith(color: black),
          ),
        ),
        const SizedBox(width: 4),
        Typo.TextTwoMedium('회', color: black),
      ],
    );
  }
}
