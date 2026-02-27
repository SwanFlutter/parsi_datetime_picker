import 'package:flutter/material.dart';

/// Shows a time picker dialog with RTL support and Persian labels.
///
/// This wraps Flutter's built-in [showTimePicker] with RTL direction
/// and Persian localization already applied.
///
/// Example:
/// ```dart
/// final time = await showParsiTimePicker(
///   context: context,
///   initialTime: TimeOfDay.now(),
/// );
/// ```
Future<TimeOfDay?> showParsiTimePicker({
  required BuildContext context,
  required TimeOfDay initialTime,
  TransitionBuilder? builder,
  bool useRootNavigator = true,
  TimePickerEntryMode initialEntryMode = TimePickerEntryMode.dial,
  String? cancelText,
  String? confirmText,
  String? helpText,
  RouteSettings? routeSettings,
}) {
  Widget buildWrapper(BuildContext context, Widget? child) {
    Widget result = Directionality(
      textDirection: TextDirection.rtl,
      child: child!,
    );
    if (builder != null) {
      result = builder(context, result);
    }
    return result;
  }

  return showTimePicker(
    context: context,
    initialTime: initialTime,
    builder: buildWrapper,
    useRootNavigator: useRootNavigator,
    initialEntryMode: initialEntryMode,
    cancelText: cancelText ?? 'انصراف',
    confirmText: confirmText ?? 'تأیید',
    helpText: helpText ?? 'انتخاب ساعت',
    routeSettings: routeSettings,
  );
}
