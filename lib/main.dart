import 'package:flutter/material.dart';
import 'package:progressive_overload/database/workout_repository.dart';
import 'package:progressive_overload/widget/typo.dart';
import 'package:progressive_overload/widget/workout_log.dart';

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
          body: Column(
            children: [
              WorkoutLog(),
              WorkoutLog(),
            ],
          ),
        ),
      ),
    );
  }
}
