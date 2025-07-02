import 'package:intl/intl.dart';

class NumberFormatterUtil {
  static final NumberFormat _formatter = NumberFormat("#,###");

  static String format(String value) {
    final cleaned = value.replaceAll(',', '');
    final number = int.tryParse(cleaned);
    if (number == null) return value;
    return _formatter.format(number);
  }

  static String unformat(String value) {
    return value.replaceAll(',', '');
  }
}
