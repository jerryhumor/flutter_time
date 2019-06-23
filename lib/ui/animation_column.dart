import 'package:flutter/material.dart';

enum AnimationColumnDirection{
  startToEnd,
  endToStart
}
/**
 * 带动画的Column
 * 可以通过动画决定
 */
class AnimationColumn extends StatelessWidget {

  final double fadeStart, fadeEnd;
  final Offset positionStart, positionEnd;
  final AnimationController controller;
  final List<Widget> children;
  final AnimationColumnDirection direction;

  AnimationColumn({
    this.fadeStart,
    this.fadeEnd,
    this.positionStart,
    this.positionEnd,
    this.direction = AnimationColumnDirection.startToEnd,
    @required this.controller,
    @required this.children
  });

  @override
  Widget build(BuildContext context) {

    List<Widget> animationChildren = [];
    final int childrenCount = children.length;
    for (int i = 0; i < childrenCount; i++) {
      Widget content = children[i];
      double triggerStart = 1.0 / childrenCount * i;
      double triggerEnd = 1.0 / childrenCount * (i + 1);
      if (positionStart != null && positionEnd != null) {
        Animation<Offset> slideAnimation = 
          TriggerOffsetTween(
            begin: positionStart, 
            end: positionEnd, 
            triggerStart: triggerStart,
            triggerEnd: triggerEnd
          ).animate(controller);
        content = SlideTransition(
          position: slideAnimation,
          child: content,
        );
      }
      if (fadeStart != null && fadeEnd != null) {
        Animation<double> fadeAnimation = 
          TriggerFadeTween(
            begin: fadeStart, 
            end: fadeEnd, 
            triggerStart: triggerStart,
            triggerEnd: triggerEnd
          ).animate(controller);
        content = FadeTransition(
          opacity: fadeAnimation,
          child: content,
        );
      }
      animationChildren.add(content);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: animationChildren,
    );
  }
}

// 触发的补间
class TriggerFadeTween extends Tween<double> {

  // 这个参数主要规定触发的点 范围0-1 和contoller的value对应
  final double triggerStart, triggerEnd;
  final double begin, end;

  TriggerFadeTween({
    this.begin = 0.0,
    this.end = 1.0,
    this.triggerStart = 0.0,
    this.triggerEnd = 1.0
  }): super(begin: begin, end: end);

  @override
  double lerp(double t) {
    if (t < triggerStart) {
      return begin;
    } else if (t > triggerEnd) {
      return end;
    } else {
      double v = end - begin;
      double t1 = t - triggerStart;
      double t2 = triggerEnd - triggerStart;
      if (t1 > t2) t1 = t2;
      return begin + v * (t1 / t2);
    }
  }
}

// 触发的补间
class TriggerOffsetTween extends Tween<Offset> {

  // 这个参数主要规定触发的点 范围0-1 和contoller的value对应
  final double triggerStart, triggerEnd;
  final Offset begin, end;

  TriggerOffsetTween({
    this.begin = Offset.zero,
    this.end = const Offset(1.0, 1.0),
    this.triggerStart = 0.0,
    this.triggerEnd = 1.0
  }): super(begin: begin, end: end);

  @override
  Offset lerp(double t) {
    if (t < triggerStart) {
      return begin;
    } else if (t > triggerEnd) {
      return end;
    } else {
      double t1 = t - triggerStart;
      double t2 = triggerEnd - triggerStart;
      if (t1 > t2) t1 = t2;
      return Offset.lerp(begin, end, t1 / t2);
    }
  }
}