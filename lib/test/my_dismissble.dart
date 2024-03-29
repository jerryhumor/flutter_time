// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

const Curve _kResizeTimeCurve = Interval(0.4, 1.0, curve: Curves.ease);
const double _kMinFlingVelocity = 700.0;
const double _kMinFlingVelocityDelta = 400.0;
const double _kFlingVelocityScale = 1.0 / 300.0;
const double _kDismissThreshold = 0.4;

/// Signature used by [MyDismissible] to indicate that it has been dismissed in
/// the given `direction`.
///
/// Used by [MyDismissible.onDismissed].
typedef DismissDirectionCallback = void Function(MyDismissDirection direction);

/// Signature used by [MyDismissible] to give the application an opportunity to
/// confirm or veto a dismiss gesture.
///
/// Used by [MyDismissible.confirmDismiss].
typedef ConfirmDismissCallback = Future<bool> Function(MyDismissDirection direction);

/// The direction in which a [MyDismissible] can be dismissed.
enum MyDismissDirection {
  /// The [MyDismissible] can be dismissed by dragging in the reverse of the
  /// reading direction (e.g., from right to left in left-to-right languages).
  endToStart,

  /// The [MyDismissible] can be dismissed by dragging in the reading direction
  /// (e.g., from left to right in left-to-right languages).
  startToEnd,
}

enum EventItemAction {
  // 从右往左滑的时间 删除事件
  delete,
  // 从左往右滑的事件 归档事件
  archive,
}

/// A widget that can be dismissed by dragging in the indicated [direction].
///
/// Dragging or flinging this widget in the [MyDismissDirection] causes the child
/// to slide out of view. Following the slide animation, if [resizeDuration] is
/// non-null, the Dismissible widget animates its height (or width, whichever is
/// perpendicular to the dismiss direction) to zero over the [resizeDuration].
///
/// {@youtube 560 315 https://www.youtube.com/watch?v=iEMgjrfuc58}
///
/// Backgrounds can be used to implement the "leave-behind" idiom. If a background
/// is specified it is stacked behind the Dismissible's child and is exposed when
/// the child moves.
///
/// The widget calls the [onDismissed] callback either after its size has
/// collapsed to zero (if [resizeDuration] is non-null) or immediately after
/// the slide animation (if [resizeDuration] is null). If the Dismissible is a
/// list item, it must have a key that distinguishes it from the other items and
/// its [onDismissed] callback must remove the item from the list.
class MyDismissible extends StatefulWidget {
  /// Creates a widget that can be dismissed.
  ///
  /// The [key] argument must not be null because [MyDismissible]s are commonly
  /// used in lists and removed from the list when dismissed. Without keys, the
  /// default behavior is to sync widgets based on their index in the list,
  /// which means the item after the dismissed item would be synced with the
  /// state of the dismissed item. Using keys causes the widgets to sync
  /// according to their keys and avoids this pitfall.
  const MyDismissible({
    @required Key key,
    @required this.child,
    this.confirmDismiss,
    this.onResize,
    this.onDismissed,
    this.resizeDuration = const Duration(milliseconds: 300),
    this.dismissThresholds = const <MyDismissDirection, double>{
      MyDismissDirection.startToEnd: 0.05,
      MyDismissDirection.endToStart: 0.05
    },
    this.movementDuration = const Duration(milliseconds: 300),
    this.crossAxisEndOffset = 0.0,
    this.dragStartBehavior = DragStartBehavior.start,
  }) : assert(key != null),
        assert(dragStartBehavior != null),
        super(key: key);

  /// The widget below this widget in the tree.
  ///
  /// {@macro flutter.widgets.child}
  final Widget child;
  /// Gives the app an opportunity to confirm or veto a pending dismissal.
  ///
  /// If the returned Future<bool> completes true, then this widget will be
  /// dismissed, otherwise it will be moved back to its original location.
  ///
  /// If the returned Future<bool> completes to false or null the [onResize]
  /// and [onDismissed] callbacks will not run.
  final ConfirmDismissCallback confirmDismiss;

  /// Called when the widget changes size (i.e., when contracting before being dismissed).
  final VoidCallback onResize;

  /// Called when the widget has been dismissed, after finishing resizing.
  final DismissDirectionCallback onDismissed;

  /// The amount of time the widget will spend contracting before [onDismissed] is called.
  ///
  /// If null, the widget will not contract and [onDismissed] will be called
  /// immediately after the widget is dismissed.
  final Duration resizeDuration;

  /// The offset threshold the item has to be dragged in order to be considered
  /// dismissed.
  ///
  /// Represented as a fraction, e.g. if it is 0.4 (the default), then the item
  /// has to be dragged at least 40% towards one direction to be considered
  /// dismissed. Clients can define different thresholds for each dismiss
  /// direction.
  ///
  /// Flinging is treated as being equivalent to dragging almost to 1.0, so
  /// flinging can dismiss an item past any threshold less than 1.0.
  ///
  /// See also [direction], which controls the directions in which the items can
  /// be dismissed. Setting a threshold of 1.0 (or greater) prevents a drag in
  /// the given [MyDismissDirection] even if it would be allowed by the
  /// [direction] property.
  final Map<MyDismissDirection, double> dismissThresholds;

  /// Defines the duration for card to dismiss or to come back to original position if not dismissed.
  final Duration movementDuration;

  /// Defines the end offset across the main axis after the card is dismissed.
  ///
  /// If non-zero value is given then widget moves in cross direction depending on whether
  /// it is positive or negative.
  final double crossAxisEndOffset;

  /// Determines the way that drag start behavior is handled.
  ///
  /// If set to [DragStartBehavior.start], the drag gesture used to dismiss a
  /// dismissible will begin upon the detection of a drag gesture. If set to
  /// [DragStartBehavior.down] it will begin when a down event is first detected.
  ///
  /// In general, setting this to [DragStartBehavior.start] will make drag
  /// animation smoother and setting it to [DragStartBehavior.down] will make
  /// drag behavior feel slightly more reactive.
  ///
  /// By default, the drag start behavior is [DragStartBehavior.start].
  ///
  /// See also:
  ///
  ///  * [DragGestureRecognizer.dragStartBehavior], which gives an example for the different behaviors.
  final DragStartBehavior dragStartBehavior;

  @override
  _MyDismissibleState createState() => _MyDismissibleState();
}

enum _FlingGestureKind { none, forward, reverse }

enum _TimeEventFlingGestureKind {
  // 回归正常
  none,
  // 显示归档按钮
  archive,
  // 显示删除按钮
  delete,
}

class _MyDismissibleState extends State<MyDismissible> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(duration: widget.movementDuration, vsync: this)
      ..addStatusListener(_handleDismissStatusChanged);
    _updateMoveAnimation();
  }

  AnimationController _moveController;
  Animation<Offset> _moveAnimation;

  AnimationController _resizeController;
  Animation<double> _resizeAnimation;

  double _dragExtent = 0.0;
  // 是否正在拖动
  bool _dragUnderway = false;
  Size _sizePriorToCollapse;

  @override
  bool get wantKeepAlive => _moveController?.isAnimating == true || _resizeController?.isAnimating == true;

  @override
  void dispose() {
    _moveController.dispose();
    _resizeController?.dispose();
    super.dispose();
  }

  MyDismissDirection _extentToDirection(double extent) {
    if (extent == 0.0)
      return null;
    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        return extent < 0 ? MyDismissDirection.startToEnd : MyDismissDirection
            .endToStart;
      case TextDirection.ltr:
        return extent > 0 ? MyDismissDirection.startToEnd : MyDismissDirection
            .endToStart;
    }
    return null;
  }

  MyDismissDirection get _dismissDirection => _extentToDirection(_dragExtent);

  bool get _isActive {
    return _dragUnderway || _moveController.isAnimating;
  }

  double get _overallDragAxisExtent {
    final Size size = context.size;
    return size.width;
  }

  void _handleDragStart(DragStartDetails details) {
    _dragUnderway = true;
    if (_moveController.isAnimating) {
      // 计算当前的滑动值 controller.value 表示滑动的百分比 0.0-1.0 _overallDragAxisExtent 表示宽度 _dragExtent.sign表示正负
      _dragExtent = _moveController.value * _overallDragAxisExtent * _dragExtent.sign;
      _moveController.stop();
    } else {
      _dragExtent = 0.0;
      _moveController.value = 0.0;
    }
    setState(() {
      _updateMoveAnimation();
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_isActive || _moveController.isAnimating)
      return;

    // 往右滑就是正值 往左滑就是赋值
    final double delta = details.primaryDelta;
    final double oldDragExtent = _dragExtent;
    final EventItemAction action = _confirmSlideAction(oldDragExtent);
    switch (action) {
      case EventItemAction.archive:
        _handleArchiveAction(delta, oldDragExtent);
        break;
      case EventItemAction.delete:
        _handleDeleteAction(delta, oldDragExtent);
        break;
    }
//    print('primary delta: $delta, _drag extent: $_dragExtent, old sign: ${oldDragExtent.sign}, sing: ${_dragExtent.sign}');
    if (oldDragExtent.sign != _dragExtent.sign) {
      setState(() {
        _updateMoveAnimation();
      });
    }
  }

  // 判断当前是归档事件还是删除事件
  EventItemAction _confirmSlideAction(double oldDragExtent) {
    return oldDragExtent > 0 ? EventItemAction.archive : EventItemAction.delete;
  }

  // 处理删除事件滑动操作
  void _handleDeleteAction(double delta, double oldDragExtent) {
    final damp = _judgeDeleteDamp(oldDragExtent);
    _dragExtent += delta * damp;
    if (!_moveController.isAnimating) {
      _moveController.value = _dragExtent.abs() / _overallDragAxisExtent;
    }
  }

  // 处理归档事件滑动操作
  void _handleArchiveAction(double delta, double oldDragExtent) {
    final damp = _judgeArchiveDamp(oldDragExtent);
    _dragExtent += delta * damp;
    if (!_moveController.isAnimating) {
      final currentControllerValue = _dragExtent.abs() / _overallDragAxisExtent;
      if (delta > 0 && currentControllerValue > 0.6) {
        _dragExtent = 0.9 * _overallDragAxisExtent;
        if (_moveController.value < 0.9) {
          _moveController.animateTo(0.9, duration: const Duration(milliseconds: 300), curve: Curves.easeOutQuint);
        }
      } else {
        _moveController.value = currentControllerValue;
      }
    }
  }

  double _judgeDeleteDamp(double dragExtent) {
    final double dragWidth = dragExtent.abs();
    return (dragWidth > (0.5 * _overallDragAxisExtent)) ? 0.1 : 1.0;
  }

  double _judgeArchiveDamp(double dragExtent) {
    return 1.0;
  }

  // 因为左右滑动有可能改变方向
  // 向左滑出界 然后不放 转向 向右滑 需要改变offset的end
  void _updateMoveAnimation() {
    final double end = _dragExtent.sign;
    _moveAnimation = _moveController.drive(
      Tween<Offset>(
        begin: Offset.zero,
        end: Offset(end, widget.crossAxisEndOffset),
      ),
    );
  }

  _FlingGestureKind _describeFlingGesture(Velocity velocity) {
    if (_dragExtent == 0.0) {
      // If it was a fling, then it was a fling that was let loose at the exact
      // middle of the range (i.e. when there's no displacement). In that case,
      // we assume that the user meant to fling it back to the center, as
      // opposed to having wanted to drag it out one way, then fling it past the
      // center and into and out the other side.
      return _FlingGestureKind.none;
    }
    final double vx = velocity.pixelsPerSecond.dx;
    final double vy = velocity.pixelsPerSecond.dy;
    MyDismissDirection flingDirection;
    // Verify that the fling is in the generally right direction and fast enough.
    if (vx.abs() - vy.abs() < _kMinFlingVelocityDelta || vx.abs() < _kMinFlingVelocity)
      return _FlingGestureKind.none;
    assert(vx != 0.0);
    flingDirection = _extentToDirection(vx);
    assert(_dismissDirection != null);
    if (flingDirection == _dismissDirection)
      return _FlingGestureKind.forward;
    return _FlingGestureKind.reverse;
  }

  _TimeEventFlingGestureKind _describeTimeEventFlingGesture(Velocity velocity) {
    if (_dragExtent == 0.0) {
      // If it was a fling, then it was a fling that was let loose at the exact
      // middle of the range (i.e. when there's no displacement). In that case,
      // we assume that the user meant to fling it back to the center, as
      // opposed to having wanted to drag it out one way, then fling it past the
      // center and into and out the other side.
      return _TimeEventFlingGestureKind.none;
    }
    final double vx = velocity.pixelsPerSecond.dx;
    final double vy = velocity.pixelsPerSecond.dy;
    MyDismissDirection flingDirection;
    // Verify that the fling is in the generally right direction and fast enough.
    if (vx.abs() - vy.abs() < _kMinFlingVelocityDelta || vx.abs() < _kMinFlingVelocity)
      return _TimeEventFlingGestureKind.none;
    assert(vx != 0.0);
    flingDirection = _extentToDirection(vx);
    assert(_dismissDirection != null);
    if (flingDirection == _dismissDirection)
      return _TimeEventFlingGestureKind.archive;
    return _TimeEventFlingGestureKind.delete;
  }

  Future<void> _handleDragEnd(DragEndDetails details) async {
    if (!_isActive || _moveController.isAnimating)
      return;
    _dragUnderway = false;
    if (_moveController.isCompleted && await _confirmStartResizeAnimation() == true) {
      _startResizeAnimation();
      return;
    }
    final double flingVelocity = details.velocity.pixelsPerSecond.dx;
    switch (_describeTimeEventFlingGesture(details.velocity)) {
      case _TimeEventFlingGestureKind.archive:
        print('in case archive');
        _moveController.animateTo(0.2, duration: const Duration(milliseconds: 200), curve: Curves.easeOutQuint);
        _dragExtent = 0.2 * _overallDragAxisExtent;
        break;
      case _TimeEventFlingGestureKind.delete:
        print('in case delete');
        _moveController.animateTo(0.2, duration: const Duration(milliseconds: 200), curve: Curves.easeOutQuint);
        _dragExtent = -0.2 * _overallDragAxisExtent;
        break;
      case _TimeEventFlingGestureKind.none:
        print('in case none');
        _moveController.reverse();
        break;
    }
//    switch (_describeFlingGesture(details.velocity)) {
//      case _FlingGestureKind.forward:
//        assert(_dragExtent != 0.0);
//        assert(!_moveController.isDismissed);
//        if ((widget.dismissThresholds[_dismissDirection] ?? _kDismissThreshold) >= 1.0) {
//          _moveController.reverse();
//          break;
//        }
//        _dragExtent = flingVelocity.sign;
//        _moveController.fling(velocity: flingVelocity.abs() * _kFlingVelocityScale);
//        break;
//      case _FlingGestureKind.reverse:
//        assert(_dragExtent != 0.0);
//        assert(!_moveController.isDismissed);
//        _dragExtent = flingVelocity.sign;
//        _moveController.fling(velocity: -flingVelocity.abs() * _kFlingVelocityScale);
//        break;
//      case _FlingGestureKind.none:
//        if (!_moveController.isDismissed) { // we already know it's not completed, we check that above
//          if (_moveController.value > (widget.dismissThresholds[_dismissDirection] ?? _kDismissThreshold)) {
//            _moveController.forward();
//          } else {
//            _moveController.reverse();
//          }
//        }
//        break;
//    }
  }

  Future<void> _handleDismissStatusChanged(AnimationStatus status) async {
    if (status == AnimationStatus.completed && !_dragUnderway) {
      if (await _confirmStartResizeAnimation() == true)
        _startResizeAnimation();
      else
        _moveController.reverse();
    }
    updateKeepAlive();
  }

  Future<bool> _confirmStartResizeAnimation() async {
    if (widget.confirmDismiss != null) {
      final MyDismissDirection direction = _dismissDirection;
      assert(direction != null);
      return widget.confirmDismiss(direction);
    }
    return true;
  }

  void _startResizeAnimation() {
    assert(_moveController != null);
    assert(_moveController.isCompleted);
    assert(_resizeController == null);
    assert(_sizePriorToCollapse == null);
    if (widget.resizeDuration == null) {
      if (widget.onDismissed != null) {
        final MyDismissDirection direction = _dismissDirection;
        assert(direction != null);
        widget.onDismissed(direction);
      }
    } else {
      _resizeController = AnimationController(duration: widget.resizeDuration, vsync: this)
        ..addListener(_handleResizeProgressChanged)
        ..addStatusListener((AnimationStatus status) => updateKeepAlive());
      _resizeController.forward();
      setState(() {
        _sizePriorToCollapse = context.size;
        _resizeAnimation = _resizeController.drive(
          CurveTween(
              curve: _kResizeTimeCurve
          ),
        ).drive(
          Tween<double>(
            begin: 1.0,
            end: 0.0,
          ),
        );
      });
    }
  }

  void _handleResizeProgressChanged() {
    if (_resizeController.isCompleted) {
      if (widget.onDismissed != null) {
        final MyDismissDirection direction = _dismissDirection;
        assert(direction != null);
        widget.onDismissed(direction);
      }
    } else {
      if (widget.onResize != null)
        widget.onResize();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // See AutomaticKeepAliveClientMixin.

    assert(debugCheckHasDirectionality(context));

    Widget slideItem = SlideTransition(
      position: _moveAnimation,
      child: widget.child,
    );
    Widget background;
    final MyDismissDirection direction = _dismissDirection;
    if (direction == MyDismissDirection.endToStart)
      background = DeleteActionBackground(
        position: _moveAnimation,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Icon(Icons.delete, color: Colors.red,),
        )
      );
    else
      background = ArchiveActionBackground(
        position: _moveAnimation,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Icon(Icons.archive, color: Colors.blue,),
        )
      );

    final List<Widget> children = <Widget>[];
    children
      ..add(Positioned.fill(child: background))
      ..add(slideItem);
    Widget content = Stack(children: children,);

    // We are not resizing but we may be being dragging in widget.direction.
    return GestureDetector(
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      behavior: HitTestBehavior.opaque,
      child: content,
      dragStartBehavior: widget.dragStartBehavior,
    );
  }
}

class ArchiveActionBackground extends AnimatedWidget {

  final Widget child;

  const ArchiveActionBackground({
    Key key,
    @required Animation<Offset> position,
    this.child
  }) : super(key: key, listenable: position);

  Animation<Offset> get position => listenable;

  @override
  Widget build(BuildContext context) {
    Offset originOffset = position.value;
    Offset offset = Offset(originOffset.dx - 0.65, originOffset.dy);
    print('build archive background, origin: $originOffset, offset: $offset');
    return FractionalTranslation(
      translation: offset,
      child: child,
    );
  }
}

class DeleteActionBackground extends AnimatedWidget {

  final Widget child;

  const DeleteActionBackground({
    Key key,
    @required Animation<Offset> position,
    this.child
  }) : super(key: key, listenable: position);

  Animation<Offset> get position => listenable;

  @override
  Widget build(BuildContext context) {
    Offset originOffset = position.value;
    Offset offset = Offset(originOffset.dx + 0.65, originOffset.dy);
    final double size = 24.0 * (originOffset.dx.abs() >= 0.2 ? 1.0 : originOffset.dx.abs() * 5);
    return FractionalTranslation(
      translation: offset,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle
          ),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
