import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
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
  bool isEdit = false;
  final List<Map<String, String>> _trainingSetItems = [];

  get isValid {
    if (_trainingSetItems.isEmpty) {
      return false;
    }

    return _trainingSetItems.every(
      (element) {
        return element["enteredWeight"]!.isNotEmpty &&
            double.tryParse(element["enteredWeight"]!) != null &&
            element["enteredCount"]!.isNotEmpty &&
            int.tryParse(element["enteredCount"]!) != null;
      },
    );
  }

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

  void addTrainingSet() {
    if (!isEdit) {
      return;
    }

    setState(() {
      _trainingSetItems.add(
        {
          "enteredWeight": "",
          "enteredCount": "",
        },
      );
    });
  }

  void saveTrainingSet() {
    // print('저장하기');
    // print(_trainingSetItems);
  }

  Widget ViewerSection() {
    return Column(
      children: [
        for (int i = 0; i < widget.fitness.set.length; i++)
          Column(
            children: [
              TrainingSetItem(
                setNumber: i + 1,
                weight: widget.fitness.set[i].weight.toString(),
                count: widget.fitness.set[i].count.toString(),
                isEdit: isEdit,
                onDeleteTrainingSetItem: () => onDeleteTrainingSetItem(
                  widget.fitness.set[i],
                ),
              ),
              if (i < widget.fitness.set.length - 1) const SizedBox(height: 10),
            ],
          )
      ],
    );
  }

  Widget EditSection() {
    return Column(
      children: [
        for (var index = 0; index < _trainingSetItems.length; index++)
          Column(
            children: [
              TrainingSetItem(
                setNumber: index + 1,
                onChangeFitnessCount: (value) {
                  setState(() {
                    _trainingSetItems[index]["enteredCount"] = value;
                  });
                },
                onChangeFitnessWeight: (value) {
                  setState(() {
                    _trainingSetItems[index]["enteredWeight"] = value;
                  });
                },
                onDeleteTrainingSetItem: () {
                  setState(() {
                    _trainingSetItems.removeAt(index);
                  });
                },
              ),
              if (index != _trainingSetItems.length - 1)
                const SizedBox(height: 10),
            ],
          )
      ],
    );
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
                      onPressed: () {
                        setState(() {
                          isEdit = !isEdit;
                          if (isEdit) {
                            for (final item in widget.fitness.set) {
                              _trainingSetItems.add(
                                {
                                  "enteredWeight": item.weight.toString(),
                                  "enteredCount": item.count.toString(),
                                },
                              );
                            }

                            return;
                          }

                          _trainingSetItems.clear();
                        });
                      },
                      style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith((states) =>
                            pallete[Pallete.primary1]!.withOpacity(0.5)),
                      ),
                      child: Text(
                        isEdit ? '편집취소' : '편집하기',
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
                  child: isEdit ? EditSection() : ViewerSection(),
                ),
              ),
              const SizedBox(height: 41),
              if (isEdit)
                Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                          onPressed: addTrainingSet,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: pallete[Pallete.black],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/add_set.svg',
                                width: 20,
                                height: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '세트 추가',
                                style: typos[Typos.H3_600]!.copyWith(
                                  color: pallete[Pallete.white],
                                ),
                              ),
                            ],
                          )),
                    )),
                    const SizedBox(width: 14),
                    Expanded(
                        child: SizedBox(
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isValid ? saveTrainingSet : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isValid
                              ? pallete[Pallete.primary1]
                              : pallete[Pallete.grey],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                        ),
                        child: Text(
                          '저장하기',
                          style: typos[Typos.H3_600]!.copyWith(
                            color: pallete[Pallete.white],
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              if (!isEdit)
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
