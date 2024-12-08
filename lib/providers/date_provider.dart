import 'package:flutter/material.dart';

class DateProvider with ChangeNotifier {
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  final DateTime _startingDate = DateTime(2024, 1, 1);
  DateTime get startingDate => _startingDate;

  final DateTime _endingDate = DateTime(DateTime.now().year, 13, 0);
  DateTime get endingDate => _endingDate;

  void setSelectedDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }
}
