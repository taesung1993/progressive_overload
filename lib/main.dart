import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progressive_overload/providers/date_provider.dart';
import 'package:progressive_overload/providers/fitness_provider.dart';
import 'package:progressive_overload/screens/home_screen.dart';
import 'package:progressive_overload/widgets/creating_fitness_bottom_sheet.dart';
import 'package:progressive_overload/widgets/gnb.dart';

void main() {
  // debugPaintSizeEnabled = true;
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  _openCreatingFitnessBottomSheet(DateTime now, WidgetRef ref) {
    return (BuildContext context) => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          builder: (context) {
            return CreatingFitnessBottomSheet(now: now);
          },
        ).then(
          (value) {
            if (value) {
              ref.read(fitnessProvider.notifier).loadFitnessList();
            }
          },
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _now = ref.watch(dateProvider);

    // TODO: implement build
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: HomeScreen(
            createFitness: _openCreatingFitnessBottomSheet(_now, ref),
          ),
        ),
        bottomNavigationBar: GNB(
          createFitness: _openCreatingFitnessBottomSheet(_now, ref),
        ),
      ),
    );
  }
}
