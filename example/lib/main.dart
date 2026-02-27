import 'package:flutter/material.dart';
import 'package:parsi_datetime_picker/parsi_datetime_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parsi Date Picker Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      // Required: add Persian localization delegates
      localizationsDelegates: parsiLocalizationsDelegates,
      supportedLocales: parsiSupportedLocales,
      locale: const Locale('fa', 'IR'),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  ParsiDate? _selectedDate;
  ParsiDateRange? _selectedRange;
  TimeOfDay? _selectedTime;
  ParsiDate _cupertinoDate = ParsiDate.now();
  String _formatImperialNumeric(ParsiDate date) {
    return '${date.imperialYear}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  String _formatImperialShort(ParsiDate date) {
    return '${date.day.toString().padLeft(2, '0')} ${date.monthName} ${date.imperialYear}';
  }

  String _formatImperialLong(ParsiDate date) {
    return '${date.weekDayName}، ${date.day.toString().padLeft(2, '0')} ${date.monthName} ${date.imperialYear}';
  }

  String _formatTimeWithPeriod(TimeOfDay time) {
    final period = time.hour < 12 ? 'صبح' : 'بعدازظهر';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    return '${hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')} $period';
  }

  Future<void> _pickDate() async {
    final result = await showParsiDatePicker(
      context: context,
      initialDate: ParsiDate.now(), // Always start with today's date
      firstDate: ParsiDate(1380, 1, 1),
      lastDate: ParsiDate(1450, 12, 29),
      helpText: 'انتخاب تاریخ تولد',
      // Mark Nowruz as holiday each year
      holidayDates: [
        ParsiDate(ParsiDate.now().year, 1, 1),
        ParsiDate(ParsiDate.now().year, 1, 2),
        ParsiDate(ParsiDate.now().year, 1, 3),
      ],
    );
    if (result != null) setState(() => _selectedDate = result);
  }

  Future<void> _pickDateRange() async {
    final result = await showParsiDateRangePicker(
      context: context,
      firstDate: ParsiDate(1380, 1, 1),
      lastDate: ParsiDate(1450, 12, 29),
      // Don't pass initialDateRange so it always starts fresh
    );
    if (result != null) setState(() => _selectedRange = result);
  }

  Future<void> _pickTime() async {
    final result = await showParsiTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), // Always start with current time
    );
    if (result != null) setState(() => _selectedTime = result);
  }

  Future<void> _pickDateInput() async {
    final result = await showParsiDatePicker(
      context: context,
      initialDate: ParsiDate.now(), // Always start with today's date
      firstDate: ParsiDate(1380, 1, 1),
      lastDate: ParsiDate(1450, 12, 29),
      initialEntryMode: ParsiDatePickerEntryMode.input,
    );
    if (result != null) setState(() => _selectedDate = result);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('نمایش تقویم شاهنشاهی'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Date Picker
              _SectionCard(
                title: 'انتخاب تاریخ (Material)',
                icon: Icons.calendar_today,
                result: _selectedDate != null
                    ? _formatImperialLong(_selectedDate!)
                    : 'تاریخی انتخاب نشده',
                onTap: _pickDate,
                buttonText: 'انتخاب تاریخ',
              ),
              const SizedBox(height: 12),

              // Date Range Picker
              _SectionCard(
                title: 'انتخاب بازه تاریخ',
                icon: Icons.date_range,
                result: _selectedRange != null
                    ? '${_formatImperialShort(_selectedRange!.start)} تا ${_formatImperialShort(_selectedRange!.end)}'
                    : 'بازه‌ای انتخاب نشده',
                onTap: _pickDateRange,
                buttonText: 'انتخاب بازه',
              ),
              const SizedBox(height: 12),

              // Time Picker
              _SectionCard(
                title: 'انتخاب ساعت',
                icon: Icons.access_time,
                result: _selectedTime != null
                    ? _formatTimeWithPeriod(_selectedTime!)
                    : 'ساعتی انتخاب نشده',
                onTap: _pickTime,
                buttonText: 'انتخاب ساعت',
              ),
              const SizedBox(height: 12),

              // Input Mode
              _SectionCard(
                title: 'ورودی تاریخ (حالت متنی)',
                icon: Icons.edit_calendar,
                result: _selectedDate != null
                    ? _formatImperialNumeric(_selectedDate!)
                    : 'تاریخی وارد نشده',
                onTap: _pickDateInput,
                buttonText: 'وارد کردن تاریخ',
              ),
              const SizedBox(height: 20),

              // Cupertino Picker
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.phone_iphone,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'انتخاب تاریخ (Cupertino)',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'تاریخ انتخابی: ${_formatImperialShort(_cupertinoDate)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 160,
                        child: ParsiCupertinoDatePicker(
                          initialDateTime: _cupertinoDate,
                          mode: ParsiCupertinoDatePickerMode.date,
                          onDateTimeChanged: (date) =>
                              setState(() => _cupertinoDate = date),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Imperial Persian info
              Card(
                color: Theme.of(context).colorScheme.secondaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'تقویم شاهنشاهی (Imperial Persian)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondaryContainer,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (_selectedDate != null) ...[
                        Text(
                          'شاهنشاهی: ${_formatImperialNumeric(_selectedDate!)}',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSecondaryContainer,
                          ),
                        ),
                        Text(
                          'میلادی: ${_selectedDate!.toDateTime().year}/${_selectedDate!.toDateTime().month}/${_selectedDate!.toDateTime().day}',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ] else
                        Text(
                          'یک تاریخ انتخاب کنید تا معادل آن نمایش داده شود',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer
                                .withValues(alpha: 0.7),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.icon,
    required this.result,
    required this.onTap,
    required this.buttonText,
  });

  final String title;
  final IconData icon;
  final String result;
  final VoidCallback onTap;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              result,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(
                onPressed: onTap,
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
