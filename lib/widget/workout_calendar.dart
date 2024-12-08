import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_overload/database/workout_repository.dart';
import 'package:progressive_overload/shared/styles.dart';
import 'package:progressive_overload/widget/typo.dart';
import 'package:progressive_overload/widget/workout_calendar_month_selector_bottom_sheet.dart';
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
  Function(DateTime selectedDate)? onSelectedDate;

  WorkoutCalendar({
    Key? key,
    this.onSelectedDate,
  });

  @override
  _WorkoutCalendarState createState() => _WorkoutCalendarState();
}

class _WorkoutCalendarState extends State<WorkoutCalendar> {
  final repository = WorkoutRepository();
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  Map<DateTime, bool> _events = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final loadedEvents = await repository.getWorkoutEvents();
    setState(() {
      _events = loadedEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: primary3Color,
      child: TableCalendar(
        locale: 'ko_KR',
        startingDayOfWeek: StartingDayOfWeek.monday,
        focusedDay: _focusedDay,
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(DateTime.now().year, 13, 0),
        selectedDayPredicate: (day) {
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });

          if (widget.onSelectedDate != null) {
            widget.onSelectedDate!(selectedDay);
          }
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
          final key = DateTime(day.year, day.month, day.day, 0, 0, 0);
          return _events[key] == true ? [Event('운동', true)] : [];
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
                          return WorkoutCalendarMonthSelectorBottomSheet(
                            selectedDate: _selectedDay,
                            onChange: (value) => setState(() {
                              _selectedDay = value;
                              _focusedDay = value;
                            }),
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