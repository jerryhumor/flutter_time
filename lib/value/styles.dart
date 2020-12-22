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
);

/// 剩余天数 已过天数的文字样式 小
const TextStyle timeEventItemSmallDayTextStyle = TextStyle(
  fontSize: 28.0,
  fontWeight: FontWeight.bold,
  color: Colors.white
);

/// 剩余天数 已过天数的文字样式 大
const TextStyle timeEventItemLargeDayTextStyle = TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.bold,
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

// appbar 标题文字样式
const TextStyle appBarTitleTextStyle = TextStyle(
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: colorAppBarTitle
);

/// 事件详情页面 标题文字的样式
const TextStyle timeEventDetailTitleTextStyle = TextStyle(
  fontSize: 16.0,
  fontWeight: FontWeight.bold,
);