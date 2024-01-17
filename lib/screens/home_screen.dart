import 'package:flutter/material.dart';
import 'package:progressive_overload/widgets/home_calendar.dart';
import 'package:progressive_overload/widgets/no_fitness.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.createWorkout,
  });

  final void Function(BuildContext context) createWorkout;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const HomeCalendar(),
            NoFitness(
              createWorkout: createWorkout,
            ),
          ],
        ),
      ),
    );
  }
}
