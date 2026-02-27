import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Supported locales for parsi_date_picker.
enum ParsiLocale { fa, dari, ku, ps }

/// Material localizations delegate for Persian/Farsi.
class ParsiFaMaterialLocalizations extends DefaultMaterialLocalizations {
  const ParsiFaMaterialLocalizations();

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      _ParsiFaMaterialLocalizationsDelegate();

  @override
  String get okButtonLabel => 'تأیید';

  @override
  String get cancelButtonLabel => 'انصراف';

  @override
  String get datePickerHelpText => 'انتخاب تاریخ';

  @override
  String get dateRangePickerHelpText => 'انتخاب بازه تاریخ';

  @override
  String get dateRangeStartLabel => 'تاریخ شروع';

  @override
  String get dateRangeEndLabel => 'تاریخ پایان';

  @override
  String get saveButtonLabel => 'ذخیره';

  @override
  String get dateInputLabel => 'وارد کردن تاریخ';

  @override
  String get timePickerHourLabel => 'ساعت';

  @override
  String get timePickerMinuteLabel => 'دقیقه';

  @override
  String get anteMeridiemAbbreviation => 'ق.ظ';

  @override
  String get postMeridiemAbbreviation => 'ب.ظ';

  @override
  String get invalidDateFormatLabel => 'فرمت تاریخ نادرست';

  @override
  String get invalidDateRangeLabel => 'بازه تاریخ نادرست';

  @override
  String get dateOutOfRangeLabel => 'تاریخ خارج از بازه مجاز';

  @override
  String get calendarModeButtonLabel => 'تقویم';

  @override
  String get inputDateModeButtonLabel => 'ورودی';

  @override
  String get nextMonthTooltip => 'ماه بعد';

  @override
  String get previousMonthTooltip => 'ماه قبل';

  @override
  String get nextPageTooltip => 'صفحه بعد';

  @override
  String get previousPageTooltip => 'صفحه قبل';

  @override
  String get showMenuTooltip => 'نمایش منو';
}

class _ParsiFaMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _ParsiFaMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'fa' ||
      locale.languageCode == 'prs' ||
      locale.languageCode == 'ku' ||
      locale.languageCode == 'ps';

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      SynchronousFuture<MaterialLocalizations>(
        const ParsiFaMaterialLocalizations(),
      );

  @override
  bool shouldReload(_ParsiFaMaterialLocalizationsDelegate old) => false;
}

/// Cupertino localizations delegate for Persian.
class ParsiFaCupertinoLocalizations extends DefaultCupertinoLocalizations {
  const ParsiFaCupertinoLocalizations();

  static const LocalizationsDelegate<CupertinoLocalizations> delegate =
      _ParsiFaCupertinoLocalizationsDelegate();
}

class _ParsiFaCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _ParsiFaCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      locale.languageCode == 'fa' ||
      locale.languageCode == 'prs' ||
      locale.languageCode == 'ku' ||
      locale.languageCode == 'ps';

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      SynchronousFuture<CupertinoLocalizations>(
        const ParsiFaCupertinoLocalizations(),
      );

  @override
  bool shouldReload(_ParsiFaCupertinoLocalizationsDelegate old) => false;
}

/// Convenience list of all delegates needed for a Persian Flutter app.
/// Add these to [MaterialApp.localizationsDelegates].
const List<LocalizationsDelegate<dynamic>> parsiLocalizationsDelegates = [
  ParsiFaMaterialLocalizations.delegate,
  ParsiFaCupertinoLocalizations.delegate,
  GlobalMaterialLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
];

/// Convenience list of supported locales.
const List<Locale> parsiSupportedLocales = [
  Locale('fa', 'IR'), // Farsi
  Locale('prs', 'AF'), // Dari
  Locale('ku', 'IR'), // Kurdish
  Locale('ps', 'AF'), // Pashto
  Locale('en', 'US'),
];
