import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_time/util/text_utils.dart';

class HeroUtils {

  static Widget _textFlightShuttleBuilder(
      BuildContext flightContext,
      Animation<double> animation,
      HeroFlightDirection flightDirection,
      BuildContext fromHeroContext,
      BuildContext toHeroContext,) {

    /// 当前动画是否为反向动画
    final bool reverse = animation.status == AnimationStatus.completed
        || animation.status == AnimationStatus.reverse;

    Text fromText = (fromHeroContext.widget as Hero).child;
    Text toText = (toHeroContext.widget as Hero).child;

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

    print('from: $fromSize, to: $toSize, reverse: $reverse, factor: $factor');

    final scaleAnimation = animation.drive(Tween(begin: 1.0, end: factor,));

    return ScaleTransition(
      scale: scaleAnimation,
      alignment: Alignment.topLeft,
      child: fromText,
    );
  }

  /// 当我们使用Hero控件，并且子控件为Text的时候，很容易出现文字大小不一致的问题
  ///
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