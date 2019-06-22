import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/diagnostics.dart';
import 'package:flutter_time/test/my_dismissble.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TEST PAGE'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            MyDismissible(
              key: Key("key"),
              child: Container(
                color: Colors.transparent,
                child: ListTile(
                  title: Text('Dismissible'),
                  subtitle: Text('滑动删除控件'),
                ),
              ),
            ),
            Dismissible(
              key: ValueKey("key2"),
              child: Container(
                color: Colors.blueGrey,
                child: ListTile(
                  title: Text('Dismissible Origin'),
                  subtitle: Text('滑动删除控件原声'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ActionWrapItem extends StatefulWidget {

  final Widget child;

  ActionWrapItem({this.child});

  @override
  _ActionWrapItemState createState() => _ActionWrapItemState();
}

class _ActionWrapItemState extends State<ActionWrapItem> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  AnimationController _moveController;
  Animation<Offset> _moveAnimation;

  double _dragExtent = 0.0;

  @override
  void initState() {
    super.initState();
    _moveController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);

    _updateMoveAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: (details) {
        setState(() {
          _dragExtent = 0.0;
          _updateMoveAnimation();
        });
      },
      onHorizontalDragUpdate: (details) {
        if (_moveController.isAnimating) {
          print('update is animating, return');
        }
        _dragExtent += details.primaryDelta;
        setState(() {
          _updateMoveAnimation();
        });
      },
      child: SlideTransition(
        position: _moveAnimation,
        child: widget.child,
      ),
    );
  }

  void _updateMoveAnimation() {
    final end = _dragExtent.sign;
    _moveAnimation = _moveController.drive(
      Tween(
        begin: Offset.zero,
        end: Offset(end, 0)
      )
    );
    print('move animation: ${_moveAnimation.value}');
  }

  @override
  bool get wantKeepAlive => true;
}

