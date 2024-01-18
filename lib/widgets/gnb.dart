import 'package:flutter/material.dart';
import 'package:progressive_overload/designs/Pallete.dart';
import 'package:progressive_overload/widgets/add_button.dart';

class GNB extends StatelessWidget {
  const GNB({
    super.key,
    required this.createFitness,
  });

  final void Function(BuildContext context) createFitness;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 83,
      padding: const EdgeInsets.symmetric(
        vertical: 13,
      ),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.09),
            offset: Offset(0, -1),
            blurRadius: 15,
            spreadRadius: 0,
          )
        ],
        color: Colors.white,
      ),
      alignment: Alignment.center,
      child: AddButton(
        onTap: () => createFitness(context),
        size: 56,
        iconSize: 18,
        iconBackgroundColor: Pallete.primary1,
      ),
    );
  }
}
