const FORMAT_YYYY_MM_DD = 'yyyy-MM-dd';
const FORMAT_YYYY_MM_DD_HH_MM_SS = 'yyyy-MM-dd HH:mm:ss';

class TimeUtils {

  static String millis2String(int timeMillis, String format) {
    if (timeMillis == null) return '';
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timeMillis);
    String timeStr = format;
    timeStr = timeStr.replaceAll('yyyy', '${dateTime.year}');
    timeStr = timeStr.replaceAll('MM', '${dateTime.month}');
    timeStr = timeStr.replaceAll('dd', '${dateTime.day}');
    timeStr = timeStr.replaceAll('HH', '${dateTime.hour}');
    timeStr = timeStr.replaceAll('mm', '${dateTime.minute}');
    timeStr = timeStr.replaceAll('ss', '${dateTime.second}');
    return timeStr;
  }

  static DateTime getStartTime(DateTime date) {
    return DateTime(date.year, date.month, date.day,);
  }

  static DateTime getEndTime(DateTime date) {
    return DateTime(date.year, date.month, date.day,);
  }

  /// 获取今天的开始时间
  static DateTime getTodayStartTime() {
    return getStartTime(DateTime.now());
  }

  /// 获取今天结束时间
  static DateTime getTodayEndTime() {
    return getEndTime(DateTime.now());
  }

}