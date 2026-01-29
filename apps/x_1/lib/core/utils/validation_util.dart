class ValidationUtil {
  static bool isValidDate(String date) {
    // Format: yyyy-MM-dd
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!regex.hasMatch(date)) return false;

    try {
      final parts = date.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      if (year < 1900 || year > 2100) return false;
      if (month < 1 || month > 12) return false;

      final daysInMonth = DateTime(year, month + 1, 0).day;
      if (day < 1 || day > daysInMonth) return false;

      return true;
    } catch (e) {
      return false;
    }
  }

  static bool isValidTime(String time) {
    // Format: HH:mm
    final regex = RegExp(r'^\d{2}:\d{2}$');
    if (!regex.hasMatch(time)) return false;

    try {
      final parts = time.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      if (hour < 0 || hour > 23) return false;
      if (minute < 0 || minute > 59) return false;

      return true;
    } catch (e) {
      return false;
    }
  }
}
