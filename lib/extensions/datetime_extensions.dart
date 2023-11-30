import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  String toNicerTime() {
    final now = DateTime.now();
    if (year == now.year && month == now.month && day == now.day) {
      return DateFormat(DateFormat.HOUR24_MINUTE).format(this);
    }

    return DateFormat.yMd().format(this);
  }
}
