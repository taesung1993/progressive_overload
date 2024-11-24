import 'dart:collection';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_overload/shared/styles.dart';
import 'package:progressive_overload/widget/typo.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class Event {
  String title;
  bool complete;
  Event(this.title, this.complete);

  @override
  String toString() => title;
}

class WorkoutCalendar extends StatefulWidget {
  const WorkoutCalendar({Key? key}) : super(key: key);

  @override
  _WorkoutCalendarState createState() => _WorkoutCalendarState();
}

class _WorkoutCalendarState extends State<WorkoutCalendar> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primary3Color,
      child: TableCalendar(
        locale: 'ko_KR',
        startingDayOfWeek: StartingDayOfWeek.monday,
        focusedDay: _focusedDay,
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2024, 13, 0),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {
          setState(() {
            _calendarFormat = format;
          });
        },
        onPageChanged: (focusedDay) {
          _focusedDay = focusedDay;
        },
        eventLoader: (day) {
          if (day.weekday == DateTime.monday) {
            return [Event('Cyclic event', true)];
          }

          return [];
        },
        headerStyle: const HeaderStyle(
          rightChevronVisible: false,
          leftChevronVisible: false,
          formatButtonVisible: false,
          headerPadding: EdgeInsets.zero,
        ),
        calendarBuilders: CalendarBuilders(
          headerTitleBuilder: (context, day) {
            return Container(
              color: white,
              padding: const EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: 20.0,
              ),
              child: Row(
                children: [
                  Typo.headingOneBold(
                    '${day.year}년 ${day.month}월',
                    color: black,
                  ),
                  IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            color: white,
                            padding: const EdgeInsets.only(
                              left: 20.0,
                              right: 20.0,
                              top: 40.0,
                              bottom: 20.0,
                            ),
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Typo.headingOneBold('2024년 11월',
                                      color: black),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 214,
                                  child: ScrollDatePicker(
                                    selectedDate: DateTime.now(),
                                    locale: const Locale('ko'),
                                    onDateTimeChanged: (DateTime value) {},
                                    viewType: const [
                                      DatePickerViewType.year,
                                      DatePickerViewType.month,
                                    ],
                                    scrollViewOptions:
                                        DatePickerScrollViewOptions(
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
                                        color: lightgrey.withOpacity(0.7),
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
                                      onTap: () {},
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
                        },
                      );
                    },
                    icon: SvgPicture.asset(
                      'assets/svg/chevron_down.svg',
                    ),
                  ),
                ],
              ),
            );
          },
          defaultBuilder: (context, date, _) {
            return Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Typo.TextOneRegular(
                '${date.day}',
                color: black,
              ),
            );
          },
          selectedBuilder: (context, date, _) {
            return Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: primary1Color,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Typo.TextOneRegular(
                '${date.day}',
                color: white,
              ),
            );
          },
          disabledBuilder: (context, date, _) {
            return Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Typo.TextOneRegular(
                '${date.day}',
                color: grey,
              ),
            );
          },
          todayBuilder: (context, date, _) {
            return Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Typo.TextOneRegular(
                '${date.day}',
                color: black,
              ),
            );
          },
          outsideBuilder: (context, date, _) {
            return Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Typo.TextOneRegular(
                '${date.day}',
                color: grey,
              ),
            );
          },
          holidayBuilder: (context, date, _) {
            return Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Typo.TextOneRegular(
                '${date.day}',
                color: black,
              ),
            );
          },
        ),
        rowHeight: 50,
        daysOfWeekHeight: 40,
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: text2Medium.copyWith(color: darkgrey),
          weekendStyle: text2Medium.copyWith(color: darkgrey),
        ),
        calendarStyle: const CalendarStyle(
          tablePadding: EdgeInsets.only(
            top: 12,
            bottom: 40,
            left: 10,
            right: 10,
          ),
          markerDecoration: BoxDecoration(
            color: primary1Color,
            shape: BoxShape.circle,
          ),
          markerSize: 4,
          markerMargin: EdgeInsets.only(
            top: 8,
            left: 0,
            right: 0,
            bottom: 0,
          ),
          cellMargin: EdgeInsets.all(0),
          cellPadding: EdgeInsets.all(0),
          markerSizeScale: 1.0,
          markersAnchor: 1.0,
        ),
      ),
    );
  }
}
