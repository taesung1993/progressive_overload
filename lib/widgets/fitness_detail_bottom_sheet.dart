import 'package:flutter/material.dart';
import 'package:progressive_overload/designs/Pallete.dart';
import 'package:progressive_overload/designs/Typo.dart';
import 'package:progressive_overload/models/fitness.dart';
import 'package:progressive_overload/widgets/training_set_item.dart';

class FitnessDetailBottomSheet extends StatelessWidget {
  const FitnessDetailBottomSheet({
    super.key,
    required this.fitness,
  });

  final Fitness fitness;

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
                      fitness.name,
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
                      for (int i = 0; i < fitness.set.length; i++)
                        Column(
                          children: [
                            TrainingSetItem(
                              setNumber: fitness.set[i].sequence,
                              weight: fitness.set[i].weight.toString(),
                              count: fitness.set[i].count.toString(),
                              onChangeFitnessCount: (value) {},
                              onChangeFitnessWeight: (value) {},
                              onDeleteTrainingSetItem: () {},
                            ),
                            if (i < fitness.set.length - 1)
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
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pallete[Pallete.red1],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                  ),
                  child: Text(
                    '전체 삭제',
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
