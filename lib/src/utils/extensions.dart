import 'package:flutter/material.dart';
import 'parsi_date.dart';

/// Extension on [DateTime] to convert to [ParsiDate].
extension DateTimeParsi on DateTime {
  ParsiDate toParsiDate() => ParsiDate.fromDateTime(this);
}

/// Extension on [ParsiDate] to convert to [DateTime].
extension ParsiDateExt on ParsiDate {
  DateTime toGregorianDateTime() => toDateTime();

  /// Returns a [TimeOfDay] from the time portion of this date.
  TimeOfDay toTimeOfDay() => TimeOfDay(hour: hour, minute: minute);
}

/// Converts English digits to Persian digits.
String toPersianDigits(String s) {
  const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  for (int i = 0; i < 10; i++) {
    s = s.replaceAll(en[i], fa[i]);
  }
  return s;
}
