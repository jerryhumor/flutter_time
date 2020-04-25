import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time/model/base/models.dart';
import 'package:flutter_time/ui/common_ui.dart';

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Material(
          child: Stack(
        children: <Widget>[
          _buildBackground(),
          _buildContent(),
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
  Widget _buildContent() {
    return Column(
      children: <Widget>[
        _buildTitleBar(),
      ],
    );
  }

  /// 创建顶部标题栏
  Widget _buildTitleBar() {
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
            /// todo 颜色提出
            IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.white,
              ),
              onPressed: () {},
            ),

            /// 事件的类型标签
            TimeEventTypeLabel.countDownDayLarge(
              heroTag: labelHeroTag,
            ),

            /// 编辑按钮
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
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
