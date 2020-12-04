import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_time/constant/time_event_constant.dart';
import 'package:flutter_time/value/colors.dart';
import 'package:flutter_time/value/strings.dart';
import 'package:flutter_time/value/styles.dart';

// 时间事件的条目
class TimeEventItem extends StatelessWidget {
  /// 背景颜色
  final Color bgColor;
  /// 事件类型
  final TimeEventType type;
  /// 事件标题
  final String title;
  /// 时间剩余
  final int day;
  /// 点击事件
  final VoidCallback onTap;

  TimeEventItem(this.bgColor, this.type, this.title, this.day, this.onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            children: <Widget>[
              // 包含标题 类型信息的row
              TitleRow(title: title, type: type.index),
              // 间隔
              SizedBox(height: 8.0,),
              // 包含日期信息的row
              TimeRow(type.index, null, null),
            ],
          ),
        ),
      ),
    );
  }
}

class TitleRow extends StatelessWidget {

  final String title;
  final int type;
  final String titleHeroTag;

  TitleRow({this.title, this.type, this.titleHeroTag});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // 标题和类型
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 标题
            TimeEventTitle(title),
            // 间距
            SizedBox(height: 6.0,),
            type == TimeEventType.countDownDay.index ?
              TimeEventTypeLabel.countDownDaySmall(heroTag: titleHeroTag,)
              : TimeEventTypeLabel.cumulativeDaySmall(heroTag: titleHeroTag,),
          ],
        ),
        // 查看详情
        ViewDetailLabel()
      ],
    );
  }
}

class TimeRow extends StatelessWidget {
  // 类型 倒计日 累计日
  final int type;
  // 开始时间和结束时间
  // 如果是累计日 则_endTime 为空
  final int startTime, endTime;

  TimeRow(this.type, this.startTime, this.endTime);

  @override
  Widget build(BuildContext context) {

    // todo 使用utils类计算好信息

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        // 左边的进度和目标日
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 累计日的倒计时文字
            type == TimeEventType.countDownDay.index ? TimeEventPassText(9, 1) : Container(),
            // 分割
            SizedBox(height: 2.0,),
            // 累计日的倒计时进度条
            type == TimeEventType.countDownDay.index ? TimeEventPassProgress(9, 1) : Container(),
            // 分割
            SizedBox(height: 2.0,),
            // 目标日
            TargetDay(null),
          ],
        ),
        // 剩余天数 或者 已过天数
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            // 标志 剩余天数 已过天数
            type == TimeEventType.countDownDay.index ? RemainingDayLabel() : PassDayLabel(),
            // 日期文字
            DayText(1),
          ],
        ),
      ],
    );
  }
}

// 时间条目的查看详情标志
class ViewDetailLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: Colors.white,)
      ),
      child: Text(
        VIEW_DETAIL,
        style: viewDetailTextStyle,
      ),
    );
  }
}

// 剩余天数标志
class RemainingDayLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      REMAINING_DAY,
      style: timeEventItemDayLabelTextStyle,
    );
  }
}

// 已过天数标志
class PassDayLabel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      PASS_DAY,
      style: timeEventItemDayLabelTextStyle,
    );
  }
}

// 时间事件类型label
class TimeEventTypeLabel extends StatelessWidget {

  final String label;
  final TextStyle labelTextStyle;
  final String heroTag;
  
  TimeEventTypeLabel(this.label, this.labelTextStyle, this.heroTag);
  
  TimeEventTypeLabel.countDownDaySmall({String heroTag}) : this.label = COUNT_DOWN_DAY, this.labelTextStyle = timeEventTypeLabelSmallTextStyle, this.heroTag = heroTag;
  TimeEventTypeLabel.countDownDayLarge({String heroTag}) : this.label = COUNT_DOWN_DAY, this.labelTextStyle = timeEventTypeLabelLargeTextStyle, this.heroTag = heroTag;

  TimeEventTypeLabel.cumulativeDaySmall({String heroTag}) : this.label = CUMULATIVE_DAY, this.labelTextStyle = timeEventTypeLabelSmallTextStyle, this.heroTag = heroTag;
  TimeEventTypeLabel.cumulativeDayLarge({String heroTag}) : this.label = CUMULATIVE_DAY, this.labelTextStyle = timeEventTypeLabelLargeTextStyle, this.heroTag = heroTag;

  @override
  Widget build(BuildContext context) {
    Widget labelWidget = _buildLabel();
    if (heroTag != null && heroTag.isNotEmpty) {
      labelWidget = Hero(
        tag: heroTag,
        child: labelWidget,
      );
    }
    return labelWidget;
  }

  Widget _buildLabel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 8.0),
      decoration: BoxDecoration(
        color: colorWhiteTransparent,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        label,
        style: labelTextStyle,
      ),
    );
  }
}

// 已过天数label
class TimeEventPassText extends StatelessWidget {

  final int _totalDay, _passDay;

  TimeEventPassText(this._totalDay, this._passDay);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$PASS$_passDay/$_totalDay',
      style: timeEventItemDayLabelTextStyle,
    );
  }
}

// 目标日已过进度条
class TimeEventPassProgress extends StatelessWidget {

  static final double PROGRESS_WIDTH = 100.0, PROGRESS_HEIGHT = 5.0;
  final int _totalDay;
  final int _passDay;

  TimeEventPassProgress(this._totalDay, this._passDay);

  @override
  Widget build(BuildContext context) {

    final double _progressWidth =
      _passDay >= _totalDay ? 1.0 * PROGRESS_WIDTH : _passDay * PROGRESS_WIDTH / _totalDay;

    return Container(
      height: PROGRESS_HEIGHT,
      width: PROGRESS_WIDTH,
      decoration: BoxDecoration(
        color: colorWhiteTransparent,
        borderRadius: BorderRadius.circular(3.0)
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: _progressWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(3.0),
            ),
          ),
        ],
      ),
    );
  }

}

// 目标日
class TargetDay extends StatelessWidget {

  final String _targetDay;

  TargetDay(this._targetDay);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$TARGET_DAY:$_targetDay',
      style: timeEventTargetDayTextStyle,
    );
  }
}

// 起始日
class StartDay extends StatelessWidget {

  final String _startDay;

  StartDay(this._startDay);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$START_DAY:$_startDay',
      style: timeEventTargetDayTextStyle,
    );
  }
}

// 剩余或已过天数日期文字
class DayText extends StatelessWidget {

  final int _day;

  DayText(this._day);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_day',
      style: timeEventItemDayTextStyle,
    );
  }
}

// 标题
class TimeEventTitle extends StatelessWidget {

  final String _title;

  TimeEventTitle(this._title);

  @override
  Widget build(BuildContext context) {
    return Text(
      _title,
      style: timeEventItemTitleTextStyle,
    );
  }
}

// 分隔条
class VerticalSeparator extends StatelessWidget {

  final double _height;

  VerticalSeparator(this._height);

  @override
  Widget build(BuildContext context) => SizedBox(height: _height,);
}


// 事件名称编辑条目
class EventNameTile extends StatelessWidget {

  final String name;
  final String hint;
  final VoidCallback onTap;

  EventNameTile({this.name, this.hint, this.onTap,});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isEmpty = name == null || name.isEmpty;
    final String text = isEmpty ? hint : name;
    final textColor = isEmpty
        ? theme.colorScheme.secondary
        : theme.colorScheme.primary;
    final TextStyle textStyle = TextStyle(color: textColor, fontSize: 18.0,);
    return Material(
      color: theme.colorScheme.onBackground,
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          title: Text(
            text,
            style: textStyle,
          ),
        )
      ),
    );
  }
}

// 起始日期编辑条目
class StartDateTile extends StatelessWidget {

  final String _startTime;
  final VoidCallback _onTap;

  StartDateTile(this._startTime, this._onTap);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Theme.of(context).colorScheme.onBackground;
    return Container(
      color: backgroundColor,
      child: ListTile(
        leading: Image.asset(
          'images/time_event_start_time.png',
          height: 24.0,
          width: 24.0,
        ),
        title: Text(START_DATE),
        trailing: Text(_startTime),
        onTap: _onTap,
      ),
    );
  }
}

// 目标日期编辑条目
class TargetDateTile extends StatelessWidget {

  final String _targetTime;
  final VoidCallback _onTap;

  TargetDateTile(this._targetTime, this._onTap);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Theme.of(context).colorScheme.onBackground;
    return Container(
      color: backgroundColor,
      child: ListTile(
        leading: Image.asset(
          'images/time_event_target_time.png',
          height: 24.0,
          width: 24.0,
        ),
        title: Text(TARGET_DATE),
        trailing: Text(_targetTime),
        onTap: _onTap,
      ),
    );
  }
}

// 备注编辑条目
class RemarkTile extends StatelessWidget {

  final String _remark;
  final VoidCallback _onTap;

  RemarkTile(this._remark, this._onTap);

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Theme.of(context).colorScheme.onBackground;
    return Container(
      color: backgroundColor,
      child: ListTile(
        leading: Image.asset(
          'images/time_event_remark.png',
          height: 24.0,
          width: 24.0,
        ),
        title: Text(REMARK),
        trailing: Text(_remark),
        onTap: _onTap,
      ),
    );
  }
}

// 颜色选择条目
class ColorSelectTile extends StatelessWidget {

  final List<Color> colorList;
  final Color selectedColor;
  final void Function(Color color) colorChangedCallback;

  ColorSelectTile({
    @required this.colorList,
    this.selectedColor,
    this.colorChangedCallback,
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Theme.of(context).colorScheme.onBackground;
    return Container(
      height: 70.0,
      color: backgroundColor,
      child: ListView.separated(
        padding: const EdgeInsets.all(10.0),
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => SizedBox(width: 10.0,),
        itemCount: colorList.length,
        itemBuilder: (context, index) {
          final Color itemColor = colorList[index];
          return ColorSelectItem(
              color: itemColor,
              selected: selectedColor == itemColor,
              colorCallback: colorChangedCallback,
          );
        },
      ),
    );
  }


}

// 颜色选择Item
class ColorSelectItem extends StatelessWidget {

  final Color color;
  final bool selected;
  final void Function(Color color) colorCallback;

  ColorSelectItem({this.color, this.selected, this.colorCallback,});

  @override
  Widget build(BuildContext context) {
    final BoxBorder border = selected
        ? Border.all(width: 1.0, color: Theme.of(context).colorScheme.primary,)
        : null;
    return GestureDetector(
      onTap: () {
        if (colorCallback != null) colorCallback(this.color);
      },
      child: Container(
        margin: const EdgeInsets.all(7.0),
        padding: const EdgeInsets.all(1.0),
        width: 20.0,
        height: 20.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: border,
        ),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }
}

// 创建事件类型选择Item
class EventTypeItem extends StatelessWidget {

  final String _title;
  final String _subTitle;
  final Color _bgColor;
  final VoidCallback _onTap;

  EventTypeItem(this._title, this._subTitle, this._bgColor, this._onTap);

  EventTypeItem.countDownDay(this._onTap) :
        this._title = COUNT_DOWN_TYPE_ITEM_TITLE,
        this._subTitle = COUNT_DOWN_TYPE_ITEM_SUB_TITLE,
        this._bgColor = colorRed1;
  EventTypeItem.cumulativeDay(this._onTap) :
        this._title = CUMULATIVE_TYPE_ITEM_TITLE,
        this._subTitle = CUMULATIVE_TYPE_ITEM_SUB_TITLE,
        this._bgColor = colorBlue1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        decoration: BoxDecoration(
          color: _bgColor,
          borderRadius: BorderRadius.circular(16.0)
        ),
        margin: const EdgeInsets.symmetric(horizontal: 28.0),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // 主标题和副标题
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 主标题
                Text(
                  _title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                // 分隔
                SizedBox(height: 4.0,),
                // 副标题
                Text(
                  _subTitle,
                  style: TextStyle(
                    color: colorWhiteTransparent,
                    fontSize: 14.0,
                  ),
                )
              ],
            ),
            // 向右的箭头
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
            )
          ],
        ),
      ),
    );
  }
}

class FlutterTimeAppBar extends AppBar {

  FlutterTimeAppBar({
    String title,
    bool centerTitle = true,
    Color backgroundColor,
    List<Widget> actions,
  }) : super(
    title: AppBarTitle(title),
    centerTitle: centerTitle,
    backgroundColor: colorAppBarBg,
    actions: actions,
  );

}

/// appbar的标题
class AppBarTitle extends StatelessWidget {

  final String _title;

  AppBarTitle(this._title);

  @override
  Widget build(BuildContext context) {
    return Text(
      _title ?? '',
      style: appBarTitleTextStyle,
    );
  }
}

// 首页底部 BottomBarItem 按钮
class PageButton extends StatefulWidget {

  final Duration duration;
  final Size size;
  final VoidCallback onTap;
  final bool checked;
  // 一定要添加这个背景颜色 不知道为什么 container不添加背景颜色 不能撑开
  final Color backgroundColor;
  final EdgeInsetsGeometry padding;
  final IconData icon;

  const PageButton({
    this.duration = const Duration(milliseconds: 200),
    this.size = const Size(40.0, 40.0),
    this.onTap,
    @required this.icon,
    this.checked = false,
    this.backgroundColor = Colors.transparent,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  _PageButtonState createState() => _PageButtonState();
}

class _PageButtonState extends State<PageButton> with TickerProviderStateMixin {

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = PageButtonTween(turningPoint: 0.8).animate(_controller);
    // 一开始不播放动画 直接显示原始大小
    _controller.forward(from: 1.0);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    /// TODO 重新定义 uncheckedColor
    final ThemeData theme = Theme.of(context);
    final checkedColor = theme.colorScheme.primaryVariant;
    final uncheckedColor = theme.colorScheme.secondaryVariant;

    return GestureDetector(
      onTap: () {
        _playAnimation();
        if (widget.onTap != null) {
          widget.onTap();
        }
      },
      child: Container(
        constraints: BoxConstraints(minWidth: widget.size.width, minHeight: widget.size.height),
        color: widget.backgroundColor,
        padding: widget.padding,
        child: Center(
          child: ScaleTransition(
            scale: _animation,
            child: Icon(
              widget.icon,
              color: widget.checked ? checkedColor : uncheckedColor,
            ),
          ),
        ),
      ),
    );
  }

  void _playAnimation() {
    _controller.forward(from: 0.0);
  }
}

class PageButtonTween extends Animatable<double> {

  /// 转折点 也就是最低点
  final double turningPoint;

  PageButtonTween({this.turningPoint = 0.5,});

  @override
  double transform(double t) {

    if (t <= 0) return 1.0;
    if (t >= 1) return 1.0;
    if (t == 0.5) return turningPoint;

    final double difference = 1 - turningPoint;
    double value;
    if (t < 0.5) {
      value = 1 - difference * 2 * t;
    } else {
      value = turningPoint + (t - 0.5) * 2 * difference;
    }
    return value;
  }

}

/// 倒计日或者累计日页面的保存按钮
class SaveButton extends StatelessWidget {

  final VoidCallback onPressed;


  SaveButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: colorBluePrimary,
        ),
        child: Text(
          '保存',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class EditDialog extends StatefulWidget {

  final String title;
  final String text;
  final int maxLength;
  final bool autoFocus;

  EditDialog({this.title, this.text, this.maxLength, this.autoFocus});

  @override
  _EditDialogState createState() => _EditDialogState();
}

class _EditDialogState extends State<EditDialog> {
  
  TextEditingController controller;
  ValueKey barrierKey = ValueKey('barrier');
  
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.text ?? null);
  }
  
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {

    return Stack(
      children: [
        /// 最下面的点击事件监听 点击空白处退出编辑
        GestureDetector(
          key: barrierKey,
          onTap: cancel,
          behavior: HitTestBehavior.translucent,
          child: SizedBox(height: double.infinity, width: double.infinity,),
        ),
        /// 靠底部的编辑框
        /// 添加[AnimatedPadding]是为了让键盘升起和下降的时候有一个动画
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 70),
            padding: MediaQuery.of(context).viewInsets,
            child: EditDialogField(
              title: widget.title,
              controller: controller,
              leftLength: widget.maxLength - controller.text.length,
              autoFocus: widget.autoFocus,
              onCancel: cancel,
              onSave: save,
            )
          ),
        ),
      ],
    );
  }

  void cancel() {
    Navigator.of(context).pop('');
  }

  void save() {
    Navigator.of(context).pop(controller.text);
  }
}

class EditDialogField extends StatelessWidget {

  final String title;
  final TextEditingController controller;
  final int leftLength;
  final bool autoFocus;
  final VoidCallback onSave;
  final VoidCallback onCancel;


  EditDialogField({
    this.title,
    this.controller,
    this.leftLength,
    this.autoFocus,
    this.onSave,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    final int lines = 4;

    final TextStyle titleTextStyle = TextStyle(
      color: theme.colorScheme.primary,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
    );
    final TextStyle countTextStyle = TextStyle(
      color: theme.colorScheme.secondaryVariant,
      fontSize: 18.0,
    );
    final TextStyle buttonTextStyle = TextStyle(
      color: theme.colorScheme.onBackground,
      fontSize: 18.0,
    );

    return Material(
      color: theme.colorScheme.background,
      borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
      child: Padding(
        padding: const EdgeInsets.only(left: 6.0, top: 6.0, right: 6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// 标题和剩余数量
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildTitle(title, titleTextStyle),
                buildCounter(leftLength, countTextStyle),
              ],
            ),
            VerticalSeparator(8.0),
            /// 编辑区域
            TextField(
              scrollPadding: const EdgeInsets.all(4.0),
              controller: controller,
              minLines: lines,
              maxLines: lines,
              maxLength: leftLength,
              autofocus: autoFocus,
              decoration: InputDecoration(
                filled: true,
                fillColor: theme.colorScheme.onBackground,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              ),
              buildCounter: counter,
            ),
            /// 底部按钮区域
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// 取消按钮
                TextButton(
                  text: CANCEL,
                  textStyle: buttonTextStyle,
                  contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
                  backgroundColor: theme.colorScheme.secondaryVariant,
                  borderRadius: BorderRadius.circular(4.0),
                  onTap: onCancel,
                ),
                /// 保存按钮
                TextButton(
                  text: SAVE,
                  textStyle: buttonTextStyle,
                  contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
                  backgroundColor: colorBlue2,
                  borderRadius: BorderRadius.circular(4.0),
                  onTap: onSave,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget counter(
      BuildContext context,
      {
        int currentLength,
        int maxLength,
        bool isFocused,
      }
      ) {
    return Container();
  }

  Widget buildTitle(String title, TextStyle textStyle) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: textStyle,
      ),
    );
  }

  Widget buildCounter(int leftCount, TextStyle textStyle) {
    return Padding(
      padding: const EdgeInsets.only(right: 4.0),
      child: Text(
        '${leftCount ?? 0}',
        style: textStyle,
      ),
    );
  }
}


class TextButton extends StatelessWidget {

  final String text;
  final Color backgroundColor;
  final TextStyle textStyle;
  final EdgeInsetsGeometry contentPadding;
  final BorderRadius borderRadius;
  final VoidCallback onTap;

  TextButton({
    this.text,
    this.textStyle,
    this.contentPadding,
    this.backgroundColor,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onTap,
      constraints: BoxConstraints(minWidth: 0, minHeight: 0),
      child: Container(
        padding: contentPadding,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: backgroundColor,
        ),
        child: Center(
          child: Text(text, style: textStyle,),
        ),
      ),
    );
  }
}
