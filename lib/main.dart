import 'package:flutter/material.dart';
import 'package:progressive_overload/screen/workout_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: SafeArea(
        child: Scaffold(
          body: WorkoutScreen(),
        ),
      ),
    );
  }
}
