import 'package:flutter_test/flutter_test.dart';
import 'package:parsi_datetime_picker/parsi_datetime_picker.dart';

void main() {
  test('toPersianDigits converts English digits to Persian digits', () {
    expect(toPersianDigits('1234567890'), '۱۲۳۴۵۶۷۸۹۰');
    expect(toPersianDigits('Date: 2023'), 'Date: ۲۰۲۳');
  });
}
