import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:progressive_overload/providers/date_provider.dart';
import 'package:progressive_overload/providers/workout_provider.dart';
import 'package:progressive_overload/screen/workout_screen.dart';
import 'package:provider/provider.dart';

void main() {
  initializeDateFormatting().then((_) => runApp(
        MultiProvider(providers: [
          ChangeNotifierProvider(
            create: (_) => DateProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => WorkoutProvider()..fetchWorkouts(),
          )
        ], child: const MyApp()),
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Progressive Overload',
      home: SafeArea(
        child: Scaffold(
          body: WorkoutScreen(),
        ),
      ),
    );
  }
}
