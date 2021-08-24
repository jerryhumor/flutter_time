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
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }

  /// 获取今天的开始时间
  static DateTime getTodayStartTime() {
    return getStartTime(DateTime.now());
  }

  /// 获取今天结束时间
  static DateTime getTodayEndTime() {
    return getEndTime(DateTime.now());
  }

  /// 是否为闰年
  static bool isLeap(int year) {
    return ((year % 100 == 0) && (year % 400 == 0))
        || ((year % 4 == 0) && (year % 100 != 0));
  }

  /// 获取这个月的天数
  static int getMonthDayCount(int year, int month) {
    switch (month) {
      case 1:
      case 3:
      case 5:
      case 7:
      case 8:
      case 10:
      case 12: return 31;
      case 4:
      case 6:
      case 9:
      case 11: return 30;
      default:
        if (isLeap(year)) {
          return 29;
        } else {
          return 28;
        }
    }
  }

  static DateTime getPreviousMonth(int year, int month) {
    if (month == 1) {
      return DateTime(year - 1, 12);
    } else {
      return DateTime(year, month - 1);
    }
  }

  static DateTime getNextMonth(int year, int month) {
    if (month == 12) {
      return DateTime(year + 1, 1);
    } else {
      return DateTime(year, month + 1);
    }
  }

}