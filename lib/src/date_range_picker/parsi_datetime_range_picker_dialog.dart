import 'package:flutter/material.dart';

import '../utils/extensions.dart';
import '../utils/parsi_date.dart';
import '../utils/parsi_date_range.dart';

/// Dialog for picking a Persian date range.
class ParsiDateRangePickerDialog extends StatefulWidget {
  const ParsiDateRangePickerDialog({
    super.key,
    required this.firstDate,
    required this.lastDate,
    this.initialDateRange,
    this.initialDate,
    this.currentDate,
    this.helpText,
    this.cancelText,
    this.confirmText,
    this.saveText,
  });

  final ParsiDate firstDate;
  final ParsiDate lastDate;
  final ParsiDateRange? initialDateRange;
  final ParsiDate? initialDate;
  final ParsiDate? currentDate;
  final String? helpText;
  final String? cancelText;
  final String? confirmText;
  final String? saveText;

  @override
  State<ParsiDateRangePickerDialog> createState() =>
      _ParsiDateRangePickerDialogState();
}

class _ParsiDateRangePickerDialogState
    extends State<ParsiDateRangePickerDialog> {
  ParsiDate? _startDate;
  ParsiDate? _endDate;
  late ParsiDate _displayMonth;

  @override
  void initState() {
    super.initState();
    _startDate = widget.initialDateRange?.start;
    _endDate = widget.initialDateRange?.end;
    _displayMonth = _startDate != null
        ? ParsiDate(_startDate!.year, _startDate!.month, 1)
        : ParsiDate.now().copyWith(day: 1);
  }

  void _handleDayTap(ParsiDate date) {
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = date;
        _endDate = null;
      } else {
        if (date.isBefore(_startDate!)) {
          _endDate = _startDate;
          _startDate = date;
        } else {
          _endDate = date;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = MaterialLocalizations.of(context);

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.helpText ?? 'انتخاب بازه تاریخ',
                      style:
                          TextStyle(color: colorScheme.onPrimary, fontSize: 12),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _RangeLabel(
                          label: 'از',
                          date: _startDate,
                          colorScheme: colorScheme,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(Icons.arrow_back,
                              color: colorScheme.onPrimary, size: 18),
                        ),
                        _RangeLabel(
                          label: 'تا',
                          date: _endDate,
                          colorScheme: colorScheme,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Month navigation
              _RangeMonthView(
                displayMonth: _displayMonth,
                startDate: _startDate,
                endDate: _endDate,
                currentDate: widget.currentDate ?? ParsiDate.now(),
                firstDate: widget.firstDate,
                lastDate: widget.lastDate,
                onDayTap: _handleDayTap,
                onPreviousMonth: () =>
                    setState(() => _displayMonth = _displayMonth.addMonths(-1)),
                onNextMonth: () =>
                    setState(() => _displayMonth = _displayMonth.addMonths(1)),
              ),
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
                      onPressed: _startDate != null && _endDate != null
                          ? () => Navigator.of(context).pop(
                                ParsiDateRange(
                                    start: _startDate!, end: _endDate!),
                              )
                          : null,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                          widget.saveText ?? localizations.saveButtonLabel),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RangeLabel extends StatelessWidget {
  const _RangeLabel({
    required this.label,
    required this.date,
    required this.colorScheme,
  });

  final String label;
  final ParsiDate? date;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              color: colorScheme.onPrimary.withValues(alpha: 0.7),
              fontSize: 11),
        ),
        Text(
          date != null
              ? '${toPersianDigits(date!.day.toString().padLeft(2, '0'))} ${date!.monthName} ${toPersianDigits(date!.imperialYear.toString())}'
              : '—',
          style: TextStyle(
              color: colorScheme.onPrimary,
              fontSize: 15,
              fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _RangeMonthView extends StatelessWidget {
  const _RangeMonthView({
    required this.displayMonth,
    required this.startDate,
    required this.endDate,
    required this.currentDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDayTap,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  final ParsiDate displayMonth;
  final ParsiDate? startDate;
  final ParsiDate? endDate;
  final ParsiDate currentDate;
  final ParsiDate firstDate;
  final ParsiDate lastDate;
  final ValueChanged<ParsiDate> onDayTap;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  bool _inRange(ParsiDate date) {
    if (startDate == null || endDate == null) return false;
    return date.isAfter(startDate!) && date.isBefore(endDate!);
  }

  bool _isStart(ParsiDate date) =>
      startDate != null && date.isSameDay(startDate!);
  bool _isEnd(ParsiDate date) => endDate != null && date.isSameDay(endDate!);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final firstOfMonth = ParsiDate(displayMonth.year, displayMonth.month, 1);
    final leadingEmpty = firstOfMonth.weekDay - 1;
    final daysInMonth = firstOfMonth.monthLength;
    final rows = ((leadingEmpty + daysInMonth) / 7).ceil();

    final canGoPrev = ParsiDate(displayMonth.year, displayMonth.month, 1)
        .isAfter(ParsiDate(firstDate.year, firstDate.month, 1));
    final canGoNext = ParsiDate(displayMonth.year, displayMonth.month, 1)
        .isBefore(ParsiDate(lastDate.year, lastDate.month, 1));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: canGoPrev ? onPreviousMonth : null,
              ),
              Text(
                '${displayMonth.monthName}  ${toPersianDigits(displayMonth.imperialYear.toString())}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: canGoNext ? onNextMonth : null,
              ),
            ],
          ),
          Row(
            children: ParsiDate.persianWeekDayNamesShort.map((name) {
              return Expanded(
                child: Center(
                  child: Text(name,
                      style: TextStyle(
                          fontSize: 11,
                          color: colorScheme.onSurface.withValues(alpha: 0.5))),
                ),
              );
            }).toList(),
          ),
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
                final isStart = _isStart(date);
                final isEnd = _isEnd(date);
                final inRange = _inRange(date);
                final isToday = date.isSameDay(currentDate);
                final isDisabled =
                    date.isBefore(firstDate) || date.isAfter(lastDate);

                Color? bgColor;
                Color? textColor;
                BoxShape shape = BoxShape.circle;

                if (isStart || isEnd) {
                  bgColor = colorScheme.primary;
                  textColor = colorScheme.onPrimary;
                } else if (inRange) {
                  bgColor = colorScheme.primary.withValues(alpha: 0.15);
                  shape = BoxShape.rectangle;
                }

                if (isDisabled) {
                  textColor = colorScheme.onSurface.withValues(alpha: 0.3);
                  bgColor = null;
                }

                return Expanded(
                  child: GestureDetector(
                    onTap: isDisabled ? null : () => onDayTap(date),
                    child: Container(
                      height: 36,
                      margin: EdgeInsets.symmetric(
                          vertical: 1, horizontal: inRange ? 0 : 1),
                      decoration: BoxDecoration(
                        color: bgColor,
                        shape: shape,
                        borderRadius: inRange && !isStart && !isEnd
                            ? BorderRadius.zero
                            : null,
                        border: isToday && !isStart && !isEnd
                            ? Border.all(color: colorScheme.primary, width: 1.5)
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          toPersianDigits(dayNum.toString()),
                          style: TextStyle(
                              fontSize: 13,
                              color: textColor ?? colorScheme.onSurface,
                              fontWeight: isToday ? FontWeight.bold : null),
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
    );
  }
}
