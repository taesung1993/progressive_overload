import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progressive_overload/designs/Pallete.dart';
import 'package:progressive_overload/providers/date_provider.dart';
import 'package:progressive_overload/providers/fitness_provider.dart';
import 'package:progressive_overload/widgets/fitness_list.dart';
import 'package:progressive_overload/widgets/home_calendar.dart';
import 'package:progressive_overload/widgets/no_fitness.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({
    super.key,
    required this.createFitness,
  });

  final void Function(BuildContext context) createFitness;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<void> _fitnessListFuture;

  @override
  void initState() {
    super.initState();
    _fitnessListFuture = ref.read(fitnessProvider.notifier).loadFitnessList();
  }

  @override
  Widget build(BuildContext context) {
    final now = ref.watch(dateProvider);
    final records = ref.watch(fitnessProvider);
    final fitnessList = records[now] ?? [];

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: FutureBuilder(
        future: _fitnessListFuture,
        builder: (context, snapshot) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const HomeCalendar(),
                if (snapshot.connectionState == ConnectionState.waiting)
                  Container(
                    margin: const EdgeInsets.only(top: 80),
                    child: CircularProgressIndicator(
                      color: pallete[Pallete.primary1],
                    ),
                  ),
                if (snapshot.connectionState == ConnectionState.done)
                  fitnessList.isNotEmpty
                      ? FitnessList(fitnessList: fitnessList)
                      : NoFitness(
                          createFitness: widget.createFitness,
                        ),
              ],
            ),
          );
        },
      ),
    );
  }
}
