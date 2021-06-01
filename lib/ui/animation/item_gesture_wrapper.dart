import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time/themes/time_theme_data.dart';

const _kIconScaledSize = 0.3;
const _kIconOriginSize = 1.0;
const _kIconScaleDuration = const Duration(milliseconds: 200);
const _kItemSlideDuration = const Duration(milliseconds: 500);

class ItemGestureWrapper extends StatefulWidget {

  final Widget child;
  final VoidCallback onTap;
  final PreferredSizeWidget leftAction;
  final PreferredSizeWidget rightAction;
  final VoidCallback onLeftAction;
  final VoidCallback onRightAction;

  ItemGestureWrapper({
    this.child,
    this.onTap,
    this.leftAction,
    this.onLeftAction,
    this.rightAction,
    this.onRightAction,
  });

  @override
  _ItemGestureWrapperState createState() => _ItemGestureWrapperState();
}

class _ItemGestureWrapperState extends State<ItemGestureWrapper> with TickerProviderStateMixin {

  /// item控制器
  AnimationController itemController;
  /// 左边icon控制器
  AnimationController iconScaleController;
  /// 右边icon控制器
  AnimationController rightIconSlideController;
  /// 滑动
  Animation<Offset> slideAnimation;

  /// 记录上一次滑动的值
  double lastDx = 0.0;

  bool isDragging = false;
  bool dragMode = false;
  DragOffsetHelper helper;

  void onDragCancel() {
    itemOffsetReset();
    isDragging = false;
  }

  void onDragStart(DragStartDetails details) {
    helper.updateSize(context, widget);
    setState(() {
      isDragging = true;
      dragMode = true;
    });
  }

  void onDragDown(DragDownDetails details) {
    itemController.stop();
  }

  void onDragUpdate(DragUpdateDetails details) {

    if (itemController.isAnimating) return;

    /// 获取偏移量
    final double dx = details.delta.dx;
    lastDx = dx;
    /// 获取当前的值
    final double value = itemController.value;

    if (value > 0.5 && value < 0.9 && dx > 0) {
      itemSlideToRight();
      return;
    }

    /// 计算需要偏移的量 可以通过这个函数实现阻尼
    final double itemOffset = helper.calculateItemOffset(value, dx);

    /// 更新偏移量
    itemController.value += itemOffset;
  }

  void onDragEnd(DragEndDetails details) {
    final double value = itemController.value;

    /// 判断是否需要停在某个位置
    if (value < -0.5){
      itemOffsetReset();
      if (widget.rightAction != null && widget.onRightAction != null)
        itemController.addListener(triggerOnRight);
    } else if (value > 0.5) {
      itemOffsetReset();
      if (widget.leftAction != null && widget.onLeftAction != null)
        itemController.addListener(triggerOnLeft);
    } else if (value < helper.rightIconScaleThreshold && widget.rightAction != null) {
      itemShowRightIcon();
    } else if (value > helper.leftIconScaleThreshold && widget.leftAction != null) {
      itemShowLeftIcon();
    } else {
      itemOffsetReset();
    }

    isDragging = false;
  }

  void onTap() {
    if (itemController.value != 0.0) return;
    widget.onTap();
  }

  void itemSlideToRight() {
    HapticFeedback.lightImpact();
    itemController.animateTo(
      0.9,
      duration: _kItemSlideDuration,
      curve: Curves.decelerate,
    );
  }

  /// item位置复原 回到中间
  void itemOffsetReset() {
    itemController.animateTo(
      0.0,
      duration: _kItemSlideDuration,
      curve: Curves.decelerate,
    );
  }

  /// item停在能展示左边图标的位置
  void itemShowLeftIcon() {
    itemController.animateTo(
        helper.leftIconHoldThreshold,
        duration: _kItemSlideDuration,
        curve: Curves.decelerate,
    );
  }

  /// item停在能展示右边图标的位置
  void itemShowRightIcon() {
    itemController.animateTo(
        helper.rightIconHoldThreshold,
        duration: _kItemSlideDuration,
        curve: Curves.decelerate,
    );
  }
  
  /// 右边icon靠近item动画
  void rightIconCloseItem() {
    HapticFeedback.lightImpact();
    rightIconSlideController.animateTo(
      1.0,
      duration: _kIconScaleDuration,
      curve: Curves.decelerate,
    );
  }
  
  /// 右边icon远离item动画
  void rightIconLeaveItem() {
    HapticFeedback.lightImpact();
    rightIconSlideController.animateTo(
      0.0,
      duration: _kIconScaleDuration,
      curve: Curves.decelerate,
    );
  }

  /// icon变大动画
  void iconGetBigger() {
    iconScaleController.animateTo(
      _kIconOriginSize,
      duration: _kIconScaleDuration,
      curve: Curves.decelerate,
    );
  }

  /// icon变小动画
  void iconGetSmaller() {
    iconScaleController.animateTo(
      _kIconScaledSize,
      duration: _kIconScaleDuration,
      curve: Curves.decelerate,
    );
  }

  /// 动画执行完毕之后 触发左边action
  void triggerOnLeft() {
    if (!isDragging && itemController.value == 0.0) {
      itemController.removeListener(triggerOnLeft);
      widget.onLeftAction();
    }
  }

  /// 动画执行完毕之后 触发右边action
  void triggerOnRight() {
    if (!isDragging && itemController.value == 0.0) {
      itemController.removeListener(triggerOnRight);
      widget.onRightAction();
    }
  }

  @override
  void initState() {
    super.initState();

    helper = DragOffsetHelper();
    itemController = AnimationController(
      vsync: this,
      lowerBound: -1.0,
      upperBound: 1.0,
      value: 0.0,
    );
    iconScaleController = AnimationController(
      vsync: this,
      value: _kIconScaledSize,
    );
    rightIconSlideController = AnimationController(
      vsync: this,
      value: 0.0,
    );

    /// 滑动动画
    slideAnimation = itemController.drive(ItemOffsetTween());

    itemController.addListener(() {

      final double value = itemController.value;

      if (widget.leftAction != null && itemController.value > 0 && !iconScaleController.isAnimating) {
        if (itemController.value > helper.leftIconScaleThreshold && iconScaleController.value < _kIconOriginSize)
          iconGetBigger();
        else if (itemController.value < helper.leftIconScaleThreshold && iconScaleController.value > _kIconScaledSize)
          iconGetSmaller();
      } else if (widget.rightAction != null && itemController.value < 0 && !iconScaleController.isAnimating) {
        if (itemController.value < helper.rightIconScaleThreshold && iconScaleController.value < _kIconOriginSize)
          iconGetBigger();
        else if (itemController.value > helper.rightIconScaleThreshold && iconScaleController.value > _kIconScaledSize)
          iconGetSmaller();
      }

      if (widget.rightAction != null && value < 0 && !rightIconSlideController.isAnimating) {
        final double rightValue = rightIconSlideController.value;
        if (value <= -0.5 && rightValue < 1) {
          rightIconCloseItem();
        } else if (value > -0.5 && rightValue > 0) {
          rightIconLeaveItem();
        }
      }

      if (!isDragging && value == 0.0) setState(() { dragMode = false; });
      
    });
  }

  @override
  void dispose() {
    itemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget child;
    if (!dragMode) {
      child = widget.child;
    } else {
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
            if (itemController.value < 0) return const SizedBox();
            return Positioned(
              left: helper.calculateLeftActionOffset(
                itemController.value,
                widget.leftAction.preferredSize.width,
              ),
              child: ScaleTransition(
                scale: iconScaleController,
                child: child,
              ),
            );
          },
        );
        children.add(left);
      }

      /// 右侧操作按钮
      if (widget.rightAction != null) {
        Widget right = AnimatedBuilder(
          animation: itemController,
          child: widget.rightAction,
          builder: (context, child) {
            if (itemController.value > 0) return const SizedBox();
            return AnimatedBuilder(
              animation: rightIconSlideController,
              child: child,
              builder: (context, child) {
                final double value = helper.calculateRightActionOffset(
                  itemController.value,
                  widget.rightAction.preferredSize.width,
                  rightIconSlideController.value,
                );
                return Positioned(
                  right: value,
                  child: ScaleTransition(
                    scale: iconScaleController,
                    child: child,
                  ),
                );
              },
            );
          },
        );
        children.add(right);
      }

      children.add(content);

      child = Stack(
        alignment: Alignment.center,
        children: children,
      );
    }

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
    helper.resetSize();
    super.didUpdateWidget(oldWidget);
  }
}

const _kIconPaddingVertical = 4.0;
const _kIconPaddingHorizontal = 10.0;
const _kIconWidth = 48.0;
const _kIconPadding = EdgeInsets.symmetric(vertical: _kIconPaddingVertical, horizontal: _kIconPaddingHorizontal);
const _kIconSize = Size(_kIconWidth + 2 * _kIconPaddingHorizontal, _kIconWidth);

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


/// 滑动助手 计算偏移量 实现阻尼等效果
class DragOffsetHelper {

  /// 控件的一些尺寸信息
  /// 尺寸更新标志
  bool sizeUpdated = false;
  /// item的宽度
  double itemWidth = 0.0;
  /// 左边icon的缩放阈值
  double leftIconScaleThreshold = 1.0;
  /// 左边icon的停驻阈值
  double leftIconHoldThreshold = 1.0;
  /// 右边icon的缩放阈值
  double rightIconScaleThreshold = -1.0;
  /// 右边icon的停驻阈值
  double rightIconHoldThreshold = -1.0;
  /// 右边icon在移动时 最小距离
  double rightIconMinValue;
  
  void updateSize(BuildContext context, ItemGestureWrapper wrapper) {
    if (sizeUpdated) return;
    itemWidth = context.size.width;

    if (wrapper.leftAction != null) {
      leftIconHoldThreshold = wrapper.leftAction.preferredSize.width / itemWidth;
      leftIconScaleThreshold = leftIconHoldThreshold / 2;
    }
    if (wrapper.rightAction != null) {
      rightIconHoldThreshold = - wrapper.rightAction.preferredSize.width / itemWidth;
      rightIconScaleThreshold = rightIconHoldThreshold / 2;
      rightIconMinValue = (rightIconHoldThreshold + 0.5) * 0.25 * itemWidth;
    }
    sizeUpdated = true;
  }

  void resetSize() {
    sizeUpdated = false;
    itemWidth = 0.0;
    leftIconScaleThreshold = 1.0;
    leftIconHoldThreshold = 1.0;
    rightIconScaleThreshold = -1.0;
    rightIconHoldThreshold = -1.0;
    rightIconMinValue = null;
  }

  /// [-1.0, -0.5) 0.25
  /// [-0.5, 0.9)  1
  /// [0.9, 1.0]   0.25
  double calculateItemOffset(double movedPercent, double dx) {
    if (movedPercent < -1.0) return 0;
    if (movedPercent >= -1.0 && movedPercent < -0.5) return dx * 0.25 / itemWidth;
    if (movedPercent >= -0.5 && movedPercent < 0.9) return dx / itemWidth;
    if (movedPercent >= 0.9 && movedPercent <= 1.0) return dx * 0.25 / itemWidth;
    return 0;
  }

  double calculateLeftActionOffset(double movePercent, double iconWidth) {
    return movePercent * itemWidth - iconWidth;
  }

  /// 计算右边按钮的距离
  /// (-1.0, threshold] 0.25
  /// (threshold, 0.0) 1.0
  double calculateRightActionOffset(
      double movePercent,
      double iconWidth,
      double animationValue,) {
    /// 按照阻尼 计算应该的偏移量
    if (movePercent > -1.0 && movePercent < -0.5) {
      return (- movePercent * itemWidth - iconWidth - rightIconMinValue) * animationValue + rightIconMinValue;
    }
    if (movePercent >= -0.5 && movePercent <= rightIconHoldThreshold) {
      return (rightIconHoldThreshold - movePercent) * (0.25 + (0.75 * animationValue)) * itemWidth;
    }
    if (movePercent > rightIconHoldThreshold && movePercent < 0.0) {
      return - movePercent * itemWidth - iconWidth;
    }
    return null;
  }

}
