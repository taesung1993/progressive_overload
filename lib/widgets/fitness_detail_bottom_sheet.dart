import 'package:flutter/material.dart';

class FitnessDetailBottomSheet extends StatelessWidget {
  const FitnessDetailBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        Container(
          height: 534,
          padding: const EdgeInsets.only(
            top: 54,
            left: 16,
            right: 16,
            bottom: 40,
          ),
        ),
        Positioned(
          top: 10,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xffCED3DE).withOpacity(0.5),
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
          ),
        )
      ],
    );
  }
}
