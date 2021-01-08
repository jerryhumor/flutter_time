class TimeUtils {

  static String millis2String(int timeMillis, String format) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timeMillis);
    String timeStr = format;
    if (format.contains('yyyy')) {
      timeStr.replaceAll('yyyy', '${dateTime.year}');
    }
    if (format.contains('MM')) {
      timeStr.replaceAll('MM', '${dateTime.month}');
    }
    if (format.contains('dd')) {
      timeStr.replaceAll('dd', '${dateTime.day}');
    }
    if (format.contains('HH')) {
      timeStr.replaceAll('HH', '${dateTime.hour}');
    }
    if (format.contains('mm')) {
      timeStr.replaceAll('mm', '${dateTime.minute}');
    }
    if (format.contains('ss')) {
      timeStr.replaceAll('ss', '${dateTime.second}');
    }
    return null;
  }

}