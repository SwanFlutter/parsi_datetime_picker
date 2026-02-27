import 'package:flutter/material.dart';

import '../utils/parsi_date.dart';
import '../utils/parsi_date_range.dart';
import 'parsi_datetime_range_picker_dialog.dart';

/// Shows a Persian date range picker dialog.
///
/// Returns the selected [ParsiDateRange], or `null` if dismissed.
///
/// Example:
/// ```dart
/// final range = await showParsiDateRangePicker(
///   context: context,
///   firstDate: ParsiDate(1380, 1, 1),
///   lastDate: ParsiDate(1450, 12, 29),
///   initialDateRange: ParsiDateRange(
///     start: ParsiDate(1403, 1, 1),
///     end: ParsiDate(1403, 1, 10),
///   ),
/// );
/// ```
Future<ParsiDateRange?> showParsiDateRangePicker({
  required BuildContext context,
  required ParsiDate firstDate,
  required ParsiDate lastDate,
  ParsiDateRange? initialDateRange,
  ParsiDate? initialDate,
  ParsiDate? currentDate,
  String? helpText,
  String? cancelText,
  String? confirmText,
  String? saveText,
  TransitionBuilder? builder,
  RouteSettings? routeSettings,
}) async {
  assert(
      !firstDate.isAfter(lastDate), 'firstDate must be on or before lastDate');

  Widget dialog = ParsiDateRangePickerDialog(
    firstDate: firstDate,
    lastDate: lastDate,
    initialDateRange: initialDateRange,
    initialDate: initialDate,
    currentDate: currentDate,
    helpText: helpText,
    cancelText: cancelText,
    confirmText: confirmText,
    saveText: saveText,
  );

  if (builder != null) {
    dialog = builder(context, dialog);
  }

  return showDialog<ParsiDateRange>(
    context: context,
    routeSettings: routeSettings,
    builder: (context) => Directionality(
      textDirection: TextDirection.rtl,
      child: dialog,
    ),
  );
}
