import 'package:flutter/material.dart';

class DatePickerTheme extends InheritedWidget {

  final DatePickerThemeData theme;

  DatePickerTheme({
    Key key,
    this.theme = const DatePickerThemeData(),
    Widget child,
  }) : super(
          key: key,
          child: child,
        );
  
  static DatePickerThemeData of(BuildContext context) {
    final DatePickerTheme theme = context.dependOnInheritedWidgetOfExactType<DatePickerTheme>();
    return theme.theme;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

class DatePickerThemeData {

  /// 背景颜色
  final Color backgroundColor;
  /// 主要的按钮背景颜色
  final Color primaryBackgroundColor;
  /// 次要的按钮背景颜色
  final Color secondaryBackgroundColor;
  /// 日期选中后的背景颜色
  final Color selectedDayBackgroundColor;

  /// 标题文字样式
  final TextStyle titleStyle;
  /// 选中的日志展示的文字样式
  final TextStyle displayDateStyle;
  /// 年月标题展示的文字样式
  final TextStyle tagTitleStyle;
  /// 日期文字样式
  final TextStyle dayStyle;
  final TextStyle unableDayStyle;
  /// 按钮文字样式
  final TextStyle primaryButtonStyle;
  final TextStyle secondaryButtonStyle;

  const DatePickerThemeData({
    this.backgroundColor = const Color.fromARGB(255, 41, 44, 54),
    this.primaryBackgroundColor = const Color.fromARGB(64, 255, 255, 255),
    this.secondaryBackgroundColor = const Color.fromARGB(20, 255, 255, 255),
    this.selectedDayBackgroundColor = const Color.fromARGB(255, 107, 156, 239),
    this.titleStyle = const TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    this.displayDateStyle = const TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    this.tagTitleStyle = const TextStyle(
      fontSize: 16,
      color: Color.fromARGB(77, 255, 255, 255),
    ),
    this.dayStyle = const TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    this.unableDayStyle = const TextStyle(
      fontSize: 16,
      color: Color.fromARGB(20, 255, 255, 255),
    ),
    this.primaryButtonStyle = const TextStyle(
      fontSize: 16,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    this.secondaryButtonStyle = const TextStyle(
      fontSize: 16,
      color: Color.fromARGB(77, 255, 255, 255),
      fontWeight: FontWeight.bold,
    ),
  });
}
