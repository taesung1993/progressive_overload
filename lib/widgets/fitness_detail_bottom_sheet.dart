import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:progressive_overload/designs/Pallete.dart';
import 'package:progressive_overload/designs/Typo.dart';
import 'package:progressive_overload/models/fitness.dart';
import 'package:progressive_overload/models/training_set.dart';
import 'package:progressive_overload/providers/fitness_provider.dart';
import 'package:progressive_overload/widgets/training_set_item.dart';

class FitnessDetailBottomSheet extends ConsumerStatefulWidget {
  const FitnessDetailBottomSheet({
    super.key,
    required this.fitness,
  });

  final Fitness fitness;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FitnessDetailBottomSheetState();
}

class _FitnessDetailBottomSheetState
    extends ConsumerState<FitnessDetailBottomSheet> {
  Future<void> onDeleteTrainingSetItem(TrainingSet setItem) async {
    if (widget.fitness.set.length == 1) {
      await ref.read(fitnessProvider.notifier).deleteFitness(widget.fitness);

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();
      return;
    }

    await ref
        .read(fitnessProvider.notifier)
        .deleteTrainingSet(widget.fitness, setItem.id);

    setState(() {
      widget.fitness.set.remove(setItem);
    });
  }

  Future<void> onDeleteFitness(BuildContext context) async {
    await ref.read(fitnessProvider.notifier).deleteFitness(widget.fitness);

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Stack(
      children: [
        Container(
          height: 534,
          padding: const EdgeInsets.only(
            top: 54,
            left: 16,
            right: 16,
            bottom: 40,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.fitness.name,
                      style: typos[Typos.H1_700]!.copyWith(
                        color: pallete[Pallete.black],
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith((states) =>
                            pallete[Pallete.primary1]!.withOpacity(0.5)),
                      ),
                      child: Text(
                        '편집하기',
                        style: typos[Typos.T1_400]!.copyWith(
                          color: pallete[Pallete.black],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 31),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0; i < widget.fitness.set.length; i++)
                        Column(
                          children: [
                            TrainingSetItem(
                              setNumber: i + 1,
                              weight: widget.fitness.set[i].weight.toString(),
                              count: widget.fitness.set[i].count.toString(),
                              isEdit: false,
                              onChangeFitnessCount: (value) {},
                              onChangeFitnessWeight: (value) {},
                              onDeleteTrainingSetItem: () =>
                                  onDeleteTrainingSetItem(
                                widget.fitness.set[i],
                              ),
                            ),
                            if (i < widget.fitness.set.length - 1)
                              const SizedBox(height: 10),
                          ],
                        )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 41),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => onDeleteFitness(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pallete[Pallete.red1],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                  ),
                  child: Text(
                    '운동 삭제',
                    style: typos[Typos.H3_600]!.copyWith(
                      color: pallete[Pallete.white],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xffCED3DE).withOpacity(0.5),
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
          ),
        )
      ],
    );
  }
}
