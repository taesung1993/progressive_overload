import 'package:flutter/material.dart';
import 'package:progressive_overload/shared/styles.dart';
import 'package:progressive_overload/widget/typo.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class WorkoutCalendarMonthSelectorBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime value) onChange;
  const WorkoutCalendarMonthSelectorBottomSheet({
    super.key,
    required this.selectedDate,
    required this.onChange,
  });

  @override
  _WorkoutCalendarMonthSelectorBottomSheetState createState() =>
      _WorkoutCalendarMonthSelectorBottomSheetState();
}

class _WorkoutCalendarMonthSelectorBottomSheetState
    extends State<WorkoutCalendarMonthSelectorBottomSheet> {
  late DateTime _selectedDate;

  initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
  }

  String get heading {
    final date = _selectedDate;
    return '${date.year}년 ${date.month}월';
  }

  void onDateTimeChanged(DateTime value) {
    setState(() {
      _selectedDate = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        top: 40.0,
        bottom: 20.0,
      ),
      decoration: const BoxDecoration(
        color: white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            child: Typo.headingOneBold(heading, color: black),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 214,
            child: ScrollDatePicker(
              selectedDate: _selectedDate,
              locale: const Locale('ko'),
              onDateTimeChanged: onDateTimeChanged,
              viewType: const [
                DatePickerViewType.year,
                DatePickerViewType.month,
              ],
              scrollViewOptions: DatePickerScrollViewOptions(
                year: ScrollViewDetailOptions(
                  label: '년',
                  alignment: Alignment.center,
                  textStyle: head3Medium.copyWith(
                    color: black,
                  ),
                  selectedTextStyle: head3Medium.copyWith(
                    color: black,
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                ),
                month: ScrollViewDetailOptions(
                  label: '월',
                  alignment: Alignment.center,
                  textStyle: head3Medium.copyWith(
                    color: black,
                  ),
                  selectedTextStyle: head3Medium.copyWith(
                    color: black,
                  ),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                ),
              ),
              options: const DatePickerOptions(
                itemExtent: 36.0,
              ),
              indicator: Container(
                height: 36,
                decoration: BoxDecoration(
                  color: lightgrey.withOpacity(0.4),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Material(
            child: Ink(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                color: primary1Color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: InkWell(
                onTap: () {
                  widget.onChange(_selectedDate);
                  Navigator.pop(context);
                },
                child: Center(
                  child: Typo.headingThreeBold(
                    '날짜 변경',
                    color: white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
