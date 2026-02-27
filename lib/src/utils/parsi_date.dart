import 'package:imperial_persian_date/imperial_persian_date.dart';

/// Wraps [ImperialPersianDate] and exposes a unified Jalali (Shamsi) API.
///
/// All calendar arithmetic is delegated to [ImperialPersianDate] which
/// supports Gregorian ↔ Shamsi ↔ Imperial conversions internally.
class ParsiDate {
  final ImperialPersianDate _internal;

  /// The Shamsi (Solar Hijri / Jalali) year, e.g. 1404.
  int get year => _shamsiYear;
  int get month => _shamsiMonth;
  int get day => _shamsiDay;

  int get hour => _internal.hour;
  int get minute => _internal.minute;
  int get second => _internal.second;
  int get millisecond => _internal.millisecond;

  final int _shamsiYear;
  final int _shamsiMonth;
  final int _shamsiDay;

  ParsiDate._(
      this._internal, this._shamsiYear, this._shamsiMonth, this._shamsiDay);

  /// Creates a [ParsiDate] from Jalali (Shamsi) components.
  factory ParsiDate(int year, int month, int day,
      {int hour = 0, int minute = 0, int second = 0, int millisecond = 0}) {
    final imp = ImperialPersianDate.fromShamsi(year, month, day);
    // Reconstruct with time if needed
    final withTime = ImperialPersianDate(
      imp.year,
      imp.month,
      imp.day,
      hour: hour,
      minute: minute,
      second: second,
      millisecond: millisecond,
    );
    return ParsiDate._(withTime, year, month, day);
  }

  /// Current date/time in Jalali calendar.
  factory ParsiDate.now() {
    final imp = ImperialPersianDate.now();
    final shamsi = imp.toShamsi();
    return ParsiDate._(imp, shamsi[0], shamsi[1], shamsi[2]);
  }

  /// Creates a [ParsiDate] from a Gregorian [DateTime].
  factory ParsiDate.fromDateTime(DateTime dateTime) {
    final imp = ImperialPersianDate.fromGregorian(dateTime);
    final shamsi = imp.toShamsi();
    return ParsiDate._(imp, shamsi[0], shamsi[1], shamsi[2]);
  }

  /// Converts to Gregorian [DateTime].
  DateTime toDateTime() {
    final g = _internal.toGregorian();
    return DateTime(g.year, g.month, g.day, hour, minute, second, millisecond);
  }

  /// Returns the Imperial Persian year (Shamsi year + 1180).
  int get imperialYear => _internal.year;

  /// Number of days in this month.
  int get monthLength => _internal.monthLength;

  /// Day of week: Saturday=1 … Friday=7 (Persian week).
  int get weekDay {
    final gregWd = toDateTime().weekday; // Mon=1..Sun=7
    // Map to Persian: Shanbe=1(Sat), Yekshanbe=2(Sun)...Jomeh=7(Fri)
    const Map<int, int> map = {
      6: 1, // Sat
      7: 2, // Sun
      1: 3, // Mon
      2: 4, // Tue
      3: 5, // Wed
      4: 6, // Thu
      5: 7, // Fri
    };
    return map[gregWd] ?? gregWd;
  }

  /// Persian month name in Farsi.
  String get monthName => _persianMonthNames[month - 1];

  /// Persian month name in English.
  String get monthNameEn => _persianMonthNamesEn[month - 1];

  /// Persian weekday name in Farsi.
  String get weekDayName => _persianWeekDayNames[weekDay - 1];

  bool get isLeapYear => _isLeapYear(year);

  static bool _isLeapYear(int y) {
    // Jalali leap year algorithm
    const leapCycle = [1, 5, 9, 13, 17, 22, 26, 30];
    return leapCycle.contains(y % 33);
  }

  /// Add years/months/days returning a new [ParsiDate].
  ParsiDate addDays(int days) =>
      ParsiDate.fromDateTime(toDateTime().add(Duration(days: days)));

  ParsiDate addMonths(int months) {
    int m = month + months;
    int y = year + (m - 1) ~/ 12;
    m = ((m - 1) % 12) + 1;
    int d = day.clamp(1, _monthLength(y, m));
    return ParsiDate(y, m, d);
  }

  ParsiDate addYears(int years) => copyWith(year: year + years);

  /// Returns new [ParsiDate] with given fields replaced.
  ParsiDate copyWith(
      {int? year, int? month, int? day, int? hour, int? minute, int? second}) {
    return ParsiDate(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      second: second ?? this.second,
    );
  }

  /// Difference in days between two [ParsiDate]s.
  int difference(ParsiDate other) {
    return toDateTime().difference(other.toDateTime()).inDays;
  }

  bool isBefore(ParsiDate other) => toDateTime().isBefore(other.toDateTime());
  bool isAfter(ParsiDate other) => toDateTime().isAfter(other.toDateTime());
  bool isAtSameMomentAs(ParsiDate other) =>
      toDateTime().isAtSameMomentAs(other.toDateTime());

  bool isSameDay(ParsiDate other) =>
      year == other.year && month == other.month && day == other.day;

  int compareTo(ParsiDate other) => toDateTime().compareTo(other.toDateTime());

  /// Formats the date. Supported tokens:
  /// `YYYY` year, `YY` 2-digit year, `MM` zero-padded month, `M` month,
  /// `DD` zero-padded day, `D` day, `MMMM` month name (fa), `MMM` month name (en),
  /// `WWWW` weekday name (fa), `HH` hour, `mm` minute, `ss` second.
  String format(String pattern) {
    return pattern
        .replaceAll('YYYY', _pad(year, 4))
        .replaceAll('YY', _pad(year % 100, 2))
        .replaceAll('MMMM', monthName)
        .replaceAll('MMM', monthNameEn)
        .replaceAll('MM', _pad(month, 2))
        .replaceAll('M', month.toString())
        .replaceAll('WWWW', weekDayName)
        .replaceAll('DD', _pad(day, 2))
        .replaceAll('D', day.toString())
        .replaceAll('HH', _pad(hour, 2))
        .replaceAll('mm', _pad(minute, 2))
        .replaceAll('ss', _pad(second, 2));
  }

  static String _pad(int v, int width) => v.toString().padLeft(width, '0');

  static int _monthLength(int y, int m) {
    if (m <= 6) return 31;
    if (m <= 11) return 30;
    return _isLeapYear(y) ? 30 : 29;
  }

  @override
  String toString() => format('YYYY/MM/DD');

  @override
  bool operator ==(Object other) =>
      other is ParsiDate &&
      year == other.year &&
      month == other.month &&
      day == other.day;

  @override
  int get hashCode => Object.hash(year, month, day);

  bool operator <(ParsiDate other) => isBefore(other);
  bool operator >(ParsiDate other) => isAfter(other);
  bool operator <=(ParsiDate other) => !isAfter(other);
  bool operator >=(ParsiDate other) => !isBefore(other);

  static const List<String> _persianMonthNames = [
    'فروردین',
    'اردیبهشت',
    'خرداد',
    'تیر',
    'مرداد',
    'شهریور',
    'مهر',
    'آبان',
    'آذر',
    'دی',
    'بهمن',
    'اسفند',
  ];

  static const List<String> _persianMonthNamesEn = [
    'Farvardin',
    'Ordibehesht',
    'Khordad',
    'Tir',
    'Mordad',
    'Shahrivar',
    'Mehr',
    'Aban',
    'Azar',
    'Dey',
    'Bahman',
    'Esfand',
  ];

  static const List<String> _persianWeekDayNames = [
    'شنبه',
    'یک‌شنبه',
    'دوشنبه',
    'سه‌شنبه',
    'چهارشنبه',
    'پنج‌شنبه',
    'جمعه',
  ];

  static const List<String> persianMonthNames = _persianMonthNames;
  static const List<String> persianWeekDayNames = _persianWeekDayNames;
  static const List<String> persianWeekDayNamesShort = [
    'ش',
    'ی',
    'د',
    'س',
    'چ',
    'پ',
    'ج',
  ];
}
