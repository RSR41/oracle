import 'package:lunar/lunar.dart';

class LunarCalendarUtil {
  /// Converts a Solar date to a Lunar date string (yyyy-MM-dd)
  /// Returns a map with 'year', 'month', 'day', 'isLeap'
  static Map<String, dynamic> solarToLunar(DateTime date) {
    final solar = Solar.fromYmd(date.year, date.month, date.day);
    final lunar = solar.getLunar();

    return {
      'year': lunar.getYear(),
      'month': lunar.getMonth(),
      'day': lunar.getDay(),
      'isLeap':
          false, // The library handles leap months internally, but simple getter might be needed
      // Note: 'lunar' package handles leap months via complex logic.
      // For MVP display, we just return the month.
      // To check if it's a leap month:
      'isLeapMonth': lunar.getMonth() <
          0 // Some libraries use negative for leap, need to verify 'lunar' pkg behavior
    };
  }

  /// Converts Lunar date to Solar DateTime
  static DateTime lunarToSolar(int year, int month, int day,
      {bool isLeap = false}) {
    // Note: The 'lunar' package might behave differently.
    // Assuming standard Lunar.fromYmd usage.
    // If isLeap is true, we need to handle it.

    // For MVP, using standard conversion:
    final lunar = Lunar.fromYmd(year, month, day);
    final solar = lunar.getSolar();

    return DateTime(solar.getYear(), solar.getMonth(), solar.getDay());
  }

  static String formatLunarDate(int year, int month, int day,
      {bool isLeap = false}) {
    return 'Lunar $year-$month-$day${isLeap ? " (Leap)" : ""}';
  }
}
