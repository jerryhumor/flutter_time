import 'package:flutter/cupertino.dart';

class TimeUtils {

  static String millis2String(int timeMillis, String format) {
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