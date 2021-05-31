import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final PreferredSizeWidget leftAction;
  final PreferredSizeWidget rightAction;

  ItemGestureWrapper({
    this.child,
    this.onTap,
    this.leftAction,
    this.rightAction,
  });

  @override
  _ItemGestureWrapperState createState() => _ItemGestureWrapperState();
}

class _ItemGestureWrapperState extends State<ItemGestureWrapper> with TickerProviderStateMixin {

  /// item控制器
  AnimationController itemController;
  /// 左边icon控制器
  AnimationController leftController;
  /// 右边icon控制器
  AnimationController rightController;

  /// 动画 值为-1~+1 表示item的位移程度
  Animation<double> animation;

  /// 滑动
  Animation<Offset> slideAnimation;
  /// 左边按钮的滑动动画
  Animation<double> leftScaleAnimation;

  // 手指滑动的累计偏移量
  double _dragExtent = 0.0;
  double _lastDx = 0.0;

  /// 控件的一些尺寸信息
  bool sizeUpdated = false;
  double itemWidth = 0.0;
  double leftIconScaleThreshold = 1.0;

  void onDragCancel() {
    print('drag cancel');
    itemOffsetReset();
  }

  void onDragStart(DragStartDetails details) {
    updateSize();
  }

  void onDragDown(DragDownDetails details) {
    itemController.stop();
  }

  void onDragUpdate(DragUpdateDetails details) {

    if (itemController.isAnimating) return;

    /// 获取偏移量
    final double dx = details.delta.dx;
    final double width = context.size.width;
    _lastDx = dx;

    if (itemController.value > 0.5 && dx > 0) {
      itemSlideToRight();
      return;
    }

    /// 计算需要偏移的量 可以通过这个函数实现阻尼
    final double itemOffset = DragOffsetHelper.calculateItemOffset(itemController.value, dx, width);

    /// 更新偏移量
    itemController.value += itemOffset;
  }

  void onDragEnd(DragEndDetails details) {
    print('drag end, velocity: $details');
    final double value = itemController.value;
    /// 判断是否需要停在某个位置
    if (value < _kRightIconScaleEndThreshold) {
      itemOffsetRightHoldOn();
    } else if (value > _kLeftIconScaleEndThreshold && _lastDx > 0) {
      itemOffsetLeftHoldOn();
    } else {
      itemOffsetReset();
    }
  }

  void onTap() {
    if (itemController.value != 0.0) return;
    widget.onTap();
  }

  void itemSlideToRight() {
    HapticFeedback.lightImpact();
    itemController.animateTo(0.9, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  /// item位置复原 回到中间
  void itemOffsetReset() {
    itemController.animateTo(0.0, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  /// item停在能展示左边图标的位置
  void itemOffsetLeftHoldOn() {
    itemController.animateTo(_kLeftIconScaleEndThreshold, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  /// item停在能展示右边图标的位置
  void itemOffsetRightHoldOn() {
    print('right icon hold on');
    itemController.animateTo(_kRightIconScaleEndThreshold, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void resetSize() {
    sizeUpdated = false;
    itemWidth = 0.0;
    leftIconScaleThreshold = 1.0;
  }

  void updateSize() {
    if (sizeUpdated) return;
    itemWidth = context.size.width;
    if (widget.leftAction != null)
      leftIconScaleThreshold = widget.leftAction.preferredSize.width / 2 / itemWidth;
    sizeUpdated = true;
  }

  @override
  void initState() {
    super.initState();

    itemController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      lowerBound: -1.0,
      upperBound: 1.0,
      value: 0.0,
    );
    leftController = AnimationController(
      vsync: this,
      value: 0.3,
    );
    rightController = AnimationController(
      vsync: this,
      value: 0.5,
    );

    /// 滑动动画
    slideAnimation = itemController.drive(ItemOffsetTween());

    itemController.addListener(() {
      if (widget.leftAction != null && itemController.value > 0 && !leftController.isAnimating) {
        if (itemController.value > leftIconScaleThreshold && leftController.value < 1.0)
          leftController.animateTo(1.0, duration: Duration(milliseconds: 200), curve: Curves.decelerate);
        else if (itemController.value < leftIconScaleThreshold && leftController.value > 0.3) {
          leftController.animateTo(0.3, duration: Duration(milliseconds: 200));
        }
      } else if (itemController.value < 0) {
        if (rightController.isAnimating) return;
        rightController.value = -itemController.value;
        /// todo 更新rightController
      } else {

      }
    });


  }

  @override
  void dispose() {
    itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> children = [];

    /// 内容
    final Widget content = SlideTransition(
      position: slideAnimation,
      child: widget.child,
    );

    /// 左侧操作按钮
    if (widget.leftAction != null) {
      Widget left = AnimatedBuilder(
        animation: itemController,
        child: widget.leftAction,
        builder: (context, child) {
          return Positioned(
            left: itemController.value * itemWidth - widget.leftAction.preferredSize.width,
            child: ScaleTransition(
              scale: leftController,
              child: child,
            ),
          );
        },
      );
      children.add(left);
    }

    /// 右侧操作按钮
    // if (widget.rightAction != null && rightController.value > 0) {
    //   final Widget rightAction = SlideTransition(
    //     position: rightMoveAnimation,
    //     child: Row(
    //       mainAxisSize: MainAxisSize.max,
    //       mainAxisAlignment: MainAxisAlignment.end,
    //       children: [
    //         ScaleTransition(
    //           scale: rightScaleAnimation,
    //           child: widget.rightAction,
    //         ),
    //       ],
    //     ),
    //   );
    //   children.add(rightAction);
    // }

    children.add(content);

    final Widget child = Stack(
      alignment: Alignment.center,
      children: children,
    );

    return GestureDetector(
      onHorizontalDragStart: onDragStart,
      onHorizontalDragDown: onDragDown,
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
      onHorizontalDragCancel: onDragCancel,
      onTap: onTap,
      child: child,
    );
  }

  @override
  void didUpdateWidget(ItemGestureWrapper oldWidget) {
    resetSize();
    super.didUpdateWidget(oldWidget);
  }
}

const _kIconPadding = EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0);
const _kIconSize = Size(60.0, 48.0);

class ActionIcon extends StatelessWidget implements PreferredSizeWidget {

  final Size preferredSize;
  final Color bgColor;
  final Icon icon;
  final String label;

  ActionIcon({this.bgColor, this.icon, this.label, this.preferredSize = _kIconSize,});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: _kIconPadding,
          child: Container(
            width: preferredSize.height,
            height: preferredSize.height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: bgColor,
            ),
            child: Center(
              child: icon,
            ),
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


/// 滑动助手 计算偏移量 实现阻尼等效果
class DragOffsetHelper {

  /// [-1.0, -0.5) 0.25
  /// [-0.5, 0.9)  1
  /// [0.9, 1.0]   0.25
  static double calculateItemOffset(double movedPercent, double dx, double width) {
    if (movedPercent < -1.0) return 0;
    if (movedPercent >= -1.0 && movedPercent < -0.5) return dx * 0.25 / width;
    if (movedPercent >= -0.5 && movedPercent < 0.9) return dx / width;
    if (movedPercent >= 0.9 && movedPercent <= 1.0) return dx * 0.25 / width;
    return 0;
  }


  static double calculateLeftActionOffset(double movePercent, double dx, double width) {
    if (movePercent > 1.0 || movePercent < 0.0) return 0;
    return dx / width;
  }

  /// [0.0, 0.2) 1.0
  /// [0.2, 1.0] 0.25
  static double calculateRightActionOffset(double movePercent, double dx, double width) {
    if (movePercent > 1.0 || movePercent < 0.0) return 0;
    if (movePercent >= 0.0 && movePercent < 0.2) return dx / width;
    if (movePercent >= 0.2) return dx * 0.25 / width;
  }

}
