import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time/constant/time_constants.dart';
import 'package:flutter_time/constant/time_event_constant.dart';
import 'package:flutter_time/model/base/models.dart';
import 'package:flutter_time/themes/time_theme_data.dart';
import 'package:flutter_time/ui/common_ui.dart';
import 'package:flutter_time/util/hero_utils.dart';
import 'package:flutter_time/util/time_utils.dart';
import 'package:flutter_time/value/colors.dart';
import 'package:flutter_time/value/strings.dart';
import 'package:flutter_time/value/styles.dart';

class CountDownDetailPage extends StatelessWidget {
  final Object heroTag;
  final TimeEventModel model;

  CountDownDetailPage({
    this.model,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {

    final Color textColor = Theme.of(context).colorScheme.secondary;

    return Material(
      child: Stack(
        children: <Widget>[
          _buildBackground(),
          _buildContent(context, textColor),
          _buildShareButton(textColor),
        ],
      ),
    );
  }

  /// 创建背景
  /// 一个纯色的背景
  Widget _buildBackground() {
    Widget bg = Container(
      color: Color(model.color),
      width: double.infinity,
      height: double.infinity,
    );
    bg = HeroUtils.wrapHero('bg-$heroTag', bg);
    return bg;
  }

  /// 创建倒计日内容
  Widget _buildContent(BuildContext context, Color textColor) {
    return Column(
      children: <Widget>[
        _buildTitleBar(context, textColor),
        Flexible(
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: [
              SizedBox(height: 12.0,),
              Center(child: _buildTitle(textColor), heightFactor: 1.0,),
              VerticalSeparator(24.0),
              Center(child: _buildDayText(textColor), heightFactor: 1.0,),
              Center(child: _buildDayTextLabel(textColor), heightFactor: 1.0,),
              VerticalSeparator(16.0),
              _buildDayProgress(textColor),
              SizedBox(height: 24.0,),
              _buildDayDetail(textColor),
              _buildRemark(model.remark, textColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDayText(Color textColor) {
    if (model.type == TimeEventType.countDownDay.index) {
      final int totalDay = (model.endTime - model.startTime + 1) ~/ DAY_TIME_MILLIS;
      final int passDay = (TimeUtils.getTodayStartTime().millisecondsSinceEpoch - model.startTime) ~/ DAY_TIME_MILLIS;
      final int remainDay = max(totalDay - passDay, 0);
      return DayText(
        day: remainDay,
        textColor: textColor,
        isLarge: true,
        heroTag: heroTag,
      );
    } else {
      int day = (DateTime.now().millisecondsSinceEpoch - model.startTime) ~/ DAY_TIME_MILLIS;
      return DayText(
        day: day,
        textColor: textColor,
        isLarge: true,
        heroTag: heroTag,
      );
    }
  }

  Widget _buildDayTextLabel(Color textColor) {
    if (model.type == TimeEventType.countDownDay.index) {
      return RemainingDayLabel(textColor: textColor,);
    } else {
      return PassDayLabel(textColor: textColor,);
    }
  }

  Widget _buildDayProgress(Color textColor) {
    if (model.type == TimeEventType.countDownDay.index) {
      final int totalDay = (model.endTime - model.startTime + 1) ~/ DAY_TIME_MILLIS;
      final int passDay = (TimeUtils.getTodayStartTime().millisecondsSinceEpoch - model.startTime) ~/ DAY_TIME_MILLIS;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TimeEventPassProgress(width: 120.0, height: 8.0, totalDay: totalDay, passDay: passDay,),
          TimeEventPassText(totalDay: totalDay, passDay: passDay, textColor: textColor,),
        ],
      );
    } else {
      return Center(
        heightFactor: 1.0,
        child: Text(
          '起始日:${TimeUtils.millis2String(model.startTime, 'yyyy年MM月dd日')}',
          style: TimeTheme.editItemContentStyle.apply(color: textColor),
        ),
      );
    }
  }

  Widget _buildDayDetail(Color textColor) {
    if (model.type == TimeEventType.cumulativeDay.index) return Container();
    TextStyle style = TimeTheme.smallTextStyle.apply(color: textColor.withOpacity(0.5));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '起始日:${TimeUtils.millis2String(model.startTime, FORMAT_YYYY_MM_DD)}',
            style: style,
          ),
          Text(
            '目标日:${TimeUtils.millis2String(model.endTime, FORMAT_YYYY_MM_DD)}',
            style: style,
          ),
        ],
      ),
    );
  }

  /// 创建顶部标题栏
  Widget _buildTitleBar(BuildContext context, Color textColor) {
    return SafeArea(
      child: Container(
        height: 56,
        width: double.infinity,

        /// todo 提出常量
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            /// 左边的取消按钮
            IconButton(
              icon: Icon(
                Icons.clear,
                color: textColor,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),

            /// 事件的类型标签
            TimeEventTypeLabel.normal(
              label: (model.type == TimeEventType.countDownDay.index)
                  ? COUNT_DOWN_DAY
                  : CUMULATIVE_DAY,
              heroTag: heroTag,
            ),

            /// 编辑按钮
            IconButton(
              icon: Icon(
                Icons.panorama_wide_angle,
                color: textColor,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  /// 创建标题
  Widget _buildTitle(Color textColor) {
    final textStyle = TimeTheme.titleTextStyle.apply(color: textColor);

    return Text(model.title, style: textStyle,);
  }

  /// 创建备注区域
  Widget _buildRemark(String remark, Color textColor) {

    final TextStyle labelStyle = TimeTheme.smallTextStyle.apply(color: textColor.withOpacity(0.5));
    final TextStyle textStyle = TimeTheme.smallTextStyle.apply(
      color: (remark == null || remark.isEmpty) ? textColor.withOpacity(0.5) : textColor,
    );


    return Container(
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: textColor.withOpacity(0.1),),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('备注:', style: labelStyle,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text((remark == null || remark.isEmpty) ? '无' : remark, style: textStyle,),
          ),
        ],
      ),
    );
  }

  /// 创建底部的分享按钮
  Widget _buildShareButton(Color textColor) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
        ),
        child: Align(
          alignment: Alignment.bottomRight,
          child: SizedBox(
            height: 42.4,
            width: 42.4,
            child: Center(
              child: Icon(Icons.scatter_plot, color: textColor,),
            ),
          ),
        ),
      ),
    );
  }
}
