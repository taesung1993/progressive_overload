import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:progressive_overload/widgets/fitness_item.dart';

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
          child: Center(
            child: Column(
              children: [
                FitnessItem(
                  name: '데드리프트',
                  totalSetCount: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
