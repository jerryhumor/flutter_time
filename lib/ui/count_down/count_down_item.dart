import 'package:flutter/material.dart';
import 'package:flutter_time/constant/time_event_constant.dart';
import 'package:flutter_time/model/base/models.dart';
import 'package:flutter_time/ui/common_ui.dart';
import 'package:flutter_time/util/hero_utils.dart';
import 'package:flutter_time/value/strings.dart';

// 倒计日事件的条目
class TimeEventItem extends StatelessWidget with ITimeEventItem {

  final int index;
  final TimeEventModel model;
  final EdgeInsetsGeometry margin;

  TimeEventItem({this.index, this.model, this.margin,});

  @override
  Widget build(BuildContext context) {

    final Color textColor = Theme.of(context).colorScheme.secondary;

    /// 136
    return Container(
      width: double.infinity,
      height: 140,
      margin: margin,
      child: Stack(
        children: <Widget>[
          _buildBackground(model.color, index),
          _buildContent(model, index, textColor),
        ],
      ),
    );
  }

  /// 创建背景
  Widget _buildBackground(int color, Object tag) {
    Widget background = Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Color(color),
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
    background = wrapHero('bg-$tag', background);
    return background;
  }

  /// 创建内容
  Widget _buildContent(TimeEventModel model, Object tag, Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        children: <Widget>[
          /// 包含标题 类型信息的row
          TitleRow(title: model.title, type: model.type, heroTag: tag, textColor: textColor,),
          /// 间隔
          Spacer(),
          /// 包含日期信息的row
          model.type == TimeEventType.countDownDay.index
              ? CountDownDetail(startTime: model.startTime, endTime: model.endTime, heroTag: tag,)
              : CumulativeDetail(startTime: model.startTime, heroTag: tag,),
        ],
      ),
    );
  }

  @override
  TimeEventModel getModel() {
    return model;
  }
}

class CountDownItemClipper extends CustomClipper<Rect> {

  // 偏移量 负数为剪切左边 正数为剪切右边
  Animation<Offset> slideAnimation;

  CountDownItemClipper(this.slideAnimation);

  @override
  Rect getClip(Size size) {
    final double offset = slideAnimation.value.dx * size.width;
    if (offset == 0) {
      return Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    } else if (offset < 0) {
      return Rect.fromLTRB(0.0 - offset, 0.0, size.width, size.height);
    } else {
      return Rect.fromLTRB(0.0, 0.0, size.width - offset, size.height);
    }

  }

  @override
  bool shouldReclip(CountDownItemClipper oldClipper) {
    return oldClipper.slideAnimation.value != slideAnimation.value;
  }

}