import 'package:flutter/material.dart';
import 'package:flutter_time/themes/time_theme_data.dart';
import 'package:flutter_time/ui/animation/customize_tween.dart';
import 'package:flutter_time/ui/common_ui.dart';
import 'package:flutter_time/value/colors.dart';

/// 在这个时刻开始缩放
const _kRightIconScaleStartThreshold = -0.1;
/// 在这个时刻缩放结束
const _kRightIconScaleEndThreshold = -0.2;
/// 在这个时刻开始缩放
const _kLeftIconScaleStartThreshold = 0.1;
/// 在这个时刻缩放结束
const _kLeftIconScaleEndThreshold = 0.2;
/// 这个时刻开始滑动缓慢
const _kIconSlowStart = 0.3;
/// 别人划1像素 他只能划0.2像素
const _kIconSlideDamp = 0.2;
/// 这个时刻滑动开始变快
const _kIconFastStart = 0.6;
/// 别人划1像素 他可以划3像素
const _kIconSlideLubricant = 3.0;
/// 最多只能滑到这里
const _kSlideThreshold = 0.8;

/// 缩放的范围 从 startSize - endSize
const _kIconScaleStartSize = 0.3;
const _kIconScaleEndSize = 1.0;

class ItemGestureWrapper extends StatefulWidget {

  final Widget child;
  final VoidCallback onTap;
  final Widget leftAction;
  final Widget rightAction;

  ItemGestureWrapper({
    this.child,
    this.onTap,
    this.leftAction,
    this.rightAction,
  });

  @override
  _ItemGestureWrapperState createState() => _ItemGestureWrapperState();
}

class _ItemGestureWrapperState extends State<ItemGestureWrapper> with SingleTickerProviderStateMixin {

  /// 动画控制器
  AnimationController animationController;
  /// 动画 值为-1~+1 表示item的位移程度
  Animation<double> animation;

  /// 滑动
  Animation<Offset> slideAnimation;
  
  Animation<double> leftScaleAnimation;
  Animation<double> rightScaleAnimation;
  Animation<Offset> leftMoveAnimation;
  Animation<Offset> rightMoveAnimation;

  // 手指滑动的累计偏移量
  double _dragExtent = 0.0;

  void onDragCancel() {
    print('drag cancel');
    itemOffsetReset();
  }

  void onDragStart(DragStartDetails details) {}

  void onDragDown(DragDownDetails details) {
    _dragExtent = animationController.value * context.size.width;
  }

  void onDragUpdate(DragUpdateDetails details) {
    // 更新偏移量
    _dragExtent += details.delta.dx;

    final double width = context.size.width;
    animationController.value = _dragExtent / width;
  }

  void onDragEnd(DragEndDetails details) {
    print('drag end, velocity: $details');
    final double value = animationController.value;
    /// 判断是否需要停在某个位置
    if (value < _kRightIconScaleEndThreshold) {
      itemOffsetRightHoldOn();
    } else if (value > _kLeftIconScaleEndThreshold) {
      itemOffsetLeftHoldOn();
    } else {
      itemOffsetReset();
    }
  }

  /// item位置复原 回到中间
  void itemOffsetReset() {
    animationController.animateTo(0.0);
  }

  /// item停在能展示左边图标的位置
  void itemOffsetLeftHoldOn() {
    animationController.animateTo(_kLeftIconScaleEndThreshold);
  }

  /// item停在能展示右边图标的位置
  void itemOffsetRightHoldOn() {
    print('right icon hold on');
    animationController.animateTo(_kRightIconScaleEndThreshold);
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: -1.0,
      upperBound: 1.0,
      value: 0.0,
    );

    /// 滑动动画
    slideAnimation = animationController.drive(ItemOffsetTween());
    /// 缩放动画
    leftScaleAnimation = animationController.drive(LeftActionScaleTween(
      begin: _kIconScaleStartSize,
      end: _kIconScaleEndSize,
      start: _kLeftIconScaleStartThreshold,
      finish: _kLeftIconScaleEndThreshold,
    ));
    rightScaleAnimation = animationController.drive(RightActionScaleTween(
      begin: _kIconScaleStartSize,
      end: _kIconScaleEndSize,
      start: _kRightIconScaleStartThreshold,
      finish: _kRightIconScaleEndThreshold,
    ));
    /// 平移动画
    leftMoveAnimation = animationController.drive(ItemOffsetTween());
    rightMoveAnimation = animationController.drive(ItemOffsetTween());
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    /// 内容
    final Widget content = SlideTransition(
      position: slideAnimation,
      child: widget.child,
    );

    final Widget leftAction = SlideTransition(
      position: leftMoveAnimation,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ScaleTransition(
            scale: leftScaleAnimation,
            child: widget.leftAction,
          ),
        ],
      ),
    );

    final Widget rightAction = SlideTransition(
      position: rightMoveAnimation,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ScaleTransition(
            scale: rightScaleAnimation,
            child: widget.rightAction,
          ),
        ],
      ),
    );

    final Widget child = Stack(
      alignment: Alignment.center,
      children: [
        leftAction,
        rightAction,
        content,
      ],
    );

    return GestureDetector(
      onHorizontalDragStart: onDragStart,
      onHorizontalDragDown: onDragDown,
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
      onHorizontalDragCancel: onDragCancel,
      onTap: widget.onTap,
      child: child,
    );
  }
}

const _kIconSize = 48.0;

class ActionIcon extends StatelessWidget {

  final Color bgColor;
  final Icon icon;
  final String label;

  ActionIcon({this.bgColor, this.icon, this.label,});
  
  const ActionIcon.delete(): 
        bgColor = colorRed1, 
        icon = const Icon(Icons.delete_outline, color: Colors.white,), 
        label = '删除';

  const ActionIcon.archive():
        bgColor = colorBlue1,
        icon = const Icon(Icons.archive, color: Colors.white,),
        label = '归档';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: _kIconSize,
          height: _kIconSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
          ),
          child: Center(
            child: icon,
          ),
        ),
        SizedBox(height: 4.0,),
        Text(label, style: TimeTheme.smallTextStyle.apply(color: bgColor),),
      ],
    );
  }
}

/// 区间范围为-1.0 ~ 1.0之间
class ItemOffsetTween extends Animatable<Offset> {

  final Offset begin = Offset(-1.0, 0.0), end = Offset(1.0, 0.0);

  @override
  Offset transform(double t) {
    if (t == -1.0)
      return begin;
    if (t == 1.0)
      return end;

    return begin + (end - begin) * ((t + 1.0) / 2.0);
  }
}

class LeftActionScaleTween extends Animatable<double> {

  /// 什么时候开始变
  final double start, finish;
  /// 变成什么样子
  final double begin, end;

  LeftActionScaleTween({this.begin, this.end, this.start, this.finish,});

  @override
  double transform(double t) {
    if (t <= start)
      return begin;
    if (t >= finish)
      return end;
    return begin + (end - begin) * ((t - start) / (finish - start));
  }
}

class RightActionScaleTween extends Animatable<double> {

  /// 什么时候开始变
  final double start, finish;
  /// 变成什么样子
  final double begin, end;

  RightActionScaleTween({this.begin, this.end, this.start, this.finish,});

  @override
  double transform(double t) {
    if (t >= start)
      return begin;
    if (t <= finish)
      return end;
    return begin + (end - begin) * ((start - t) / (start - finish));
  }
}
