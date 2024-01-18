import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:progressive_overload/designs/Pallete.dart';
import 'package:progressive_overload/designs/Typo.dart';
import 'package:progressive_overload/providers/fitness_provider.dart';
import 'package:progressive_overload/widgets/date_picker_botttom_sheet.dart';
import 'package:progressive_overload/widgets/training_set_item.dart';

class CreatingFitnessBottomSheet extends ConsumerStatefulWidget {
  const CreatingFitnessBottomSheet({
    super.key,
    required this.now,
  });

  final DateTime now;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CreatingFitnessBottomSheet();
  }
}

class _CreatingFitnessBottomSheet
    extends ConsumerState<CreatingFitnessBottomSheet>
    with SingleTickerProviderStateMixin {
  late DateTime _fitnessDate;
  late AnimationController _animationController;

  final List<Map<String, String>> _trainingSetItems = [
    {"enteredWeight": '', "enteredCount": ''}
  ];

  String _workname = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fitnessDate = widget.now;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      upperBound: 0.5,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }

  void _openDatePicker() {
    _animationController.forward(from: 0.0);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      builder: (context) {
        return DatePickerBottomSheet(
          now: _fitnessDate,
          datePickerFormat: DatePickerFormat.YYYYMMDD,
        );
      },
    ).then((value) {
      if (value.runtimeType == DateTime) {
        setState(() {
          _fitnessDate = value;
        });
      }
    });
  }

  Widget _Title() {
    return Text(
      '운동 기록하기',
      style: typos[Typos.H1_700]!.copyWith(
        color: pallete[Pallete.black],
      ),
    );
  }

  Widget _RecentRecords() {
    return Container(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          backgroundColor: const Color(0xff3D3D3D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        child: Text(
          '최근 기록',
          style: typos[Typos.T1_500]!.copyWith(
            color: pallete[Pallete.white],
          ),
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _FitnessAtFormControl() {
    return Container(
      width: double.infinity,
      height: 48,
      padding: const EdgeInsets.only(left: 12, right: 0),
      decoration: BoxDecoration(
        color: pallete[Pallete.white],
        border: Border.all(
          width: 1,
          color: pallete[Pallete.grey]!,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            DateFormat('yyyy.MM.dd').format(_fitnessDate),
            style: typos[Typos.H3_500]!.copyWith(color: pallete[Pallete.black]),
          ),
          IconButton(
            onPressed: _openDatePicker,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: SvgPicture.asset(
              'assets/icons/date_picker.svg',
            ),
          ),
        ],
      ),
    );
  }

  void _onChangeFitnessName(String value) {
    setState(() {
      _workname = value;
    });
  }

  Widget _FitnessNameFormControl() {
    return TextField(
      keyboardType: TextInputType.text,
      onChanged: _onChangeFitnessName,
      style: typos[Typos.H3_500]!.copyWith(
        color: pallete[Pallete.black],
      ),
      decoration: InputDecoration(
        isDense: true,
        filled: true,
        fillColor: pallete[Pallete.white],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        hintText: '운동 이름을 입력하세요',
        hintStyle: typos[Typos.T1_400]!.copyWith(
          color: const Color(0xffD5D5D5),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: pallete[Pallete.grey]!,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: pallete[Pallete.primary1]!,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _AddTrainingSet() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _trainingSetItems.add({"enteredWeight": '', "enteredCount": ''});
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          ),
          const SizedBox(width: 8),
          Text(
            '세트 추가',
            style: typos[Typos.H3_600]!
                .copyWith(color: pallete[Pallete.white], height: 1),
          ),
        ],
      ),
    );
  }

  get isValid {
    if (_workname.isEmpty) {
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

  Future<void> _onSubmit(BuildContext context) async {
    int maxCount = 0;
    double maxWeight = 0.0;

    for (int i = 0; i < _trainingSetItems.length; i++) {
      maxCount =
          max(maxCount, int.parse(_trainingSetItems[i]["enteredCount"]!));
      maxWeight =
          max(maxWeight, double.parse(_trainingSetItems[i]["enteredWeight"]!));
    }

    await ref.read(fitnessProvider.notifier).addFitness(
          name: _workname,
          maxCount: maxCount,
          maxWeight: maxWeight,
          fitnessDate: _fitnessDate.millisecondsSinceEpoch,
          trainingSet: _trainingSetItems,
        );

    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  Widget _SubmitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: isValid ? () => _onSubmit(context) : null,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        backgroundColor:
            isValid ? pallete[Pallete.primary1] : pallete[Pallete.grey],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(7.0),
        ),
      ),
      child: Center(
        child: Text(
          '등록하기',
          style: typos[Typos.H3_600]!
              .copyWith(color: pallete[Pallete.white], height: 1),
        ),
      ),
    );
  }

  void Function(String value) _onChangeFitnessCount(int index) {
    return (String value) {
      setState(() {
        _trainingSetItems[index]["enteredCount"] = value;
      });
    };
  }

  void Function(String value) _onChangeFitnessWeight(int index) {
    return (String value) {
      setState(() {
        _trainingSetItems[index]["enteredWeight"] = value;
      });
    };
  }

  void _onDeleteTrainingSetItem(int index) {
    setState(() {
      _trainingSetItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 726,
          padding: const EdgeInsets.only(
            top: 48,
            left: 16,
            right: 16,
            bottom: 40,
          ),
          child: Column(
            children: [
              _Title(),
              _RecentRecords(),
              const SizedBox(height: 20),
              _FitnessAtFormControl(),
              const SizedBox(height: 16),
              _FitnessNameFormControl(),
              const SizedBox(height: 24),
              _AddTrainingSet(),
              const SizedBox(
                height: 16,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var index = 0;
                          index < _trainingSetItems.length;
                          index++)
                        Column(
                          children: [
                            TrainingSetItem(
                              setNumber: index + 1,
                              onChangeFitnessCount:
                                  _onChangeFitnessCount(index),
                              onChangeFitnessWeight:
                                  _onChangeFitnessWeight(index),
                              onDeleteTrainingSetItem: () =>
                                  _onDeleteTrainingSetItem(index),
                            ),
                            if (index != _trainingSetItems.length - 1)
                              const SizedBox(height: 10),
                          ],
                        )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              _SubmitButton(context),
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
