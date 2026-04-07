import 'package:intl/intl.dart';

// Форматтер даты и времени
class DateFormats {
  static final DateFormat ruDateFormat = DateFormat('dd.MM.yyyy');
  static final DateFormat ruDateTimeFormat = DateFormat('dd.MM.yyyy HH:mm');
  static final DateFormat ruTimeFormat = DateFormat('HH:mm');

  static String formatDate(DateTime date) => ruDateFormat.format(date);
  static String formatDateTime(DateTime date) => ruDateTimeFormat.format(date);
  static String formatTime(DateTime date) => ruTimeFormat.format(date);
}
