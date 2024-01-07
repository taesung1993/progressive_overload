import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_overload/designs/Pallete.dart';
import 'package:progressive_overload/designs/Typo.dart';
import 'package:progressive_overload/widgets/training_set_item.dart';

class CreatingWorkoutBottomSheet extends StatefulWidget {
  const CreatingWorkoutBottomSheet({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CreatingWorkoutBottomSheet();
  }
}

class _CreatingWorkoutBottomSheet extends State<CreatingWorkoutBottomSheet> {
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
              Text(
                '운동 기록하기',
                style: typos[Typos.H1_700]!.copyWith(
                  color: pallete[Pallete.black],
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
              ),
              const SizedBox(height: 20),
              Container(
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
                      '2023.09.23',
                      style: typos[Typos.H3_500]!
                          .copyWith(color: pallete[Pallete.black]),
                    ),
                    IconButton(
                      onPressed: () {},
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: SvgPicture.asset(
                        'assets/icons/date_picker.svg',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.text,
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
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              ),
              const SizedBox(
                height: 16,
              ),
              const Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TrainingSetItem(),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  backgroundColor: pallete[Pallete.primary1],
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
              )
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
