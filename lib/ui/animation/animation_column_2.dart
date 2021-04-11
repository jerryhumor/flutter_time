import 'package:flutter/material.dart';
import 'package:flutter_time/ui/animation/customize_tween.dart';

enum ItemState {
  completed,
  dismissed,
}

enum AnimationType {
  /// 按顺序显示和消失
  showOrdered,
  /// 在某个item中声明了first为true，那么那个item会先显示或消失，其他item同时显示
  showOneFirst,
}

const SHOW_ONE_FIRST_FIRST_START = 0.0;
const SHOW_ONE_FIRST_FIRST_END = 0.67;
const SHOW_ONE_FIRST_OTHER_START = 0.33;
const SHOW_ONE_FIRST_OTHER_END = 1.0;

/// item动画时长 毫秒
const _kDuration = 250;
/// 下一个item动画延时 毫秒
const _kDelayDuration = 50;
/// 默认位移开始位置
const _kPositionBegin = Offset(-0.3, 0.0);
/// 默认位移结束位置
const _kPositionEnd = Offset.zero;
/// 默认透明度开始
const _kOpacityBegin = 0.0;
/// 默认透明度结束
const _kOpacityEnd = 1.0;

class AnimationColumn2 extends StatefulWidget {

  final List<Widget> children;
  final VoidCallback onAnimationFinished;
  final ItemState fromState;
  final ItemState toState;
  final AnimationType animationType;
  final int durationMillis;
  final int delayMillis;
  /// 位移动画参数
  final Offset positionBegin;
  final Offset positionEnd;
  /// 透明动画参数
  final double opacityBegin;
  final double opacityEnd;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final bool displayAnimationWhenInit;

  AnimationColumn2({
    this.children, 
    this.onAnimationFinished, 
    this.fromState,
    this.toState,
    this.animationType = AnimationType.showOrdered,
    this.durationMillis = _kDuration,
    this.delayMillis = _kDelayDuration,
    this.positionBegin = _kPositionBegin,
    this.positionEnd = _kPositionEnd,
    this.opacityBegin = _kOpacityBegin,
    this.opacityEnd = _kOpacityEnd,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.displayAnimationWhenInit = false,
  });

  /// 获取children中需要展示动画的widget的数量
  int get animationItemCount {
    if (children == null || children.isEmpty) return 0;
    int count = 0;
    children.forEach((element) {
      if (element is AnimationColumnItem) count++;
    });
    return count;
  }

  int get firstAnimationItemIndex {
    if (children == null || children.isEmpty) return -1;
    for (int i = 0; i < children.length; i++) {
      final Widget child = children[i];
      if (child is AnimationColumnItem && child.first) {
        return i;
      }
    }
    return -1;
  }

  @override
  _AnimationColumn2State createState() => _AnimationColumn2State();
}

class _AnimationColumn2State extends State<AnimationColumn2> with SingleTickerProviderStateMixin {

  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this);
    initAnimation();
  }
  
  @override
  void didUpdateWidget(AnimationColumn2 oldWidget) {
    super.didUpdateWidget(oldWidget);

    updateAnimation(oldWidget);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    List<Widget> children = [];
    if (getAnimationType() == AnimationType.showOneFirst) {
      final int firstIndex = widget.firstAnimationItemIndex;
      final double firstEnd = 1.0 - (widget.delayMillis / widget.durationMillis);
      final double otherStart = widget.delayMillis / widget.durationMillis;
      for (int i = 0; i < widget.children.length; i++) {
        Widget child = widget.children[i];
        if (child is AnimationColumnItem) {
          if (i == firstIndex) {
            child = wrapAnimation(child, 0.0, firstEnd);
          } else {
            child = wrapAnimation(child, otherStart, 1.0);
          }
        }
        children.add(child);
      }
    } else {
      int animationIndex = 0;
      int unitDuration = widget.durationMillis - widget.delayMillis;
      double unitCount = (widget.durationMillis / unitDuration - 1) * widget.animationItemCount + 1;
      double unitLength = 1 / unitCount;
      double delayLength = widget.delayMillis / unitDuration * unitLength;

      for (int i = 0; i < widget.children.length; i++) {
        Widget child = widget.children[i];
        if (child is AnimationColumnItem) {
          final double start = animationIndex * delayLength;
          final double end = start + unitLength;
          child = wrapAnimation(child, start, end);
          animationIndex++;
        }
        children.add(child);
      }
    }

    return Column(
      crossAxisAlignment: widget.crossAxisAlignment,
      mainAxisAlignment: widget.mainAxisAlignment,
      children: children,
    );
  }

  Widget wrapAnimation(AnimationColumnItem item, double start, double end) {
    Widget child = item;
    if (widget.positionBegin != null && widget.positionEnd != null) {
      Animation<Offset> position = controller.drive(DelayTween<Offset>(
        startValue: start,
        endValue: end,
        begin: widget.positionBegin,
        end: widget.positionEnd,
      ));
      child = SlideTransition(
        position: position,
        child: child,
      );
    }

    if (widget.opacityBegin != null && widget.opacityEnd != null) {
      Animation opacity = controller.drive(DelayTween<double>(
        startValue: start,
        endValue: end,
        begin: widget.opacityBegin,
        end: widget.opacityEnd,
      ));
      child = FadeTransition(
        opacity: opacity,
        child: child,
      );
    }

    return child;
  }

  void initAnimation() {
    Duration animationDuration = Duration(
        milliseconds: widget.delayMillis * widget.animationItemCount + (widget.durationMillis - widget.delayMillis));
    controller.duration = animationDuration;

    bool needDisplay = widget.fromState != widget.toState;
    if (needDisplay && widget.displayAnimationWhenInit) {
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (widget.onAnimationFinished != null) widget.onAnimationFinished();
        } else if (status == AnimationStatus.dismissed) {
          if (widget.onAnimationFinished != null) widget.onAnimationFinished();
        }
      });
      if (widget.toState == ItemState.dismissed) {
        controller.reverse(from: 1.0);
      } else if (widget.toState == ItemState.completed) {
        controller.forward(from: 0.0);
      }
    } else {
      if (widget.toState == ItemState.completed && controller.status == AnimationStatus.dismissed) {
        controller.value = 1.0;
      } else if (widget.toState == ItemState.dismissed && controller.status == AnimationStatus.completed){
        controller.value = 0.0;
      }
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (widget.onAnimationFinished != null) widget.onAnimationFinished();
        } else if (status == AnimationStatus.dismissed) {
          if (widget.onAnimationFinished != null) widget.onAnimationFinished();
        }
      });
    }
  }

  /// 更新动画内容
  void updateAnimation(AnimationColumn2 oldWidget) {

    /// 判断children是否有变化 是否需要改变动画时长
    if (widget.animationItemCount != oldWidget.animationItemCount) {
      Duration animationDuration = Duration(
        milliseconds: widget.delayMillis * widget.animationItemCount + (widget.durationMillis - widget.delayMillis));
      controller.duration = animationDuration;
    }
    /// 判断状态是否有变化 是否需要展示动画
    if (widget.fromState != widget.toState
        && (oldWidget.fromState != widget.fromState
            || oldWidget.toState != widget.toState)) {
      if (widget.fromState == ItemState.dismissed) {
        controller.forward();
      } else {
        controller.reverse();
      }
    } else {
      if (widget.toState == ItemState.completed && controller.status == AnimationStatus.dismissed) {
        controller.value = 1.0;
      } else if (widget.toState == ItemState.dismissed && controller.status == AnimationStatus.completed){
        controller.value = 0.0;
      }
    }
  }

  /// 获取动画的类型
  /// 如果[widget.animationType] == [AnimationType.showOneFirst] 并且 [widget.children] 中有一个first值为true
  /// 那么类型就是[AnimationType.showOneFirst]
  /// 否则返回[AnimationType.showOrdered]
  AnimationType getAnimationType() {
    AnimationType type = AnimationType.showOrdered;
    if (widget.animationType == AnimationType.showOneFirst && widget.firstAnimationItemIndex >= 0) {
      type = AnimationType.showOneFirst;
    }
    return type;
  }
}

class AnimationColumnItem extends StatelessWidget {

  final Widget child;
  final bool first;

  AnimationColumnItem({this.child, this.first,});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
