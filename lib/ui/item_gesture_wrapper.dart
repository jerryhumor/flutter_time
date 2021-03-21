import 'package:flutter/material.dart';

class ItemGestureWrapper extends StatefulWidget {

  final Widget child;

  ItemGestureWrapper({this.child,});

  @override
  _ItemGestureWrapperState createState() => _ItemGestureWrapperState();
}

class _ItemGestureWrapperState extends State<ItemGestureWrapper> with SingleTickerProviderStateMixin {

  AnimationController slideAnimationController;
  Animation<Offset> slideAnimation;

  // 手指滑动的累计偏移量
  double _dragExtent = 0.0;

  void onDragCancel() {
    print('drag cancel');
    slideAnimationController.reverse();
  }

  void onDragStart(DragStartDetails details) {
    print('drag start, position: ${details.localPosition}');
  }

  void onDragDown(DragDownDetails details) {
    print('drag down, position: ${details.localPosition}');
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
  }

  void onDragEnd(DragEndDetails details) {
    print('drag end, velocity: $details');
    slideAnimationController.reverse();
  }

  void onTap() {

//    String bgHeroTag = 'bg_hero_${widget.index}';
//    String titleHeroTag = 'title_hero_${widget.index}';

    // todo 重新添加hero动画
    // Navigator.of(context).pushNamed('count_down_detail', arguments: {
    //   'model': widget.model,
    // });
  }

  @override
  void initState() {
    super.initState();

    slideAnimationController = new AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

    _updateAnimation();

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

    return GestureDetector(
      onHorizontalDragStart: onDragStart,
      onHorizontalDragDown: onDragDown,
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
      onHorizontalDragCancel: onDragCancel,
      onTap: onTap,
      child: SlideTransition(
          position: slideAnimation,
          child: widget.child,
      ),
    );
  }

  void _updateAnimation() {
    slideAnimation = slideAnimationController.drive(Tween<Offset>(
      begin: Offset.zero,
      end: Offset(_dragExtent.sign, 0.0),
    ));
  }
}
