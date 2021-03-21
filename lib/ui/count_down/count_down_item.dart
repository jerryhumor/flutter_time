import 'package:flutter/material.dart';
import 'package:flutter_time/constant/time_event_constant.dart';
import 'package:flutter_time/model/base/models.dart';
import 'package:flutter_time/ui/common_ui.dart';

// 时间事件的条目
class CountDownItem extends StatefulWidget {

  /// 序号
  final int index;
  /// 数据
  final TimeEventModel model;

  CountDownItem({this.index, this.model,});

  @override
  _CountDownItemState createState() => _CountDownItemState();
}

class _CountDownItemState extends State<CountDownItem> with SingleTickerProviderStateMixin {

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
    Navigator.of(context).pushNamed('count_down_detail', arguments: {
      'model': widget.model,
    });
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

    final Color textColor = Theme.of(context).colorScheme.secondary;
    final Widget item = buildItem(context, textColor);

    return GestureDetector(
      onHorizontalDragStart: onDragStart,
      onHorizontalDragDown: onDragDown,
      onHorizontalDragUpdate: onDragUpdate,
      onHorizontalDragEnd: onDragEnd,
      onHorizontalDragCancel: onDragCancel,
      onTap: onTap,
      child: SlideTransition(
        position: slideAnimation,
        child: item
      ),
    );
  }

  /// 创建背景
  Widget _buildBackground(int color, String tag) {
    Widget background =  Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Color(color),
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
    if (tag != null && tag.isNotEmpty) {
      background = Hero(
        tag: tag,
        child: background,
      );
    }
    return background;
  }

  /// 创建内容
  Widget _buildContent(TimeEventModel model, String tag, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: <Widget>[
          /// 包含标题 类型信息的row
          TitleRow(title: model.title, type: model.type, titleHeroTag: tag, textColor: textColor,),
          /// 间隔
          SizedBox(height: 8.0,),
          /// 包含日期信息的row
          model.type == TimeEventType.countDownDay.index
              ? CountDownDetail(startTime: model.startTime, endTime: model.endTime,)
              : CumulativeDetail(),
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, Color textColor) {
    return SizedBox(
      width: double.infinity,
      height: 122,
      child: Stack(
        children: <Widget>[
          _buildBackground(widget.model.color, null),
          _buildContent(widget.model, null, textColor),
        ],
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

class CountDownItemClipper extends CustomClipper<Rect> {

  // 偏移量 负数为剪切左边 正数为剪切右边
  Animation<Offset> slideAnimation;

  CountDownItemClipper(this.slideAnimation);

  @override
  Rect getClip(Size size) {
    final double offset = slideAnimation.value.dx * size.width;
    if (offset == 0) {
      return Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    } else if (offset < 0) {
      return Rect.fromLTRB(0.0 - offset, 0.0, size.width, size.height);
    } else {
      return Rect.fromLTRB(0.0, 0.0, size.width - offset, size.height);
    }

  }

  @override
  bool shouldReclip(CountDownItemClipper oldClipper) {
    return oldClipper.slideAnimation.value != slideAnimation.value;
  }

}