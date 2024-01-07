import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:progressive_overload/screens/home_screen.dart';
import 'package:progressive_overload/widgets/creating_workout_bottom_sheet.dart';
import 'package:progressive_overload/widgets/gnb.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void _openCreatingWorkoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      builder: (context) {
        return const CreatingWorkoutBottomSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: HomeScreen(
            createWorkout: _openCreatingWorkoutBottomSheet,
          ),
        ),
        bottomNavigationBar: GNB(
          createWorkout: _openCreatingWorkoutBottomSheet,
        ),
      ),
    );
  }
}
