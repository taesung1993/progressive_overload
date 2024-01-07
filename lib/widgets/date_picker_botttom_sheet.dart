import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_overload/designs/Pallete.dart';
import 'package:progressive_overload/designs/Typo.dart';
import 'package:google_fonts/google_fonts.dart';

class DatePickerBottomSheet extends StatefulWidget {
  const DatePickerBottomSheet({
    super.key,
    required this.now,
  });

  final DateTime now;

  @override
  State<DatePickerBottomSheet> createState() => _DatePickerBottomSheetState();
}

class _DatePickerBottomSheetState extends State<DatePickerBottomSheet> {
  late FixedExtentScrollController _yearController;
  late FixedExtentScrollController _monthController;

  late int _selectedYear;
  late int _selectedMonth;

  @override
  void initState() {
    super.initState();

    _selectedYear = widget.now.year;
    _selectedMonth = widget.now.month;

    _yearController = FixedExtentScrollController(
      initialItem: _selectedYear - widget.now.year + 50,
    );
    _monthController =
        FixedExtentScrollController(initialItem: _selectedMonth - 1);
  }

  @override
  void dispose() {
    // 컨트롤러를 메모리에서 해제합니다.
    _yearController.dispose();
    _monthController.dispose();
    super.dispose();
  }

  Widget _Header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$_selectedYear년 $_selectedMonth월',
            style: typos[Typos.H1_700]!.copyWith(
              color: const Color(0xff222B45),
            ),
          ),
          IconButton(
            onPressed: () {
              final DateTime output = DateTime.utc(
                _selectedYear,
                _selectedMonth,
                widget.now.day,
              );

              Navigator.of(context).pop(output);
            },
            icon: SvgPicture.asset(
              'assets/icons/arrow-right-sign-to-navigate.svg',
              width: 26,
              height: 20,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 342,
          color: pallete[Pallete.white],
          padding: const EdgeInsets.only(
            top: 54,
            left: 20,
            right: 16,
            bottom: 29,
          ),
          child: Column(
            children: [
              _Header(context),
              const SizedBox(height: 19),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 19,
                    right: 19,
                    bottom: 30,
                    top: 30,
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: SizedBox(
                          width: double.infinity,
                          child: Center(
                            child: Container(
                              width: double.infinity,
                              height: 36,
                              decoration: BoxDecoration(
                                color: pallete[Pallete.lightGrey],
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ListWheelScrollView.useDelegate(
                              controller: _yearController,
                              physics: const FixedExtentScrollPhysics(),
                              itemExtent: 36,
                              diameterRatio: 1.2,
                              magnification: 1,
                              squeeze: 1.0,
                              useMagnifier: true,
                              onSelectedItemChanged: (value) {
                                setState(() {
                                  _selectedYear = widget.now.year + value - 50;
                                });
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 60,
                                builder: (context, index) {
                                  final element = widget.now.year - 50 + index;
                                  return SizedBox(
                                    child: Center(
                                      child: Text(
                                        '$element년',
                                        style: GoogleFonts.roboto(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w400,
                                          height: 1.18,
                                          color: _selectedYear == element
                                              ? pallete[Pallete.black]
                                              : pallete[Pallete.grey],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListWheelScrollView.useDelegate(
                              controller: _monthController,
                              physics: const FixedExtentScrollPhysics(),
                              itemExtent: 36,
                              diameterRatio: 1.2,
                              magnification: 1,
                              squeeze: 1.0,
                              useMagnifier: true,
                              onSelectedItemChanged: (value) {
                                setState(() {
                                  _selectedMonth = value + 1;
                                });
                              },
                              childDelegate: ListWheelChildBuilderDelegate(
                                childCount: 12,
                                builder: (context, index) {
                                  int element = index + 1;

                                  return SizedBox(
                                    child: Center(
                                      child: Text(
                                        '$element월',
                                        style: GoogleFonts.roboto(
                                            fontSize: _selectedMonth == element
                                                ? 22
                                                : 20,
                                            fontWeight:
                                                _selectedMonth == element
                                                    ? FontWeight.w400
                                                    : FontWeight.w500,
                                            height: _selectedMonth == element
                                                ? 1.18
                                                : 1.3,
                                            color: _selectedMonth == element
                                                ? pallete[Pallete.black]
                                                : pallete[Pallete.grey]),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
