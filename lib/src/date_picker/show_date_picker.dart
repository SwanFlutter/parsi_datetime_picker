import 'package:flutter/material.dart';
import '../utils/parsi_date.dart';
import 'parsi_date_picker_dialog.dart';

/// Shows a Persian (Jalali) date picker dialog.
///
/// Returns the selected [ParsiDate], or `null` if the user dismisses.
///
/// Example:
/// ```dart
/// final picked = await showParsiDatePicker(
///   context: context,
///   initialDate: ParsiDate.now(),
///   firstDate: ParsiDate(1380, 1, 1),
///   lastDate: ParsiDate(1450, 12, 29),
/// );
/// ```
Future<ParsiDate?> showParsiDatePicker({
  required BuildContext context,
  required ParsiDate initialDate,
  required ParsiDate firstDate,
  required ParsiDate lastDate,
  ParsiDate? currentDate,
  ParsiDatePickerEntryMode initialEntryMode = ParsiDatePickerEntryMode.calendar,
  ParsiDatePickerMode initialDatePickerMode = ParsiDatePickerMode.day,
  bool Function(ParsiDate)? selectableDayPredicate,
  List<ParsiDate>? holidayDates,
  String? cancelText,
  String? confirmText,
  String? helpText,
  TransitionBuilder? builder,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) async {
  assert(!initialDate.isBefore(firstDate), 'initialDate must be on or after firstDate');
  assert(!initialDate.isAfter(lastDate), 'initialDate must be on or before lastDate');
  assert(!firstDate.isAfter(lastDate), 'firstDate must be on or before lastDate');

  Widget dialog = ParsiDatePickerDialog(
    initialDate: initialDate,
    firstDate: firstDate,
    lastDate: lastDate,
    currentDate: currentDate,
    initialEntryMode: initialEntryMode,
    initialCalendarMode: initialDatePickerMode,
    selectableDayPredicate: selectableDayPredicate,
    holidayDates: holidayDates,
    cancelText: cancelText,
    confirmText: confirmText,
    helpText: helpText,
  );

  if (builder != null) {
    dialog = builder(context, dialog);
  }

  return showDialog<ParsiDate>(
    context: context,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
    builder: (BuildContext context) => Directionality(
      textDirection: TextDirection.rtl,
      child: dialog,
    ),
  );
}
