import 'package:flutter/material.dart';
import 'package:flutter_time/themes/time_theme_data.dart';
import 'package:flutter_time/ui/animation/customize_tween.dart';
import 'package:flutter_time/ui/common_ui.dart';
import 'package:flutter_time/value/colors.dart';

/// 在这个时刻开始缩放
const _kIconScaleStartThreshold = 0.1;
/// 在这个时刻缩放结束
const _kIconScaleEndThreshold = 0.2;
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

  AnimationController slideAnimationController;
  Animation<Offset> slideAnimation;
  
  Animation<double> leftScaleAnimation;
  Animation<double> rightScaleAnimation;
  Animation<Offset> leftMoveAnimation;
  Animation<Offset> rightMoveAnimation;

  // 手指滑动的累计偏移量
  double _dragExtent = 0.0;
  /// 记录item移动的位置 有负值
  double _dragValue = 0.0;

  void onDragCancel() {
    print('drag cancel');
    slideAnimationController.reverse();
  }

  void onDragStart(DragStartDetails details) {
    print('drag start, position: ${details.localPosition}');
  }

  void onDragDown(DragDownDetails details) {
    print('drag down, position: ${details.localPosition}');
    _dragExtent = _dragValue * context.size.width;
  }

  void onDragUpdate(DragUpdateDetails details) {
    print('drag update, delta: ${details.delta}, drag extent');

    // 暂存一个上一次的偏移量
    final double oldDragExtent = _dragExtent;
    // 更新偏移量
    _dragExtent += details.delta.dx;

    if (oldDragExtent.sign != _dragExtent.sign) {
      setState(() {
        _updateAnimation();
      });
    }

    final double width = context.size.width;
    slideAnimationController.value = _dragExtent.abs() / width;

    _dragValue = slideAnimationController.value;
    if (_dragExtent < 0) _dragValue = -_dragValue;
  }

  void onDragEnd(DragEndDetails details) {
    print('drag end, velocity: $details');
    if (slideAnimationController.value > _kIconScaleEndThreshold) {
      /// 跳转到
      slideAnimationController.animateTo(_kIconScaleEndThreshold);
    } else {
      slideAnimationController.reverse();
    }
  }

  void updateDragValue() {

  }

  @override
  void initState() {
    super.initState();

    slideAnimationController = new AnimationController(
        vsync: this, 
        duration: const Duration(milliseconds: 500)
    );

    _updateAnimation();

    slideAnimationController.addListener(() {

    });

    slideAnimationController.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.dismissed:
          _dragExtent = 0.0;
          break;
        default: break;
      }
    });
  }

  @override
  void dispose() {
    slideAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    /// 内容
    final Widget content = SlideTransition(
      position: slideAnimation,
      child: widget.child,
    );

    /// 左右两个按钮
    final Widget background = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ScaleTransition(
          scale: leftScaleAnimation,
          child: widget.leftAction,
        ),
        ScaleTransition(
          scale: rightScaleAnimation,
          child: widget.rightAction,
        ),
      ],
    );

    final Widget child = Stack(
      alignment: Alignment.center,
      children: [
        background,
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

  void _updateAnimation() {
    slideAnimation = slideAnimationController.drive(Tween<Offset>(
      begin: Offset.zero,
      end: Offset(_dragExtent.sign, 0.0),
    ));

    if (_dragExtent.sign >= 0) {
      leftScaleAnimation = slideAnimationController.drive(DelayTween<double>(
        startValue: _kIconScaleStartThreshold,
        endValue: _kIconScaleEndThreshold,
        begin: _kIconScaleStartSize,
        end: _kIconScaleEndSize,
      ));
      rightScaleAnimation = slideAnimationController.drive(Tween<double>(
        begin: 0.0,
        end: 0.0,
      ));
      leftMoveAnimation = slideAnimationController.drive(DelayTween<Offset>(
        startValue: _kIconScaleStartThreshold,
        endValue: _kIconScaleEndThreshold,
        begin: Offset.zero,
        end: Offset(1.0, 0.0)
      ));
      rightMoveAnimation = slideAnimationController.drive(Tween<Offset>(
          begin: Offset.zero,
          end: Offset.zero,
      ));
    } else {
      rightScaleAnimation = slideAnimationController.drive(DelayTween<double>(
        startValue: _kIconScaleStartThreshold,
        endValue: _kIconScaleEndThreshold,
        begin: _kIconScaleStartSize,
        end: _kIconScaleEndSize,
      ));
      leftScaleAnimation = slideAnimationController.drive(Tween<double>(
        begin: 0.0,
        end: 0.0,
      ));
      rightMoveAnimation = slideAnimationController.drive(DelayTween<Offset>(
          startValue: _kIconScaleStartThreshold,
          endValue: _kIconScaleEndThreshold,
          begin: Offset.zero,
          end: Offset(-1.0, 0.0)
      ));
      leftMoveAnimation = slideAnimationController.drive(Tween<Offset>(
        begin: Offset.zero,
        end: Offset.zero,
      ));
    }
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
        Text(label, style: TimeThemeData.smallTextStyle.apply(color: bgColor),),
      ],
    );
  }
}
