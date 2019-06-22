import 'package:flutter/material.dart';

class PageContainer extends StatefulWidget {

  final Key key;
  final List<PageAnimation> children;
  final Duration duration;
  final int index;

  PageContainer({
    this.key,
    this.children = const <PageAnimation>[],
    this.duration = const Duration(milliseconds: 500),
    this.index = 0,
  }): super(key: key);

  @override
  PageContainerState createState() {
    print('create state');
    return PageContainerState();
  }
}

class PageContainerState extends State<PageContainer> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  int _currentPageIndex = 0 , _oldPageIndex = 0;

  @override
  void initState() {
    super.initState();
    print('init state, widget index: ${widget.index}');
    _currentPageIndex = widget.index;
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _controller.forward(from: 1.0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _currentPageIndex = widget.index;
    bool reverse = _oldPageIndex < _currentPageIndex;
    _oldPageIndex = _currentPageIndex;
    final PageAnimation pageAnimation  = widget.children[_currentPageIndex];
    Animation<double> fadeAnimation;
    Animation<Offset> slideAnimation;
    if (pageAnimation.fadeEnd != null && pageAnimation != null) {
      fadeAnimation = Tween(begin: pageAnimation.fadeStart, end: pageAnimation.fadeEnd).animate(_controller);
    }
    if (pageAnimation.positionStart != null && pageAnimation.positionEnd != null) {
      slideAnimation = Tween(begin: pageAnimation.positionStart, end: pageAnimation.positionEnd).animate(_controller);
    }
    Widget result = pageAnimation.child;
    if (slideAnimation != null) {
      result = SlideTransition(
        position: slideAnimation,
        child: result,
      );
    }
    if (fadeAnimation != null) {
      result = FadeTransition(
        opacity: fadeAnimation,
        child: result,
      );
    }
    
    return result;
  }

  @override
  void didUpdateWidget(PageContainer oldWidget) {
    _controller.forward(from: 0.0);
    super.didUpdateWidget(oldWidget);
  }
}

class PageAnimation {

  final double fadeStart, fadeEnd;
  final Offset positionStart, positionEnd;
  final Widget child;

  PageAnimation({
    this.fadeStart,
    this.fadeEnd,
    this.positionStart,
    this.positionEnd,
    this.child
  });
}