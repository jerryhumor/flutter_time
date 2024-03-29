import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_time/util/text_utils.dart';

class HeroUtils {

  /// 文字控件执行Hero动画时，兼容文字变大变小的问题
  /// 原理是 使用ScaleTransition，控制文字的大小
  static Widget _textFlightShuttleBuilder(
      BuildContext flightContext,
      Animation<double> animation,
      HeroFlightDirection flightDirection,
      BuildContext fromHeroContext,
      BuildContext toHeroContext,) {

    /// 当前动画是否为反向动画
    final bool reverse = animation.status == AnimationStatus.completed
        || animation.status == AnimationStatus.reverse;

    /// 获取控件
    Text fromText = (fromHeroContext.widget as Hero).child;
    Text toText = (toHeroContext.widget as Hero).child;

    /// 如果是反向 交换两个控件
    if (reverse) {
      Text temp = toText;
      toText = fromText;
      fromText = temp;
    }

    final Size fromSize = TextUtils.measureText(
      text: fromText.data,
      style: fromText.style,
    );

    final Size toSize = TextUtils.measureText(
      text: toText.data,
      style: toText.style,
    );

    final double widthFactor = toSize.width / fromSize.width;
    final double heightFactor = toSize.height / fromSize.height;
    double factor;
    if (widthFactor < 1.0) {
      factor = max(widthFactor, heightFactor);
    } else {
      factor = min(widthFactor, heightFactor);
    }

    final scaleAnimation = animation.drive(Tween(begin: 1.0, end: factor,));

    /// 外部包一层Material是为了让字体不变化
    return Material(
      color: Colors.transparent,
      child: ScaleTransition(
        scale: scaleAnimation,
        alignment: Alignment.topLeft,
        child: fromText,
      ),
    );
  }

  /// 当我们使用Hero控件，并且子控件为Text的时候，很容易出现文字大小不一致的问题
  /// 使用这个函数包裹 可以解决这个问题
  static Widget wrapHeroText(Object tag, Text text) {
    if (tag == null) return text;
    Widget wrapped = Hero(
      tag: tag,
      child: text,
      flightShuttleBuilder: _textFlightShuttleBuilder,
    );
    return wrapped;
  }

  static Widget wrapHero(Object tag, Widget widget) {
    if (tag == null) return widget;
    Widget wrapped = Hero(
      tag: tag,
      child: widget,
    );
    return wrapped;
  }

}

Widget wrapHero(Object tag, Widget widget) {
  return HeroUtils.wrapHero(tag, widget);
}

Widget wrapHeroText(Object tag, Text text) {
  return HeroUtils.wrapHeroText(tag, text);
}