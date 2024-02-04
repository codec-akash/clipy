import 'package:intl/intl.dart';

class DateTimeUtil {
  static String dateFormat(DateTime val) {
    return DateFormat('MMM dd, yyyy').format(val);
  }

  static DateTime dateFormatToDateTime(String val) {
    DateFormat format = DateFormat('MMM dd, yyyy');
    return format.parse(val);
  }

  static DateTime millisecondsFromDateMonthYear(String val) {
    // String dateStr = '10092023'; // DDMMyyyy format

    int day = int.parse(val.substring(0, 2));
    int month = int.parse(val.substring(2, 4));
    int year = int.parse(val.substring(4, 8));

    DateTime dateTime = DateTime(year, month, day);
    return dateTime;
  }

  static String monthDay(DateTime val) {
    return DateFormat('MMM dd').format(val);
  }

  static String timeFormat(DateTime val) {
    return DateFormat('hh:mm a').format(val);
  }

  static String monthDayYearTime(DateTime val) {
    String firstHalf = DateFormat('MMM d, yyyy').format(val.toLocal());
    String secondHalf = DateFormat('h:mm a').format(val.toLocal());
    return "$firstHalf, $secondHalf";
  }

  static String dayDateAtMonthFormat(DateTime val) {
    String firstHalf = DateFormat('E, d MMM').format(val);
    String secondHalf = DateFormat('h:mm a').format(val);
    return "$firstHalf at $secondHalf";
  }

  static String dayDateMonthFormat(DateTime val) {
    String firstHalf = DateFormat('E, d MMM').format(val);
    String secondHalf = DateFormat('h:mm a').format(val);
    return "$firstHalf at $secondHalf";
  }

  static DateTime dateFormatYearMonthDate(String val) {
    return DateFormat('yyyy/MM/dd').parse(val);
  }

  static String dateFormatYearMonthDateWithoutSlash(String val) {
    // String dateStr = '10092023'; // DDMMyyyy format
    int day = int.parse(val.substring(0, 2));
    int month = int.parse(val.substring(2, 4));
    int year = int.parse(val.substring(4, 8));
    return '$year/$month/$day';
  }
}
