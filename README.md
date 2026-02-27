# Parsi DateTime Picker

[![pub package](https://img.shields.io/pub/v/parsi_datetime_picker.svg)](https://pub.dev/packages/parsi_datetime_picker)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Pub Version](https://img.shields.io/badge/pub-v0.0.1-blue)](https://pub.dev/packages/parsi_datetime_picker)

A complete Flutter package for Persian (Jalali/Shamsi) date and time picking, with support for Material and Cupertino design. Built on top of [`imperial_persian_date`](https://pub.dev/packages/imperial_persian_date) for accurate calendar conversion.

**✨ Special Feature:** All dates in the UI are displayed as **Imperial Persian Calendar** years (e.g. 2584).

---


<img width="2816" height="1504" alt="Gemini_Generated_Image_kn5zz1kn5zz1kn5z" src="https://github.com/user-attachments/assets/c8365162-30de-4a2a-8a8c-216fbe064c73" />


## ✨ Features

- 📅 **Material Date Picker** — Beautiful Jalali calendar with month/year navigation
- 📆 **Date Range Picker** — Select start and end dates with visual range highlighting
- ⏰ **Time Picker** — Time selection with RTL support and Persian labels
- 🍎 **Cupertino Picker** — iOS-style picker (date, time, or combined)
- ⌨️ **Text Input Mode** — Direct date entry in `YYYY/MM/DD` format
- 🎨 **Material 3 Support** — Modern design with dynamic color schemes
- 🔢 **Persian Numerals** — All numbers displayed in Persian digits (۱۲۳۴۵۶۷۸۹۰)
- 👑 **Imperial Calendar** — Year display in Imperial Persian format across all UIs
- 🎯 **Holiday Display** — Mark holidays in red
- 🚫 **Disable Specific Days** — Disable individual dates or specific weekdays
- 🌍 **Multi-language Support** — Persian, Dari, Kurdish, Pashto, and English
- 🎭 **Full RTL Support** — Complete right-to-left layout
- 🔄 **Bidirectional Conversion** — Seamless conversion between Gregorian, Shamsi, and Imperial calendars

---

## 📦 Installation

Add the following to your `pubspec.yaml`:

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

---

## 🚀 Quick Start

### 1. Setup Localization

Add localization delegates to your `MaterialApp`:

```dart
import 'package:flutter/material.dart';
import 'package:parsi_datetime_picker/parsi_datetime_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parsi Date Picker Example',
      localizationsDelegates: parsiLocalizationsDelegates,
      supportedLocales: parsiSupportedLocales,
      locale: const Locale('fa', 'IR'),
      home: const HomePage(),
    );
  }
}
```

### 2. Show the Date Picker

```dart
final ParsiDate? picked = await showParsiDatePicker(
  context: context,
  initialDate: ParsiDate.now(),
  firstDate: ParsiDate(2560, 1, 1),   // Imperial year 2560
  lastDate: ParsiDate(2630, 12, 29),  // Imperial year 2630
  helpText: 'Select Date',
);

if (picked != null) {
  print('Selected Imperial year: ${picked.imperialYear}'); // e.g. 2584
  print('Internal Shamsi year: ${picked.year}');           // e.g. 1404
}
```

> **Important Note:** The picker UI displays **Imperial Persian** years (e.g. 2584), while `ParsiDate` internally uses Shamsi years for calculations.

---

## 📖 Usage Examples

### Material Date Picker

```dart
final ParsiDate? date = await showParsiDatePicker(
  context: context,
  initialDate: ParsiDate.now(),
  firstDate: ParsiDate(2560, 1, 1),
  lastDate: ParsiDate(2630, 12, 29),

  // Optional: mark holidays (e.g. Nowruz)
  holidayDates: [
    ParsiDate(2584, 1, 1),
    ParsiDate(2584, 1, 2),
    ParsiDate(2584, 1, 3),
  ],

  // Optional: disable specific days
  selectableDayPredicate: (date) {
    return date.weekDay != 7; // disable Fridays
  },

  // Optional: custom labels
  helpText: 'Select Birthday',
  cancelText: 'Cancel',
  confirmText: 'Confirm',
);
```

### Date Range Picker

```dart
final ParsiDateRange? range = await showParsiDateRangePicker(
  context: context,
  firstDate: ParsiDate(2560, 1, 1),
  lastDate: ParsiDate(2630, 12, 29),

  // Optional: initial range
  initialDateRange: ParsiDateRange(
    start: ParsiDate(2584, 6, 1),
    end: ParsiDate(2584, 6, 10),
  ),

  helpText: 'Select Date Range',
);

if (range != null) {
  print('From ${range.start.imperialYear}/${range.start.month}/${range.start.day}');
  print('To ${range.end.imperialYear}/${range.end.month}/${range.end.day}');
}
```

### Time Picker

```dart
final TimeOfDay? time = await showParsiTimePicker(
  context: context,
  initialTime: TimeOfDay.now(),
  helpText: 'Select Time',
);

if (time != null) {
  print('Selected time: ${time.hour}:${time.minute}');
}
```

### Cupertino Picker

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
        Text('Date: ${_selectedDate.imperialYear}/${_selectedDate.month}/${_selectedDate.day}'),
        SizedBox(
          height: 200,
          child: ParsiCupertinoDatePicker(
            mode: ParsiCupertinoDatePickerMode.date,
            initialDateTime: _selectedDate,
            minimumDate: ParsiDate(2560, 1, 1),
            maximumDate: ParsiDate(2630, 12, 29),
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

### Text Input Mode

```dart
final ParsiDate? date = await showParsiDatePicker(
  context: context,
  initialDate: ParsiDate.now(),
  firstDate: ParsiDate(2560, 1, 1),
  lastDate: ParsiDate(2630, 12, 29),
  initialEntryMode: ParsiDatePickerEntryMode.input,
);
```

> **Note:** In input mode, users enter dates in Imperial Persian format: `YYYY/MM/DD` (e.g. ۲۵۸۴/۰۶/۱۵)

---

## 🗓️ ParsiDate Class API

### Constructors

```dart
ParsiDate(2584, 6, 15)          // Specific date
ParsiDate.now()                  // Today
ParsiDate.fromDateTime(DateTime(2025, 9, 6))  // From Gregorian
```

### Properties

```dart
final date = ParsiDate(2584, 6, 15);

date.year           // 2584
date.month          // 6 (1–12)
date.day            // 15 (1–31)
date.hour           // 0–23
date.minute         // 0–59
date.second         // 0–59

date.monthName      // 'شهریور'
date.monthNameEn    // 'Shahrivar'
date.weekDayName    // 'سه‌شنبه'
date.weekDay        // 1–7 (1=Saturday, 7=Friday)

date.isLeapYear     // true/false
date.monthLength    // 29–31

date.imperialYear   // 2584
```

### Conversion Methods

```dart
DateTime gregorian = date.toDateTime();
ParsiDate parsi = DateTime.now().toParsiDate();
```

### Date Arithmetic

```dart
final date = ParsiDate(2584, 6, 15);

date.addDays(5)      // 2584/6/20
date.addDays(-10)    // 2584/6/5
date.addMonths(2)    // 2584/8/15
date.addMonths(-1)   // 2584/5/15
date.addYears(1)     // 2585/6/15

date.copyWith(year: 2585, month: 7, day: 20)
```

### Date Comparison

```dart
final date1 = ParsiDate(2584, 6, 15);
final date2 = ParsiDate(2584, 7, 1);

date1.isBefore(date2)           // true
date1.isAfter(date2)            // false
date1.isAtSameMomentAs(date2)   // false
date1.isSameDay(date2)          // false

date1.difference(date2)         // -16
date1.compareTo(date2)          // -1
```

### Formatting

```dart
final date = ParsiDate(2584, 6, 15, hour: 14, minute: 30);

date.format('WWWW، DD MMMM YYYY')  // سه‌شنبه، ۱۵ شهریور ۲۵۸۴
date.format('DD/MM/YYYY')          // ۱۵/۰۶/۲۵۸۴
date.format('YYYY/MM/DD')          // ۲۵۸۴/۰۶/۱۵
date.format('YYYY/MM/DD HH:mm')    // ۲۵۸۴/۰۶/۱۵ ۱۴:۳۰
```

### Format Tokens

| Token  | Description                    | Example     |
|--------|-------------------------------|-------------|
| `YYYY` | 4-digit year (Imperial Persian) | ۲۵۸۴        |
| `YY`   | 2-digit year (Imperial Persian) | ۸۴           |
| `MMMM` | Full month name (Persian)      | شهریور      |
| `MMM`  | Month name (English)           | Shahrivar   |
| `MM`   | Zero-padded month (01–12)      | ۰۶           |
| `M`    | Month number (1–12)            | ۶            |
| `DD`   | Zero-padded day (01–31)        | ۱۵           |
| `D`    | Day number (1–31)              | ۱۵           |
| `WWWW` | Full weekday name (Persian)    | سه‌شنبه     |
| `HH`  | Hour (00–23)                   | ۱۴           |
| `mm`   | Minute (00–59)                 | ۳۰           |
| `ss`   | Second (00–59)                 | ۰۵           |

---

## 🌍 Calendar Systems

This package supports three calendar systems:

### 1. Shamsi (Solar Hijri / Jalali)
The official calendar of Iran and Afghanistan. Used internally for calculations.
- Year 1 = 622 AD (Hijra)
- Example: ۱۴۰۴/۰۶/۱۵

### 2. Gregorian
The international standard calendar.
- Example: 2025-09-06

### 3. Imperial Persian ⭐
Iran's historical calendar based on the coronation of Cyrus the Great.
- Year 1 = 559 BC
- Conversion: Imperial year = Shamsi year + 1180
- **Displayed in all UI components**
- Example: ۲۵۸۴/۰۶/۱۵

### Calendar Conversion Examples

```dart
final date = ParsiDate(2584, 6, 15);

print('Imperial: ${date.imperialYear}');  // 2584
print('Gregorian: ${date.toDateTime()}'); // 2025-09-06
print(date.format('YYYY/MM/DD'));         // ۲۵۸۴/۰۶/۱۵
```

### Why Imperial Persian?

The Imperial Persian calendar honors Iran's ancient heritage:
- **Year 1** marks the coronation of Cyrus the Great (559 BC)
- **Year 2500** (1971 AD) was celebrated under Mohammad Reza Shah Pahlavi
- **Current year 2584** = Shamsi 1404 = Gregorian 2025

This package displays Imperial years across all UI components while keeping Shamsi calculations internally for compatibility.

---

## 🎨 Customization

### Custom Theme

Pickers automatically adapt to your app's theme:

```dart
MaterialApp(
  theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
    useMaterial3: true,
  ),
)
```

### Custom Labels

```dart
await showParsiDatePicker(
  context: context,
  initialDate: ParsiDate.now(),
  firstDate: ParsiDate(2560, 1, 1),
  lastDate: ParsiDate(2630, 12, 29),
  helpText: 'Please select a date',
  cancelText: 'Close',
  confirmText: 'Confirm',
);
```

---

## 📱 Platform Support

| Platform | Supported |
|----------|-----------|
| Android  | ✅ |
| iOS      | ✅ |
| Web      | ✅ |
| macOS    | ✅ |
| Windows  | ✅ |
| Linux    | ✅ |

---

## 💡 Practical Tips

### Working with Imperial Years

```dart
final birthDate = ParsiDate(2550, 3, 15);
print('Birth date: ${birthDate.imperialYear}/${birthDate.month}/${birthDate.day}');
// Output: Birth date: 2550/3/15
```

### Quick Conversion Table

| Shamsi Year | Imperial Year | Gregorian Year |
|-------------|---------------|----------------|
| ۱۳۰۰        | ۲۴۸۰          | 1921           |
| ۱۳۵۷        | ۲۵۳۷          | 1978           |
| ۱۴۰۰        | ۲۵۸۰          | 2021           |
| ۱۴۰۴        | ۲۵۸۴          | 2025           |
| ۱۴۵۰        | ۲۶۳۰          | 2071           |

---

## 🤝 Contributing

Contributions are welcome! Feel free to open a Pull Request.

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.


---

# نسخه فارسی

# Parsi DateTime Picker

[![pub package](https://img.shields.io/pub/v/parsi_datetime_picker.svg)](https://pub.dev/packages/parsi_datetime_picker)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

یک پکیج کامل برای انتخاب تاریخ و زمان فارسی (جلالی/شمسی) در Flutter با پشتیبانی از طراحی Material و Cupertino. این پکیج بر اساس [`imperial_persian_date`](https://pub.dev/packages/imperial_persian_date) ساخته شده و تبدیل دقیق تقویم را ارائه می‌دهد.

**✨ ویژگی ویژه:** تمام تاریخ‌ها در رابط کاربری به صورت **تقویم شاهنشاهی (Imperial Persian)** نمایش داده می‌شوند.

---

## ✨ ویژگی‌ها

- 📅 **انتخابگر تاریخ Material** — تقویم جلالی زیبا با امکان حرکت بین ماه‌ها و سال‌ها
- 📆 **انتخابگر بازه تاریخ** — انتخاب تاریخ شروع و پایان با نمایش بصری بازه
- ⏰ **انتخابگر زمان** — انتخابگر زمان با پشتیبانی RTL و برچسب‌های فارسی
- 🍎 **انتخابگر Cupertino** — انتخابگر به سبک iOS (تاریخ، زمان یا ترکیبی)
- ⌨️ **حالت ورودی متنی** — ورود مستقیم تاریخ به فرمت `YYYY/MM/DD`
- 🎨 **پشتیبانی از Material 3** — طراحی مدرن با رنگ‌بندی پویا
- 🔢 **اعداد فارسی** — تمام اعداد به صورت فارسی (۱۲۳۴۵۶۷۸۹۰)
- 👑 **تقویم شاهنشاهی** — نمایش سال‌ها به صورت شاهنشاهی در تمام رابط‌های کاربری
- 🎯 **نمایش تعطیلات** — مشخص کردن روزهای تعطیل با رنگ قرمز
- 🚫 **غیرفعال کردن روزهای خاص** — امکان غیرفعال کردن روزها یا روزهای هفته خاص
- 🌍 **پشتیبانی چند زبانه** — فارسی، دری، کردی، پشتو و انگلیسی
- 🎭 **پشتیبانی کامل RTL** — چیدمان کامل راست به چپ
- 🔄 **تبدیل دوطرفه** — تبدیل یکپارچه بین تقویم‌های میلادی، شمسی و شاهنشاهی

---

## 📦 نصب

این خطوط را به فایل `pubspec.yaml` پروژه خود اضافه کنید:

```yaml
dependencies:
  parsi_datetime_picker: ^0.0.1
  flutter_localizations:
    sdk: flutter
```

سپس دستور زیر را اجرا کنید:

```bash
flutter pub get
```

---

## 🚀 شروع سریع

### ۱. تنظیم محلی‌سازی

```dart
import 'package:flutter/material.dart';
import 'package:parsi_datetime_picker/parsi_datetime_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نمونه Parsi Date Picker',
      localizationsDelegates: parsiLocalizationsDelegates,
      supportedLocales: parsiSupportedLocales,
      locale: const Locale('fa', 'IR'),
      home: const HomePage(),
    );
  }
}
```

### ۲. استفاده از انتخابگر تاریخ

```dart
final ParsiDate? picked = await showParsiDatePicker(
  context: context,
  initialDate: ParsiDate.now(),
  firstDate: ParsiDate(2560, 1, 1),
  lastDate: ParsiDate(2630, 12, 29),
  helpText: 'انتخاب تاریخ',
);

if (picked != null) {
  print('سال شاهنشاهی: ${picked.imperialYear}');
  print('سال شمسی داخلی: ${picked.year}');
}
```

---

## 📖 نمونه‌های استفاده

### انتخابگر تاریخ Material

```dart
final ParsiDate? date = await showParsiDatePicker(
  context: context,
  initialDate: ParsiDate.now(),
  firstDate: ParsiDate(2560, 1, 1),
  lastDate: ParsiDate(2630, 12, 29),
  holidayDates: [
    ParsiDate(2584, 1, 1),
    ParsiDate(2584, 1, 2),
    ParsiDate(2584, 1, 3),
  ],
  selectableDayPredicate: (date) => date.weekDay != 7,
  helpText: 'انتخاب تاریخ تولد',
  cancelText: 'انصراف',
  confirmText: 'تایید',
);
```

### انتخابگر بازه تاریخ

```dart
final ParsiDateRange? range = await showParsiDateRangePicker(
  context: context,
  firstDate: ParsiDate(2560, 1, 1),
  lastDate: ParsiDate(2630, 12, 29),
  initialDateRange: ParsiDateRange(
    start: ParsiDate(2584, 6, 1),
    end: ParsiDate(2584, 6, 10),
  ),
  helpText: 'انتخاب بازه تاریخ',
);
```

### انتخابگر زمان

```dart
final TimeOfDay? time = await showParsiTimePicker(
  context: context,
  initialTime: TimeOfDay.now(),
  helpText: 'انتخاب ساعت',
);
```

### انتخابگر Cupertino

```dart
SizedBox(
  height: 200,
  child: ParsiCupertinoDatePicker(
    mode: ParsiCupertinoDatePickerMode.date,
    initialDateTime: ParsiDate.now(),
    minimumDate: ParsiDate(2560, 1, 1),
    maximumDate: ParsiDate(2630, 12, 29),
    onDateTimeChanged: (date) {
      setState(() => _selectedDate = date);
    },
  ),
)
```

---

## 🗓️ API کلاس ParsiDate

### سازنده‌ها

```dart
ParsiDate(2584, 6, 15)
ParsiDate.now()
ParsiDate.fromDateTime(DateTime(2025, 9, 6))
```

### ویژگی‌ها

```dart
date.year           // ۲۵۸۴
date.month          // ۶
date.day            // ۱۵
date.monthName      // 'شهریور'
date.monthNameEn    // 'Shahrivar'
date.weekDayName    // 'سه‌شنبه'
date.weekDay        // ۱-۷
date.isLeapYear     // true/false
date.monthLength    // ۲۹-۳۱
date.imperialYear   // ۲۵۸۴
```

### محاسبات تاریخ

```dart
date.addDays(5)
date.addMonths(2)
date.addYears(1)
date.copyWith(year: 2585, month: 7, day: 20)
```

### مقایسه تاریخ‌ها

```dart
date1.isBefore(date2)
date1.isAfter(date2)
date1.isSameDay(date2)
date1.difference(date2)
date1.compareTo(date2)
```

### قالب‌بندی

```dart
date.format('WWWW، DD MMMM YYYY')  // سه‌شنبه، ۱۵ شهریور ۲۵۸۴
date.format('YYYY/MM/DD HH:mm')    // ۲۵۸۴/۰۶/۱۵ ۱۴:۳۰
```

### توکن‌های قالب‌بندی

| توکن   | توضیحات                       | مثال       |
|--------|-------------------------------|------------|
| `YYYY` | سال ۴ رقمی (شاهنشاهی)        | ۲۵۸۴       |
| `MMMM` | نام کامل ماه (فارسی)          | شهریور     |
| `MMM`  | نام ماه (انگلیسی)             | Shahrivar  |
| `MM`   | ماه با صفر                    | ۰۶          |
| `DD`   | روز با صفر                    | ۱۵          |
| `WWWW` | نام روز هفته                  | سه‌شنبه    |
| `HH`   | ساعت                          | ۱۴          |
| `mm`   | دقیقه                         | ۳۰          |
| `ss`   | ثانیه                         | ۰۵          |

---

## 🌍 سیستم‌های تقویمی

### ۱. شمسی (هجری شمسی)
تقویم رسمی ایران — برای محاسبات داخلی استفاده می‌شود.

### ۲. میلادی (Gregorian)
تقویم استاندارد بین‌المللی.

### ۳. شاهنشاهی (Imperial Persian) ⭐
- سال ۱ = ۵۵۹ قبل از میلاد (تاجگذاری کوروش بزرگ)
- تبدیل: سال شاهنشاهی = سال شمسی + ۱۱۸۰
- **در تمام رابط‌های کاربری نمایش داده می‌شود**

### جدول تبدیل سریع

| سال شمسی | سال شاهنشاهی | سال میلادی |
|----------|---------------|------------|
| ۱۳۰۰     | ۲۴۸۰          | ۱۹۲۱       |
| ۱۳۵۷     | ۲۵۳۷          | ۱۹۷۸       |
| ۱۴۰۰     | ۲۵۸۰          | ۲۰۲۱       |
| ۱۴۰۴     | ۲۵۸۴          | ۲۰۲۵       |
| ۱۴۵۰     | ۲۶۳۰          | ۲۰۷۱       |

---

## 📱 پشتیبانی از پلتفرم‌ها

✅ Android &nbsp; ✅ iOS &nbsp; ✅ Web &nbsp; ✅ macOS &nbsp; ✅ Windows &nbsp; ✅ Linux

---

## 🤝 مشارکت

مشارکت‌ها خوش‌آمدید! لطفاً Pull Request ارسال کنید.

## 📄 مجوز

این پروژه تحت مجوز MIT منتشر شده — فایل [LICENSE](LICENSE) را ببینید.

