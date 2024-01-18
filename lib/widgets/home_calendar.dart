import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:progressive_overload/designs/Pallete.dart';
import 'package:progressive_overload/designs/Typo.dart';
import 'package:progressive_overload/providers/date_provider.dart';
import 'package:progressive_overload/providers/fitness_provider.dart';
import 'package:progressive_overload/widgets/date_picker_botttom_sheet.dart';
import 'package:table_calendar/table_calendar.dart';

const RANGE = 50;

class HomeCalendar extends ConsumerStatefulWidget {
  const HomeCalendar({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeCalendarState();
}

class _HomeCalendarState extends ConsumerState<HomeCalendar>
    with SingleTickerProviderStateMixin {
  final List<String> days = ['_', '월', '화', '수', '목', '금', '토', '일'];
  late AnimationController _animationController;

  CalendarFormat _format = CalendarFormat.week;
  DateTime _selectedDay = DateTime.now();
  String direction = '';

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
    final _now = ref.watch(dateProvider);
    return '${_now.month}월, ${_now.year}';
  }

  void _openDatePicker(BuildContext context) {
    final _now = ref.watch(dateProvider);
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
          now: _now,
        );
      },
    ).then((value) {
      if (value.runtimeType == DateTime) {
        setState(() {
          ref.read(dateProvider.notifier).changeDate(value);
        });
      }
      _animationController.reverse(from: 0.5);
    });
  }

  Map<DateTime, List<String>> get events {
    final fitnessList = ref.watch(fitnessProvider);
    final Map<DateTime, List<String>> map = {};

    for (final item in fitnessList) {
      DateTime date = DateTime(item.fitnessDate);

      if (!map.containsKey(date)) {
        final time = DateTime.fromMillisecondsSinceEpoch(item.fitnessDate);
        final key = DateTime(time.year, time.month, time.day);

        map[key] = [item.name];
      }
    }

    return map;
  }

  @override
  Widget build(BuildContext context) {
    final now = ref.watch(dateProvider);
    final firstDay = DateTime.utc(now.year - RANGE, 1, 1);
    final lastDay = DateTime.utc(now.year + RANGE, 12, 31);

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
                  onTap: () => _openDatePicker(context),
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
        Stack(
          children: [
            Container(
              color: pallete[Pallete.primary3],
              padding: const EdgeInsets.only(
                top: 12,
                bottom: 34,
                left: 31,
                right: 31,
              ),
              child: TableCalendar(
                firstDay: firstDay,
                lastDay: lastDay,
                focusedDay: now,
                calendarStyle: CalendarStyle(
                  markerSize: 4,
                  markerDecoration: BoxDecoration(
                    color: pallete[Pallete.primary1],
                    shape: BoxShape.circle,
                  ),
                  cellPadding: EdgeInsets.zero,
                  cellMargin: EdgeInsets.zero,
                  markersMaxCount: 1,
                  markerSizeScale: 1,
                ),
                eventLoader: (day) {
                  final key = DateTime(day.year, day.month, day.day);

                  if (events.containsKey(key)) {
                    return events[key]!;
                  }

                  return [];
                },
                calendarFormat: _format,
                daysOfWeekHeight: 18,
                headerVisible: false,
                startingDayOfWeek: StartingDayOfWeek.monday,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    ref.read(dateProvider.notifier).changeDate(focusedDay);
                    _selectedDay = selectedDay;
                  });
                },
                calendarBuilders: CalendarBuilders(
                  dowBuilder: (context, day) {
                    return Center(
                      child: Text(days[day.weekday],
                          style: typos[Typos.T2_500]!.copyWith(
                            color: pallete[Pallete.darkGrey],
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
                              color: pallete[Pallete.black],
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
                        child: Container(
                          width: 30,
                          height: 30,
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
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy < 0) {
                    direction = 'upward';
                    return;
                  }

                  direction = 'downward';
                },
                onVerticalDragEnd: (details) {
                  setState(() {
                    switch (direction) {
                      case 'upward':
                        _format = CalendarFormat.week;
                        break;
                      case 'downward':
                        _format = CalendarFormat.month;
                        break;
                    }
                  });
                },
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
              ),
            )
          ],
        ),
      ],
    );
  }
}
