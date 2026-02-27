import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/extensions.dart';
import '../utils/parsi_date.dart';

/// Mode for [ParsiCupertinoDatePicker].
enum ParsiCupertinoDatePickerMode {
  /// Shows year, month, and day columns.
  date,

  /// Shows hour and minute columns.
  time,

  /// Shows year, month, day, hour, and minute columns.
  dateAndTime,
}

/// An iOS-style Persian (Jalali) date/time picker.
///
/// Example:
/// ```dart
/// ParsiCupertinoDatePicker(
///   mode: ParsiCupertinoDatePickerMode.date,
///   initialDateTime: ParsiDate.now(),
///   onDateTimeChanged: (date) => print(date),
/// )
/// ```
class ParsiCupertinoDatePicker extends StatefulWidget {
  const ParsiCupertinoDatePicker({
    super.key,
    this.mode = ParsiCupertinoDatePickerMode.date,
    required this.onDateTimeChanged,
    this.initialDateTime,
    this.minimumDate,
    this.maximumDate,
    this.backgroundColor,
    this.itemExtent = 32.0,
  });

  final ParsiCupertinoDatePickerMode mode;
  final ValueChanged<ParsiDate> onDateTimeChanged;
  final ParsiDate? initialDateTime;
  final ParsiDate? minimumDate;
  final ParsiDate? maximumDate;
  final Color? backgroundColor;
  final double itemExtent;

  @override
  State<ParsiCupertinoDatePicker> createState() =>
      _ParsiCupertinoDatePickerState();
}

class _ParsiCupertinoDatePickerState extends State<ParsiCupertinoDatePicker> {
  late int _selectedYear;
  late int _selectedMonth;
  late int _selectedDay;
  late int _selectedHour;
  late int _selectedMinute;

  late FixedExtentScrollController _yearCtrl;
  late FixedExtentScrollController _monthCtrl;
  late FixedExtentScrollController _dayCtrl;
  late FixedExtentScrollController _hourCtrl;
  late FixedExtentScrollController _minuteCtrl;

  int get _minYear => widget.minimumDate?.year ?? 1350;
  int get _maxYear => widget.maximumDate?.year ?? 1450;

  int get _daysInSelectedMonth {
    final firstOfMonth = ParsiDate(_selectedYear, _selectedMonth, 1);
    return firstOfMonth.monthLength;
  }

  void _notify() {
    final day = _selectedDay.clamp(1, _daysInSelectedMonth);
    widget.onDateTimeChanged(
      ParsiDate(
        _selectedYear,
        _selectedMonth,
        day,
        hour: _selectedHour,
        minute: _selectedMinute,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final init = widget.initialDateTime ?? ParsiDate.now();
    _selectedYear = init.year;
    _selectedMonth = init.month;
    _selectedDay = init.day;
    _selectedHour = init.hour;
    _selectedMinute = init.minute;

    _yearCtrl =
        FixedExtentScrollController(initialItem: _selectedYear - _minYear);
    _monthCtrl = FixedExtentScrollController(initialItem: _selectedMonth - 1);
    _dayCtrl = FixedExtentScrollController(initialItem: _selectedDay - 1);
    _hourCtrl = FixedExtentScrollController(initialItem: _selectedHour);
    _minuteCtrl = FixedExtentScrollController(initialItem: _selectedMinute);
  }

  @override
  void dispose() {
    _yearCtrl.dispose();
    _monthCtrl.dispose();
    _dayCtrl.dispose();
    _hourCtrl.dispose();
    _minuteCtrl.dispose();
    super.dispose();
  }

  Widget _buildColumn({
    required FixedExtentScrollController controller,
    required int itemCount,
    required String Function(int) labelBuilder,
    required ValueChanged<int> onChanged,
    double width = 70,
  }) {
    return SizedBox(
      width: width,
      child: CupertinoPicker(
        scrollController: controller,
        itemExtent: widget.itemExtent,
        backgroundColor: widget.backgroundColor ?? Colors.transparent,
        onSelectedItemChanged: onChanged,
        children: List.generate(
          itemCount,
          (i) => Center(
            child: Text(
              labelBuilder(i),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> columns = [];

    if (widget.mode == ParsiCupertinoDatePickerMode.date ||
        widget.mode == ParsiCupertinoDatePickerMode.dateAndTime) {
      // Year
      columns.add(_buildColumn(
        controller: _yearCtrl,
        itemCount: _maxYear - _minYear + 1,
        labelBuilder: (i) => toPersianDigits(
            ((_minYear + i) + 1180).toString()), // Convert to Imperial
        onChanged: (i) {
          _selectedYear = _minYear + i;
          setState(() {});
          _notify();
        },
        width: 80,
      ));
      // Month
      columns.add(_buildColumn(
        controller: _monthCtrl,
        itemCount: 12,
        labelBuilder: (i) => ParsiDate.persianMonthNames[i],
        onChanged: (i) {
          _selectedMonth = i + 1;
          setState(() {});
          _notify();
        },
        width: 90,
      ));
      // Day
      columns.add(_buildColumn(
        controller: _dayCtrl,
        itemCount: _daysInSelectedMonth,
        labelBuilder: (i) => toPersianDigits((i + 1).toString()),
        onChanged: (i) {
          _selectedDay = i + 1;
          _notify();
        },
        width: 50,
      ));
    }

    if (widget.mode == ParsiCupertinoDatePickerMode.time ||
        widget.mode == ParsiCupertinoDatePickerMode.dateAndTime) {
      // Hour
      columns.add(_buildColumn(
        controller: _hourCtrl,
        itemCount: 24,
        labelBuilder: (i) => toPersianDigits(i.toString().padLeft(2, '0')),
        onChanged: (i) {
          _selectedHour = i;
          _notify();
        },
        width: 60,
      ));
      // Separator
      columns.add(const SizedBox(
        width: 16,
        child: Center(
            child: Text(':',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
      ));
      // Minute
      columns.add(_buildColumn(
        controller: _minuteCtrl,
        itemCount: 60,
        labelBuilder: (i) => toPersianDigits(i.toString().padLeft(2, '0')),
        onChanged: (i) {
          _selectedMinute = i;
          _notify();
        },
        width: 60,
      ));
    }

    return Container(
      color: widget.backgroundColor,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: columns,
        ),
      ),
    );
  }
}
