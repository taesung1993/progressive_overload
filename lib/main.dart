import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:progressive_overload/screens/home_screen.dart';
import 'package:progressive_overload/widgets/gnb.dart';

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
          child: HomeScreen(),
        ),
        bottomNavigationBar: GNB(),
      ),
    );
  }
}
