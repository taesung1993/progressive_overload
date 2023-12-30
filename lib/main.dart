import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:progressive_overload/widgets/gnb.dart';
import 'package:progressive_overload/widgets/home_calendar.dart';
import 'package:progressive_overload/widgets/no_fitness.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  HomeCalendar(),
                  NoFitness(),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: GNB(),
      ),
    );
  }
}
