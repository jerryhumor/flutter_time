import 'package:flutter/material.dart';
import 'package:flutter_time/constant/time_event_constant.dart';
import 'package:flutter_time/value/colors.dart';
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
      child: Column(
        children: <Widget>[
          // 包含标题 类型信息的row
          TitleRow(_title, _type),
          // 包含日期信息的row
          TimeRow(_type, null, null),
        ],
      ),
    );
  }
}

class TitleRow extends StatelessWidget {

  final String _title;
  final TimeEventType _type;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 标题和类型
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TimeEventTitle(_title),
            _type == TimeEventType.countDownDay ?
              TimeEventTypeLabel.countDownDaySmall()
              : TimeEventTypeLabel.cumulativeDaySmall(),
          ],
        ),
        // 查看详情
        ViewDetailLabel()
      ],
    );
  }

  TitleRow(this._title, this._type);
}

class TimeRow extends StatelessWidget {
  // 类型 倒计日 累计日
  final TimeEventType _type;
  // 开始时间和结束时间
  // 如果是累计日 则_endTime 为空
  final int _startTime, _endTime;

  TimeRow(this._type, this._startTime, this._endTime);

  @override
  Widget build(BuildContext context) {

    // todo 使用utils类计算好信息

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        // 左边的进度和目标日
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            // 累计日的倒计时文字
            _type == TimeEventType.countDownDay ? Text('已过1/9') : Container(),
            // 累计日的倒计时进度条
            _type == TimeEventType.countDownDay ? TimeEventProgress(9, 1) : Container(),
            // 目标日
            TargetDay(null),
          ],
        ),
        // 剩余天数 或者 已过天数
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            // 标志 剩余天数 已过天数
            _type == TimeEventType.countDownDay ? RemainingDayLabel() : PassDayLabel(),
            // 日期文字
            DayText(1),
          ],
        ),
      ],
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
    return Text(
      REMAINING_DAY,
      style: timeEventItemDayLabelTextStyle,
    );
  }
}

// 已过天数标志
class PassDayLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      PASS_DAY,
      style: timeEventItemDayLabelTextStyle,
    );
  }
}

// 时间事件类型label
class TimeEventTypeLabel extends StatelessWidget {

  final String label;
  final TextStyle labelTextStyle;
  
  TimeEventTypeLabel(this.label, this.labelTextStyle);
  
  TimeEventTypeLabel.countDownDaySmall() : this.label = COUNT_DOWN_DAY, this.labelTextStyle = timeEventTypeLabelSmallTextStyle;
  TimeEventTypeLabel.countDownDayLarge() : this.label = COUNT_DOWN_DAY, this.labelTextStyle = timeEventTypeLabelLargeTextStyle;

  TimeEventTypeLabel.cumulativeDaySmall() : this.label = CUMULATIVE_DAY, this.labelTextStyle = timeEventTypeLabelSmallTextStyle;
  TimeEventTypeLabel.cumulativeDayLarge() : this.label = CUMULATIVE_DAY, this.labelTextStyle = timeEventTypeLabelLargeTextStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colorWhiteTransparent,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        label,
        style: labelTextStyle,
      ),
    );
  }
}

// 目标日已过进度条
class TimeEventProgress extends StatelessWidget {

  final int _totalDay;
  final int _passDay;

  TimeEventProgress(this._totalDay, this._passDay);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5.0,
      width: 200.0,
      color: Colors.red,
    );
  }

}

// 目标日
class TargetDay extends StatelessWidget {

  final String _targetDay;

  TargetDay(this._targetDay);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$TARGET_DAY:$_targetDay',
      style: timeEventTargetDayTextStyle,
    );
  }
}

// 起始日
class StartDay extends StatelessWidget {

  final String _startDay;

  StartDay(this._startDay);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$START_DAY:$_startDay',
      style: timeEventTargetDayTextStyle,
    );
  }
}

// 剩余或已过天数日期文字
class DayText extends StatelessWidget {

  final int _day;

  DayText(this._day);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_day',
      style: timeEventItemDayTextStyle,
    );
  }
}

// 标题
class TimeEventTitle extends StatelessWidget {

  final String _title;

  TimeEventTitle(this._title);

  @override
  Widget build(BuildContext context) {
    return Text(
      _title,
      style: timeEventItemTitleTextStyle,
    );
  }
}
