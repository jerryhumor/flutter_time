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
    final PageAnimation oldPageAnimation = widget.children[_oldPageIndex];
    final PageAnimation newPageAnimation = widget.children[_currentPageIndex];
    bool reverse = _oldPageIndex < _currentPageIndex;
    _oldPageIndex = _currentPageIndex;

    Widget oldPage, newPage;
    Animation<double> oldFadeAnimation, newFadeAnimation;
    Animation<Offset> oldSlideAnimation, newSlideAnimation;
    if (oldPageAnimation.fadeEnd != null && oldPageAnimation != null) {
      oldFadeAnimation = Tween(begin: oldPageAnimation.fadeEnd, end: oldPageAnimation.fadeStart).animate(_controller);
    }
    if (oldPageAnimation.positionStart != null && oldPageAnimation.positionEnd != null) {
      oldSlideAnimation = Tween(begin: oldPageAnimation.positionEnd, end: oldPageAnimation.positionStart).animate(_controller);
    }
    if (newPageAnimation.fadeEnd != null && newPageAnimation != null) {
      newFadeAnimation = Tween(begin: newPageAnimation.fadeStart, end: newPageAnimation.fadeEnd).animate(_controller);
    }
    if (newPageAnimation.positionStart != null && newPageAnimation.positionEnd != null) {
      newSlideAnimation = Tween(begin: newPageAnimation.positionStart, end: newPageAnimation.positionEnd).animate(_controller);
    }
    oldPage = oldPageAnimation.child;
    if (oldSlideAnimation != null) {
      oldPage = SlideTransition(
        position: oldSlideAnimation,
        child: oldPage,
      );
    }
    if (oldFadeAnimation != null) {
      oldPage = FadeTransition(
        opacity: oldFadeAnimation,
        child: oldPage,
      );
    }
    newPage = newPageAnimation.child;
    if (newSlideAnimation != null) {
      newPage = SlideTransition(
        position: newSlideAnimation,
        child: newPage,
      );
    }
    if (newFadeAnimation != null) {
      newPage = FadeTransition(
        opacity: newFadeAnimation,
        child: newPage,
      );
    }

    Widget content;
    if (oldPage == null) {
      content = newPage;
    } else {
      content = Stack(children: [oldPage, newPage],);
    }
    
    return content;
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