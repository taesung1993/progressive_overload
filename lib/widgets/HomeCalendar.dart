import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_overload/designs/Pallete.dart';
import 'package:progressive_overload/designs/Typo.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:math' as math;

class HomeCalendar extends StatefulWidget {
  const HomeCalendar({Key? key}) : super(key: key);

  @override
  _HomeCalendarState createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar>
    with SingleTickerProviderStateMixin {
  final List<String> days = ['_', '월', '화', '수', '목', '금', '토', '일'];
  late AnimationController _animationController;

  CalendarFormat _format = CalendarFormat.week;
  DateTime _now = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      upperBound: 0.5,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  get headerTitle {
    return '${_now.month}월, ${_now.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: pallete[Pallete.white],
          padding: const EdgeInsets.only(
            top: 40,
            bottom: 12,
            left: 20,
            right: 20,
          ),
          child: Row(
            children: [
              Text(
                headerTitle,
                style: typos[Typos.H1_700]!.copyWith(
                  color: pallete[Pallete.black],
                ),
              ),
              const SizedBox(width: 36),
              Ink(
                width: 20,
                height: 20,
                child: InkWell(
                  borderRadius: BorderRadius.circular(1000.0),
                  onTap: () {
                    setState(() {
                      if (_format == CalendarFormat.week) {
                        _format = CalendarFormat.month;
                        _animationController.forward(from: 0.0);
                        return;
                      }

                      _animationController.reverse(from: 0.5);
                      _format = CalendarFormat.week;
                    });
                  },
                  child: RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0)
                        .animate(_animationController),
                    child: SvgPicture.asset(
                      'assets/icons/arrow-down-sign-to-navigate.svg',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        Container(
          color: const Color(0xfff3f3f3),
          padding: const EdgeInsets.only(
            top: 12,
            bottom: 34,
            left: 31,
            right: 31,
          ),
          child: TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _now,
            calendarFormat: _format,
            daysOfWeekHeight: 18,
            headerVisible: false,
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _now = focusedDay;
              });
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _now = focusedDay;
              });
            },
            calendarBuilders: CalendarBuilders(
              dowBuilder: (context, day) {
                return Center(
                  child: Text(days[day.weekday],
                      style: typos[Typos.T1_400]!.copyWith(
                        color: const Color(0xff8F9BB3),
                      )),
                );
              },
              todayBuilder: (context, day, focusedDay) {
                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 7,
                      ),
                      child: Text(
                        day.day.toString(),
                        style: typos[Typos.T1_400]!.copyWith(
                          color: const Color(0xff222B45),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
              selectedBuilder: (context, day, focusedDay) {
                return Center(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: pallete[Pallete.primary1],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 7,
                      ),
                      child: Text(
                        day.day.toString(),
                        style: typos[Typos.T1_400]!.copyWith(
                          color: pallete[Pallete.white],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
