import 'package:flutter/material.dart';
import 'package:flutter_time/constant/time_event_constant.dart';
import 'package:flutter_time/value/strings.dart';
import 'package:flutter_time/value/styles.dart';

class TimeEventItem extends StatelessWidget {
  // 背景颜色
  final Color _bgColor;
  final TimeEventType _type;

  final String _title;
  final int _day;


  TimeEventItem(this._bgColor, this._type, this._title, this._day);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}

// 时间条目的查看详情标志
class ViewDetailLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.white,)
      ),
      child: Text(
        VIEW_DETAIL,
        style: viewDetailTextStyle,
      ),
    );
  }
}

// 剩余天数标志
class RemainingDayLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

// 已过天数标志
class PassDayLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
