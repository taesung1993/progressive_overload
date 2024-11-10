import 'package:flutter/material.dart';
import 'package:progressive_overload/shared/styles.dart';
import 'package:progressive_overload/widget/typo.dart';

class NameTextField extends StatefulWidget {
  TextEditingController controller = TextEditingController();
  final bool? enabled;

  NameTextField({
    this.enabled,
    required this.controller,
    super.key,
  });

  @override
  _NameTextFieldState createState() => _NameTextFieldState();
}

class _NameTextFieldState extends State<NameTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      enabled: widget.enabled ?? true,
      keyboardType: TextInputType.text,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        isDense: false,
        hintText: '운동 이름을 입력하세요.',
        hintStyle: text1Regular.copyWith(color: grey),
        contentPadding:
            const EdgeInsets.only(top: 12, left: 16, right: 12, bottom: 12),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: primary1Color),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: grey),
        ),
      ),
      style: head3Medium.copyWith(color: black),
    );
  }
}
