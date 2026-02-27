# Parsi DateTime Picker

[![pub package](https://img.shields.io/pub/v/parsi_datetime_picker.svg)](https://pub.dev/packages/parsi_datetime_picker)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A comprehensive Persian (Jalali/Shamsi) date and time picker package for Flutter with full support for Material Design and Cupertino styles. Built on top of [`imperial_persian_date`](https://pub.dev/packages/imperial_persian_date) for accurate calendar conversions.


<img width="2816" height="1504" alt="Gemini_Generated_Image_kn5zz1kn5zz1kn5z" src="https://github.com/user-attachments/assets/c8365162-30de-4a2a-8a8c-216fbe064c73" />


## ✨ Features

- 📅 **Material Date Picker** — Beautiful Jalali calendar grid with month/year navigation
- 📆 **Date Range Picker** — Select start and end dates with visual range highlighting
- ⏰ **Time Picker** — RTL-aware time picker with Persian labels
- 🍎 **Cupertino Date Picker** — iOS-style scroll picker (date, time, or combined)
- ⌨️ **Input Mode** — Direct text input for dates in `YYYY/MM/DD` format
- 🎨 **Material 3 Support** — Modern design with dynamic color schemes
- 🔢 **Persian Digits** — All numbers displayed in Persian numerals (۱۲۳۴۵۶۷۸۹۰)
- 👑 **Imperial Persian Calendar** — Access Shahanshahi years (Shamsi + 1180)
- 🎯 **Holiday Highlighting** — Mark specific dates as holidays in red
- 🚫 **Selectable Day Predicate** — Disable specific dates or weekdays
- 🌍 **Multi-language Support** — Farsi, Dari, Kurdish, Pashto, and English
- 🎭 **RTL Support** — Full right-to-left layout support
- 🔄 **Bidirectional Conversion** — Seamless conversion between Gregorian, Shamsi, and Imperial calendars

## 📦 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  parsi_datetime_picker: ^0.0.1
  flutter_localizations:
    sdk: flutter
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

### 1. Setup Localization

Add the localization delegates to your `MaterialApp`:

```dart
import 'package:flutter/material.dart';
import 'package:parsi_datetime_picker/parsi_datetime_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parsi Date Picker Demo',
      localizationsDelegates: parsiLocalizationsDelegates,
      supportedLocales: parsiSupportedLocales,
      locale: const Locale('fa', 'IR'),
      home: const HomePage(),
    );
  }
}
```

### 2. Use Date Picker

```dart
final ParsiDate? picked = await showParsiDatePicker(
  context: context,
  initialDate: ParsiDate.now(),
  firstDate: ParsiDate(1380, 1, 1),
  lastDate: ParsiDate(1450, 12, 29),
  helpText: 'انتخاب تاریخ',
);

if (picked != null) {
  print('Selected: ${picked.format('WWWW، DD MMMM YYYY')}');
  // Output: سه‌شنبه، ۱۵ شهریور ۱۴۰۴
}
```

## 📖 Usage Examples

### Material Date Picker

```dart
final ParsiDate? date = await showParsiDatePicker(
  context: context,
  initialDate: ParsiDate.now(),
  firstDate: ParsiDate(1380, 1, 1),
  lastDate: ParsiDate(1450, 12, 29),
  
  // Optional: Highlight holidays
  holidayDates: [
    ParsiDate(1404, 1, 1),  // Nowruz
    ParsiDate(1404, 1, 2),
    ParsiDate(1404, 1, 3),
  ],
  
  // Optional: Disable specific days
  selectableDayPredicate: (date) {
    // Disable Fridays
    return date.weekDay != 7;
  },
  
  // Optional: Custom labels
  helpText: 'انتخاب تاریخ تولد',
  cancelText: 'انصراف',
  confirmText: 'تایید',
);
```

### Date Range Picker

```dart
final ParsiDateRange? range = await showParsiDateRangePicker(
  context: context,
  firstDate: ParsiDate(1380, 1, 1),
  lastDate: ParsiDate(1450, 12, 29),
  
  // Optional: Initial range
  initialDateRange: ParsiDateRange(
    start: ParsiDate(1404, 6, 1),
    end: ParsiDate(1404, 6, 10),
  ),
  
  helpText: 'انتخاب بازه تاریخ',
);

if (range != null) {
  print('از ${range.start.format('DD MMMM')} تا ${range.end.format('DD MMMM')}');
}
```

### Time Picker

```dart
final TimeOfDay? time = await showParsiTimePicker(
  context: context,
  initialTime: TimeOfDay.now(),
  helpText: 'انتخاب ساعت',
);

if (time != null) {
  print('Selected time: ${time.hour}:${time.minute}');
}
```

### Cupertino Date Picker

```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  ParsiDate _selectedDate = ParsiDate.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('تاریخ انتخابی: ${_selectedDate.format('DD MMMM YYYY')}'),
        SizedBox(
          height: 200,
          child: ParsiCupertinoDatePicker(
            mode: ParsiCupertinoDatePickerMode.date,
            initialDateTime: _selectedDate,
            minimumDate: ParsiDate(1380, 1, 1),
            maximumDate: ParsiDate(1450, 12, 29),
            onDateTimeChanged: (date) {
              setState(() => _selectedDate = date);
            },
          ),
        ),
      ],
    );
  }
}
```

### Input Mode (Text Entry)

```dart
final ParsiDate? date = await showParsiDatePicker(
  context: context,
  initialDate: ParsiDate.now(),
  firstDate: ParsiDate(1380, 1, 1),
  lastDate: ParsiDate(1450, 12, 29),
  initialEntryMode: ParsiDatePickerEntryMode.input,
);
```

## 🗓️ ParsiDate API

### Constructors

```dart
// Create from Shamsi components
ParsiDate(1404, 6, 15)

// Current date
ParsiDate.now()

// From Gregorian DateTime
ParsiDate.fromDateTime(DateTime(2025, 9, 6))
```

### Properties

```dart
final date = ParsiDate(1404, 6, 15);

date.year           // 1404 (Shamsi year)
date.month          // 6 (1-12)
date.day            // 15 (1-31)
date.hour           // 0-23
date.minute         // 0-59
date.second         // 0-59

date.monthName      // 'شهریور'
date.monthNameEn    // 'Shahrivar'
date.weekDayName    // 'سه‌شنبه'
date.weekDay        // 1-7 (1=Saturday, 7=Friday)

date.isLeapYear     // true/false
date.monthLength    // 29-31 days

date.imperialYear   // 2584 (Shahanshahi year = Shamsi + 1180)
```

### Conversion Methods

```dart
// To Gregorian
DateTime gregorian = date.toDateTime();

// From Gregorian (extension method)
ParsiDate parsi = DateTime.now().toParsiDate();
```

### Date Arithmetic

```dart
final date = ParsiDate(1404, 6, 15);

// Add/subtract days
date.addDays(5)      // 1404/06/20
date.addDays(-10)    // 1404/06/05

// Add/subtract months
date.addMonths(2)    // 1404/08/15
date.addMonths(-1)   // 1404/05/15

// Add/subtract years
date.addYears(1)     // 1405/06/15

// Copy with modifications
date.copyWith(
  year: 1405,
  month: 7,
  day: 20,
)
```

### Date Comparison

```dart
final date1 = ParsiDate(1404, 6, 15);
final date2 = ParsiDate(1404, 7, 1);

date1.isBefore(date2)           // true
date1.isAfter(date2)            // false
date1.isAtSameMomentAs(date2)   // false
date1.isSameDay(date2)          // false

date1.difference(date2)         // -16 days
date1.compareTo(date2)          // -1
```

### Formatting

```dart
final date = ParsiDate(1404, 6, 15, hour: 14, minute: 30);

// Persian format
date.format('WWWW، DD MMMM YYYY')  // سه‌شنبه، ۱۵ شهریور ۱۴۰۴
date.format('DD/MM/YYYY')          // ۱۵/۰۶/۱۴۰۴
date.format('YYYY/MM/DD')          // ۱۴۰۴/۰۶/۱۵

// English format
date.format('WWWW، DD MMM YYYY')   // Tuesday، 15 Shahrivar 1404

// With time
date.format('YYYY/MM/DD HH:mm')    // ۱۴۰۴/۰۶/۱۵ ۱۴:۳۰
```

### Format Tokens

| Token  | Description              | Example          |
|--------|--------------------------|------------------|
| `YYYY` | 4-digit year             | ۱۴۰۴             |
| `YY`   | 2-digit year             | ۰۴               |
| `MMMM` | Full month name (Farsi)  | شهریور           |
| `MMM`  | Month name (English)     | Shahrivar        |
| `MM`   | Zero-padded month        | ۰۶               |
| `M`    | Month number             | ۶                |
| `DD`   | Zero-padded day          | ۱۵               |
| `D`    | Day number               | ۱۵               |
| `WWWW` | Full weekday (Farsi)     | سه‌شنبه          |
| `HH`   | Hour (00-23)             | ۱۴               |
| `mm`   | Minute (00-59)           | ۳۰               |
| `ss`   | Second (00-59)           | ۰۵               |

## 🌍 Calendar Systems

This package supports three calendar systems:

### 1. Shamsi (Solar Hijri / Jalali)
The official calendar of Iran and Afghanistan.
- Year 1 = 622 CE (Hijra)
- Example: 1404/06/15

### 2. Gregorian
The international standard calendar.
- Example: 2025-09-06

### 3. Imperial Persian (Shahanshahi)
Historical Persian calendar based on Cyrus the Great's coronation.
- Year 1 = 559 BCE
- Conversion: Imperial Year = Shamsi Year + 1180
- Example: 2584/06/15

```dart
final date = ParsiDate(1404, 6, 15);

print('Shamsi: ${date.year}');           // 1404
print('Imperial: ${date.imperialYear}'); // 2584
print('Gregorian: ${date.toDateTime()}'); // 2025-09-06
```

## 🎨 Customization

### Custom Theme

The pickers automatically adapt to your app's theme:

```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
    useMaterial3: true,
  ),
  // ...
)
```

### Custom Labels

```dart
await showParsiDatePicker(
  context: context,
  initialDate: ParsiDate.now(),
  firstDate: ParsiDate(1380, 1, 1),
  lastDate: ParsiDate(1450, 12, 29),
  helpText: 'لطفا تاریخ را انتخاب کنید',
  cancelText: 'بستن',
  confirmText: 'تایید',
);
```

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Windows
- ✅ Linux

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Credits

- Built on top of [`imperial_persian_date`](https://pub.dev/packages/imperial_persian_date)
- Inspired by Flutter's Material and Cupertino date pickers

## 📞 Support

For issues, feature requests, or questions, please visit the [GitHub repository](https://github.com/yourusername/parsi_datetime_picker/issues).

---

Made with ❤️ for the Persian-speaking Flutter community
