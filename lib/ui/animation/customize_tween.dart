import 'package:flutter/animation.dart';

class DelayTween<T> extends Tween<T> {

  double startValue, endValue;
  double factor;

  DelayTween({
    this.startValue = 0.0,
    this.endValue = 1.0,
    T begin,
    T end,
  }): super(begin: begin, end: end) {
    factor = 1 / (endValue - startValue);
  }

  @override
  T transform(double t) {
    double value = 0.0;
    if (t <= startValue) {
      value = 0.0;
    } else if (t >= endValue) {
      value = 1.0;
    } else {
      value = (t - startValue) * factor;  
    }
    return lerp(value);
  }
}

/// 范围
class TweenRange {
  /// 范围的长度
  double range;
  /// 斜率
  double slope;

  TweenRange(this.range, this.slope);

}

class MultipleRangeTween<T> extends Tween<T> {

  final List<TweenRange> ranges;
  final T begin, end;



  MultipleRangeTween({
    this.ranges,
    this.begin,
    this.end,
  }) {

  }

  @override
  T transform(double t) {
    double value = 0.0;

    return lerp(value);
  }
}