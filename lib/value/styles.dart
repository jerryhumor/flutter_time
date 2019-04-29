import 'package:flutter/material.dart';
import 'package:flutter_time/value/colors.dart';

// 查看详情文字样式
const TextStyle viewDetailTextStyle = TextStyle(
  fontSize: 8.0,
  color: Colors.white
);

// 标题文字样式
const TextStyle timeEventItemTitleTextStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.white
);

// 剩余天数 已过天数的文字样式
const TextStyle timeEventItemDayTextStyle = TextStyle(
  fontSize: 28.0,
  fontWeight: FontWeight.bold,
  color: Colors.white
);

const TextStyle timeEventItemDayLabelTextStyle = TextStyle(
  fontSize: 10.0,
  color: colorWhiteTransparent
);

const TextStyle timeEventTypeLabelSmallTextStyle = TextStyle(
  fontSize: 8.0,
  color: Colors.white
);

const TextStyle timeEventTypeLabelLargeTextStyle = TextStyle(
    fontSize: 10.0,
    color: Colors.white
);

const TextStyle timeEventTargetDayTextStyle = TextStyle(
  fontSize: 14.0,
  color: colorWhiteTransparent
);

// 创建事件时 事件名称样式
const TextStyle timeEventCreateEventNameTextStyle = TextStyle(
  fontSize: 14.0,
  color: colorGrey
);

// 创建事件时 事件名称提示样式
const TextStyle timeEventCreateEventNameHintTextStyle = TextStyle(
  fontSize: 14.0,
  color: colorBlack
);