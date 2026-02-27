import 'package:flutter/material.dart';

import '../utils/parsi_date.dart';

/// Entry mode for the date picker dialog.
enum ParsiDatePickerEntryMode { calendar, input }

/// Initial picker mode: day, month, or year.
enum ParsiDatePickerMode { day, year }

/// Main Persian date picker dialog widget.
///
/// Usually shown via [showParsiDatePicker].
class ParsiDatePickerDialog extends StatefulWidget {
  const ParsiDatePickerDialog({
    super.key,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    this.currentDate,
    this.initialEntryMode = ParsiDatePickerEntryMode.calendar,
    this.initialCalendarMode = ParsiDatePickerMode.day,
    this.selectableDayPredicate,
    this.cancelText,
    this.confirmText,
    this.helpText,
    this.holidayDates,
  });

  final ParsiDate initialDate;
  final ParsiDate firstDate;
  final ParsiDate lastDate;
  final ParsiDate? currentDate;
  final ParsiDatePickerEntryMode initialEntryMode;
  final ParsiDatePickerMode initialCalendarMode;
  final bool Function(ParsiDate)? selectableDayPredicate;
  final String? cancelText;
  final String? confirmText;
  final String? helpText;
  final List<ParsiDate>? holidayDates;

  @override
  State<ParsiDatePickerDialog> createState() => _ParsiDatePickerDialogState();
}

class _ParsiDatePickerDialogState extends State<ParsiDatePickerDialog> {
  late ParsiDate _selectedDate;
  late ParsiDate _currentDisplayMonth;
  late ParsiDatePickerMode _mode;
  late ParsiDatePickerEntryMode _entryMode;
  final TextEditingController _inputController = TextEditingController();
  String? _inputError;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _currentDisplayMonth =
        ParsiDate(widget.initialDate.year, widget.initialDate.month, 1);
    _mode = widget.initialCalendarMode;
    _entryMode = widget.initialEntryMode;
    // Display Imperial year in input field
    _inputController.text =
        '${widget.initialDate.imperialYear}/${widget.initialDate.month.toString().padLeft(2, '0')}/${widget.initialDate.day.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _handleDaySelected(ParsiDate date) {
    if (widget.selectableDayPredicate != null &&
        !widget.selectableDayPredicate!(date)) {
      return;
    }
    setState(() => _selectedDate = date);
  }

  void _handleYearSelected(int year) {
    setState(() {
      _currentDisplayMonth = ParsiDate(year, _currentDisplayMonth.month, 1);
      _mode = ParsiDatePickerMode.day;
    });
  }

  void _handlePreviousMonth() {
    setState(() => _currentDisplayMonth = _currentDisplayMonth.addMonths(-1));
  }

  void _handleNextMonth() {
    setState(() => _currentDisplayMonth = _currentDisplayMonth.addMonths(1));
  }

  void _handleInputChanged(String value) {
    final parts = value.split('/');
    if (parts.length == 3) {
      final imperialYear = int.tryParse(parts[0]);
      final m = int.tryParse(parts[1]);
      final d = int.tryParse(parts[2]);
      if (imperialYear != null &&
          m != null &&
          d != null &&
          m >= 1 &&
          m <= 12 &&
          d >= 1 &&
          d <= 31) {
        // Convert Imperial year to Shamsi year
        final shamsiYear = imperialYear - 1180;
        final date = ParsiDate(shamsiYear, m, d);
        if (!date.isBefore(widget.firstDate) &&
            !date.isAfter(widget.lastDate)) {
          setState(() {
            _selectedDate = date;
            _inputError = null;
          });
          return;
        }
      }
    }
    setState(() => _inputError = 'تاریخ نادرست');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final localizations = MaterialLocalizations.of(context);

    final Widget content;
    if (_entryMode == ParsiDatePickerEntryMode.calendar) {
      content = _CalendarView(
        displayMonth: _currentDisplayMonth,
        selectedDate: _selectedDate,
        currentDate: widget.currentDate ?? ParsiDate.now(),
        firstDate: widget.firstDate,
        lastDate: widget.lastDate,
        mode: _mode,
        holidayDates: widget.holidayDates,
        selectableDayPredicate: widget.selectableDayPredicate,
        onDaySelected: _handleDaySelected,
        onYearSelected: _handleYearSelected,
        onPreviousMonth: _handlePreviousMonth,
        onNextMonth: _handleNextMonth,
        onModeChanged: (mode) => setState(() => _mode = mode),
      );
    } else {
      content = _InputView(
        controller: _inputController,
        error: _inputError,
        onChanged: _handleInputChanged,
      );
    }

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            _DatePickerHeader(
              selectedDate: _selectedDate,
              helpText: widget.helpText ?? 'انتخاب تاریخ',
              colorScheme: colorScheme,
              entryMode: _entryMode,
              onEntryModeChanged: (mode) => setState(() => _entryMode = mode),
            ),
            // Body
            content,
            // Actions
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                        widget.cancelText ?? localizations.cancelButtonLabel),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(_selectedDate),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child:
                        Text(widget.confirmText ?? localizations.okButtonLabel),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Header ─────────────────────────────────────────────────────────────────

class _DatePickerHeader extends StatelessWidget {
  const _DatePickerHeader({
    required this.selectedDate,
    required this.helpText,
    required this.colorScheme,
    required this.entryMode,
    required this.onEntryModeChanged,
  });

  final ParsiDate selectedDate;
  final String helpText;
  final ColorScheme colorScheme;
  final ParsiDatePickerEntryMode entryMode;
  final ValueChanged<ParsiDatePickerEntryMode> onEntryModeChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                helpText,
                style: TextStyle(color: colorScheme.onPrimary, fontSize: 12),
              ),
              IconButton(
                iconSize: 20,
                padding: EdgeInsets.zero,
                icon: Icon(
                  entryMode == ParsiDatePickerEntryMode.calendar
                      ? Icons.edit
                      : Icons.calendar_today,
                  color: colorScheme.onPrimary,
                ),
                onPressed: () => onEntryModeChanged(
                  entryMode == ParsiDatePickerEntryMode.calendar
                      ? ParsiDatePickerEntryMode.input
                      : ParsiDatePickerEntryMode.calendar,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '${_toPersianDigits(selectedDate.day.toString().padLeft(2, '0'))} ${selectedDate.monthName} ${_toPersianDigits(selectedDate.imperialYear.toString())}',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            selectedDate.weekDayName,
            style: TextStyle(
                color: colorScheme.onPrimary.withValues(alpha: 0.85),
                fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ─── Input View ─────────────────────────────────────────────────────────────

class _InputView extends StatelessWidget {
  const _InputView({
    required this.controller,
    required this.onChanged,
    this.error,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        textDirection: TextDirection.ltr,
        decoration: InputDecoration(
          labelText: 'تاریخ شاهنشاهی (YYYY/MM/DD)',
          errorText: error,
          border: const OutlineInputBorder(),
        ),
        onChanged: onChanged,
        keyboardType: TextInputType.number,
      ),
    );
  }
}

// ─── Calendar View ───────────────────────────────────────────────────────────

class _CalendarView extends StatelessWidget {
  const _CalendarView({
    required this.displayMonth,
    required this.selectedDate,
    required this.currentDate,
    required this.firstDate,
    required this.lastDate,
    required this.mode,
    required this.onDaySelected,
    required this.onYearSelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onModeChanged,
    this.holidayDates,
    this.selectableDayPredicate,
  });

  final ParsiDate displayMonth;
  final ParsiDate selectedDate;
  final ParsiDate currentDate;
  final ParsiDate firstDate;
  final ParsiDate lastDate;
  final ParsiDatePickerMode mode;
  final ValueChanged<ParsiDate> onDaySelected;
  final ValueChanged<int> onYearSelected;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<ParsiDatePickerMode> onModeChanged;
  final List<ParsiDate>? holidayDates;
  final bool Function(ParsiDate)? selectableDayPredicate;

  @override
  Widget build(BuildContext context) {
    if (mode == ParsiDatePickerMode.year) {
      return _YearPicker(
        selectedYear: selectedDate.year,
        firstYear: firstDate.year,
        lastYear: lastDate.year,
        onYearSelected: onYearSelected,
      );
    }
    return _MonthView(
      displayMonth: displayMonth,
      selectedDate: selectedDate,
      currentDate: currentDate,
      firstDate: firstDate,
      lastDate: lastDate,
      holidayDates: holidayDates,
      selectableDayPredicate: selectableDayPredicate,
      onDaySelected: onDaySelected,
      onPreviousMonth: onPreviousMonth,
      onNextMonth: onNextMonth,
      onModeChanged: onModeChanged,
    );
  }
}

// ─── Month View ──────────────────────────────────────────────────────────────

class _MonthView extends StatelessWidget {
  const _MonthView({
    required this.displayMonth,
    required this.selectedDate,
    required this.currentDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDaySelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onModeChanged,
    this.holidayDates,
    this.selectableDayPredicate,
  });

  final ParsiDate displayMonth;
  final ParsiDate selectedDate;
  final ParsiDate currentDate;
  final ParsiDate firstDate;
  final ParsiDate lastDate;
  final ValueChanged<ParsiDate> onDaySelected;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<ParsiDatePickerMode> onModeChanged;
  final List<ParsiDate>? holidayDates;
  final bool Function(ParsiDate)? selectableDayPredicate;

  bool _isHoliday(ParsiDate date) {
    if (holidayDates == null) return false;
    return holidayDates!.any((h) => h.isSameDay(date));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // First day of month's weekday (Saturday=1)
    final firstOfMonth = ParsiDate(displayMonth.year, displayMonth.month, 1);
    final startWeekDay = firstOfMonth.weekDay; // 1=Sat … 7=Fri
    final daysInMonth = firstOfMonth.monthLength;

    // Total cells: leading empty + days
    final leadingEmpty = startWeekDay - 1;
    final totalCells = leadingEmpty + daysInMonth;
    final rows = (totalCells / 7).ceil();

    final canGoPrev =
        ParsiDate(displayMonth.year, displayMonth.month, 1).isAfter(
      ParsiDate(firstDate.year, firstDate.month, 1),
    );
    final canGoNext =
        ParsiDate(displayMonth.year, displayMonth.month, 1).isBefore(
      ParsiDate(lastDate.year, lastDate.month, 1),
    );

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Month/year navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: canGoPrev ? onPreviousMonth : null,
                ),
                TextButton(
                  onPressed: () => onModeChanged(ParsiDatePickerMode.year),
                  child: Text(
                    '${displayMonth.monthName}  ${_toPersianDigits(displayMonth.imperialYear.toString())}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: canGoNext ? onNextMonth : null,
                ),
              ],
            ),
            // Weekday headers
            Row(
              children: ParsiDate.persianWeekDayNamesShort.map((name) {
                final isFriday = name == 'ج';
                return Expanded(
                  child: Center(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isFriday
                            ? colorScheme.error
                            : colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 4),
            // Day grid
            for (int row = 0; row < rows; row++)
              Row(
                children: List.generate(7, (col) {
                  final cellIndex = row * 7 + col;
                  final dayNum = cellIndex - leadingEmpty + 1;
                  if (dayNum < 1 || dayNum > daysInMonth) {
                    return const Expanded(child: SizedBox(height: 36));
                  }
                  final date =
                      ParsiDate(displayMonth.year, displayMonth.month, dayNum);
                  final isSelected = date.isSameDay(selectedDate);
                  final isToday = date.isSameDay(currentDate);
                  final isDisabled = date.isBefore(firstDate) ||
                      date.isAfter(lastDate) ||
                      (selectableDayPredicate != null &&
                          !selectableDayPredicate!(date));
                  final isHoliday =
                      _isHoliday(date) || col == 6; // Friday col=6
                  Color? textColor;
                  if (isDisabled) {
                    textColor = colorScheme.onSurface.withValues(alpha: 0.3);
                  } else if (isSelected) {
                    textColor = colorScheme.onPrimary;
                  } else if (isHoliday) {
                    textColor = colorScheme.error;
                  }

                  return Expanded(
                    child: GestureDetector(
                      onTap: isDisabled ? null : () => onDaySelected(date),
                      child: Container(
                        height: 36,
                        margin: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary
                              : Colors.transparent,
                          border: isToday && !isSelected
                              ? Border.all(
                                  color: colorScheme.primary, width: 1.5)
                              : null,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            _toPersianDigits(dayNum.toString()),
                            style: TextStyle(
                              fontSize: 13,
                              color: textColor ?? colorScheme.onSurface,
                              fontWeight: isToday ? FontWeight.bold : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ─── Year Picker ─────────────────────────────────────────────────────────────

class _YearPicker extends StatelessWidget {
  const _YearPicker({
    required this.selectedYear,
    required this.firstYear,
    required this.lastYear,
    required this.onYearSelected,
  });

  final int selectedYear;
  final int firstYear;
  final int lastYear;
  final ValueChanged<int> onYearSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final years = List.generate(lastYear - firstYear + 1, (i) => firstYear + i);

    return SizedBox(
      height: 240,
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 2.5,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
        ),
        itemCount: years.length,
        itemBuilder: (context, index) {
          final year = years[index];
          final imperialYear = year + 1180; // Convert Shamsi to Imperial
          final isSelected = year == selectedYear;
          return InkWell(
            onTap: () => onYearSelected(year),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: Text(
                _toPersianDigits(imperialYear.toString()),
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : null,
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

String _toPersianDigits(String s) {
  const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
  for (int i = 0; i < 10; i++) {
    s = s.replaceAll(en[i], fa[i]);
  }
  return s;
}
