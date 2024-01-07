import 'package:flutter/material.dart';

class CreatingWorkoutBottomSheet extends StatefulWidget {
  const CreatingWorkoutBottomSheet({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CreatingWorkoutBottomSheet();
  }
}

class _CreatingWorkoutBottomSheet extends State<CreatingWorkoutBottomSheet> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        Container(
          height: 726,
          padding: const EdgeInsets.only(
            top: 48,
            left: 16,
            right: 16,
            bottom: 40,
          ),
          child: Center(
            child: ElevatedButton(
              child: Text('버튼'),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  builder: (context) {
                    return Center(
                      child: Text('hello'),
                    );
                  },
                );
              },
            ),
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
