import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time/model/base/models.dart';
import 'package:flutter_time/ui/common_ui.dart';
import 'package:flutter_time/value/strings.dart';
import 'package:flutter_time/value/styles.dart';

class CountDownDetailPage extends StatelessWidget {
  final String bgHeroTag;
  final String labelHeroTag;
  final TimeEventModel model;

  CountDownDetailPage({
    this.model,
    this.bgHeroTag,
    this.labelHeroTag,
  });

  @override
  Widget build(BuildContext context) {

    final Color textColor = Theme.of(context).colorScheme.secondary;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Material(
          child: Stack(
        children: <Widget>[
          _buildBackground(),
          _buildContent(textColor),
        ],
      )),
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
    if (bgHeroTag != null && bgHeroTag.isNotEmpty) {
      bg = Hero(
        tag: bgHeroTag,
        child: bg,
      );
    }
    return bg;
  }

  /// 创建倒计日内容
  Widget _buildContent(Color textColor) {
    return Column(
      children: <Widget>[
        _buildTitleBar(textColor),
        _buildTitle(textColor),
        VerticalSeparator(24.0),
        DayText(day: 1, textColor: textColor, isLarge: true,),
        RemainingDayLabel(textColor: textColor,),
        VerticalSeparator(16.0),
        TimeEventPassProgress(totalDay: 9, passDay: 1,),
      ],
    );
  }

  /// 创建顶部标题栏
  Widget _buildTitleBar(Color textColor) {
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
              onPressed: () {},
            ),

            /// 事件的类型标签
            TimeEventTypeLabel(
              label: COUNT_DOWN_DAY,
              isLarge: true,
              textColor: textColor,
              heroTag: labelHeroTag,
            ),

            /// 编辑按钮
            IconButton(
              icon: Icon(
                Icons.low_priority,
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
    final textStyle = timeEventDetailTitleTextStyle.apply(color: textColor);

    return Text(model.title, style: textStyle,);
  }

  /// 创建备注区域
  Widget _buildRemark() {
    return null;
  }

  /// 创建底部的分享按钮
  Widget _buildShareButton() {
    return null;
  }
}
