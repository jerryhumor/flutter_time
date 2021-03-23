import 'package:flutter/cupertino.dart';

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

}