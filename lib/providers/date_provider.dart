import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateNotifier extends StateNotifier<DateTime> {
  DateNotifier() : super(DateUtils.dateOnly(DateTime.now()));

  void changeDate(DateTime time) {
    state = time;
  }
}

final dateProvider =
    StateNotifierProvider<DateNotifier, DateTime>((ref) => DateNotifier());
