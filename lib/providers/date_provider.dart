import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateNotifier extends StateNotifier<DateTime> {
  DateNotifier() : super(DateTime.now());

  void changeDate(DateTime time) {
    state = time;
  }
}

final dateProvider =
    StateNotifierProvider<DateNotifier, DateTime>((ref) => DateNotifier());
