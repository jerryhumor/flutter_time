import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time/constant/time_constants.dart';
import 'package:flutter_time/constant/time_event_constant.dart';
import 'package:flutter_time/model/base/models.dart';
import 'package:flutter_time/themes/time_theme_data.dart';
import 'package:flutter_time/util/hero_utils.dart';
import 'package:flutter_time/util/text_utils.dart';
import 'package:flutter_time/util/time_utils.dart';
import 'package:flutter_time/value/colors.dart';
import 'package:flutter_time/value/strings.dart';
import 'package:flutter_time/value/styles.dart';

// 时间事件的条目
abstract class ITimeEventItem {
  TimeEventModel getModel();
}

class TitleRow extends StatelessWidget {

  final String title;
  final int type;
  final Object heroTag;
  final Color textColor;

  TitleRow({this.title, this.type, this.heroTag, this.textColor,});

  @override
  Widget build(BuildContext context) {

    final String defaultTitle = type == TimeEventType.countDownDay.index
        ? COUNT_DOWN_DAY
        : CUMULATIVE_DAY;
    final Widget label = type == TimeEventType.countDownDay.index
        ? TimeEventTypeLabel.small(label: COUNT_DOWN_DAY, heroTag: heroTag,)
        : TimeEventTypeLabel.small(label: CUMULATIVE_DAY, heroTag: heroTag,);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /// 标题和类型
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 标题
            TimeEventTitle(
              title: (title != null && title.isNotEmpty) ? title : defaultTitle,
              textColor: textColor,
            ),
            /// 间距
            SizedBox(height: 6.0,),
            /// 类型
            label,
          ],
        ),
        // 查看详情
        ViewDetailLabel()
      ],
    );
  }
}

/// 累计日具体信息
class CumulativeDetail extends StatelessWidget {

  final int startTime;
  final Object heroTag;

  CumulativeDetail({this.startTime, this.heroTag,}): assert (startTime != null);

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    final Color color = theme.colorScheme.onBackground;
    final dateStyle = TimeTheme.smallTextStyle.apply(color: color.withOpacity(0.5),);
    final labelStyle = TimeTheme.tinyTextStyle.apply(color: color.withOpacity(0.4),);

    /// 其实就是(x / y).toInt()
    int day = (DateTime.now().millisecondsSinceEpoch - startTime) ~/ DAY_TIME_MILLIS;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        /// 起始日
        buildStartDate(dateStyle),
        /// 可伸缩的间隔
        Spacer(),
        Column(
          children: [
            /// 已过天数label
            Text(PASS_DAY, style: labelStyle,),
            /// 间隔
            /// 已过天数数字
            DayText(day: day, textColor: color, heroTag: heroTag,),
          ],
        ),
      ],
    );
  }

  Widget buildStartDate(TextStyle style) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0.0),
      child: Text(
        '起始日: ${TimeUtils.millis2String(startTime, FORMAT_YYYY_MM_DD)}',
        style: style,
      ),
    );
  }
}

/// 倒计日具体信息
class CountDownDetail extends StatelessWidget {

  final int startTime, endTime;
  final Object heroTag;

  CountDownDetail({
    this.startTime,
    this.endTime,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {

    final Color textColor = Theme.of(context).colorScheme.secondary;
    final int totalDay = (endTime - startTime) ~/ DAY_TIME_MILLIS;
    final int passDay = (DateTime.now().millisecondsSinceEpoch - startTime) ~/ DAY_TIME_MILLIS;
    final int remainDay = max(totalDay - passDay, 0);
    final String targetDay = TimeUtils.millis2String(endTime, FORMAT_YYYY_MM_DD);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        /// 左边的进度和目标日
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /// 倒计日的倒计时文字
            TimeEventPassText(totalDay: totalDay, passDay: passDay, textColor: textColor,),
            /// 分割
            SizedBox(height: 2.0,),
            /// 倒计日的倒计时进度条
            TimeEventPassProgress(totalDay: totalDay, passDay: passDay,),
            /// 分割
            SizedBox(height: 2.0,),
            /// 目标日
            TargetDay(targetDay: targetDay, textColor: textColor,),
          ],
        ),
        /// 剩余天数 或者 已过天数
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            /// 标志 剩余天数 已过天数
            RemainingDayLabel(textColor: textColor,),
            /// 日期文字
            DayText(day: remainDay, textColor: textColor, isLarge: false, heroTag: heroTag,),
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

    final color = TimeTheme.getTitleColor(context);
    final style = TimeTheme.tinyTextStyle.apply(color: color);

    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: color,)
      ),
      child: Text(
        VIEW_DETAIL,
        style: style,
      ),
    );
  }
}

// 剩余天数标志
class RemainingDayLabel extends StatelessWidget {

  final Color textColor;

  RemainingDayLabel({this.textColor,});

  @override
  Widget build(BuildContext context) {

    final textStyle = TimeTheme.tinyTextStyle.apply(color: textColor.withOpacity(0.5));

    return Text(
      REMAINING_DAY,
      style: textStyle,
    );
  }
}

// 已过天数标志
class PassDayLabel extends StatelessWidget {

  final Color textColor;
  
  PassDayLabel({this.textColor,});

  @override
  Widget build(BuildContext context) {
    
    final textStyle = timeEventItemDayLabelTextStyle.apply(color: textColor);
    
    return Text(
      PASS_DAY,
      style: textStyle,
    );
  }
}

// 时间事件类型label
class TimeEventTypeLabel extends StatelessWidget {

  final String label;
  final double radius;
  final Object heroTag;
  final TextStyle style;
  final double width;
  final double height;

  TimeEventTypeLabel({
    this.width,
    this.height,
    this.label,
    this.radius,
    this.heroTag,
    this.style,
  });

  TimeEventTypeLabel.normal({
    String label,
    Object heroTag,
  }) :
        width = 84.0,
        height = 32.0,
        radius = 8.0,
        style = TimeTheme.normalTextStyle,
        label = label,
        heroTag = heroTag;

  TimeEventTypeLabel.small({
    String label,
    Object heroTag,
  }) :
        width = 38.0,
        height = 14.0,
        radius = 4.0,
        style = TimeTheme.minimumTextStyle,
        label = label,
        heroTag = heroTag;

  @override
  Widget build(BuildContext context) {

    ThemeData theme = Theme.of(context);
    TextStyle textStyle = style.apply(
      color: theme.colorScheme.onBackground,
      decoration: TextDecoration.none,
    );

    /// 文字部分
    Widget text = Text(label, style: textStyle,);
    text = wrapHeroText('label-text-$heroTag', text);

    Widget bg = Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        color: textStyle.color.withOpacity(0.4),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
    bg = wrapHero('label-bg-$heroTag', bg);

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          /// 背景
          bg,
          /// 文字
          Center(child: text,),
        ],
      ),
    );
    return text;
  }
}

// 已过天数label
class TimeEventPassText extends StatelessWidget {

  final int totalDay, passDay;
  final Color textColor;

  TimeEventPassText({this.totalDay, this.passDay, this.textColor,});

  @override
  Widget build(BuildContext context) {
    
    final textStyle = TimeTheme.tinyTextStyle.apply(color: textColor.withOpacity(0.5));
    
    return Text(
      '$PASS:$passDay/$totalDay',
      style: textStyle,
    );
  }
}

const _kProgressWidth = 100.0;
const _kProgressHeigth = 5.0;

// 目标日已过进度条
class TimeEventPassProgress extends StatelessWidget {

  final double width, height;

  final int totalDay;
  final int passDay;

  TimeEventPassProgress({
    this.width = _kProgressWidth,
    this.height = _kProgressHeigth,
    this.totalDay,
    this.passDay,
  });

  @override
  Widget build(BuildContext context) {

    final double _progressWidth =
      passDay >= totalDay ? 1.0 * width : passDay * width / totalDay;

    final ThemeData theme = Theme.of(context);
    final Color background = theme.colorScheme.secondaryVariant;
    final Color onBackground = theme.colorScheme.secondary;

    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: colorWhiteTransparent,
        borderRadius: BorderRadius.circular(3.0)
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: _progressWidth,
            decoration: BoxDecoration(
              color: onBackground,
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

  final String targetDay;
  final Color textColor;

  TargetDay({this.targetDay = '', this.textColor,});

  @override
  Widget build(BuildContext context) {
    
    final textStyle = TimeTheme.smallTextStyle.apply(color: textColor.withOpacity(0.5));
    
    return Text(
      '$TARGET_DAY:$targetDay',
      style: textStyle,
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

  final int day;
  final Color textColor;
  final bool isLarge;
  final Object heroTag;

  DayText({this.day, this.textColor, this.isLarge = false, this.heroTag,});

  @override
  Widget build(BuildContext context) {

    final textStyle = isLarge
        ? TimeTheme.dayStyle1.apply(color: textColor, decoration: TextDecoration.none,)
        : TimeTheme.dayStyle2.apply(color: textColor, decoration: TextDecoration.none,);

    Widget text = Text(
      '$day',
      style: textStyle,
    );
    text = wrapHeroText('day-$heroTag', text);
    return text;
  }
}

// 标题
class TimeEventTitle extends StatelessWidget {

  final String title;
  final Color textColor;

  TimeEventTitle({this.title, this.textColor,});

  @override
  Widget build(BuildContext context) {

    final textStyle = timeEventItemTitleTextStyle.apply(color: textColor);

    return Text(
      title,
      style: textStyle,
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
        ? theme.colorScheme.secondaryVariant
        : theme.colorScheme.primary;
    final TextStyle textStyle = TimeTheme.editItemTitleStyle.apply(color: textColor,);
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

  final int startTime;
  final void Function(int timestamp) onTap;

  StartDateTile({this.startTime, this.onTap,});

  @override
  Widget build(BuildContext context) {
    return EventEditItem(
      icon: Icons.today,
      title: START_DATE,
      content: TimeUtils.millis2String(startTime, FORMAT_YYYY_MM_DD),
      onTap: () {
        if (onTap != null) onTap(startTime);
      },
    );
  }
}

// 目标日期编辑条目
class TargetDateTile extends StatelessWidget {

  final int targetTime;
  final void Function(int timestamp) onTap;

  TargetDateTile({this.targetTime, this.onTap,});

  @override
  Widget build(BuildContext context) {
    return EventEditItem(
      icon: Icons.event,
      title: TARGET_DATE,
      content: TimeUtils.millis2String(targetTime, FORMAT_YYYY_MM_DD),
      onTap: () {
        if (onTap != null) onTap(targetTime);
      },
    );
  }
}

// 备注编辑条目
class RemarkTile extends StatelessWidget {

  final String remark;
  final VoidCallback onTap;

  RemarkTile({this.remark, this.onTap,});

  @override
  Widget build(BuildContext context) {
    return EventEditItem(
      icon: Icons.date_range,
      title: REMARK,
      content: (remark != null && remark.isNotEmpty) ? remark : '无',
      onTap: onTap,
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
        width: 24.0,
        height: 24.0,
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

  final String title;
  final String subTitle;
  final Color bgColor;
  final VoidCallback onTap;

  EventTypeItem({this.title, this.subTitle, this.bgColor, this.onTap,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
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
                  title,
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
                  subTitle,
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
    _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final checkedColor = theme.colorScheme.primaryVariant;
    final uncheckedColor = theme.colorScheme.secondaryVariant;

    return GestureDetector(
      onTap: () {
        _playAnimation();
        _vibrate();
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

  void _vibrate() {
    HapticFeedback.lightImpact();
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

  Widget counter(BuildContext context, {
        int currentLength,
        int maxLength,
        bool isFocused,
      }) {
    return null;
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

class EventEditItem extends StatelessWidget {

  final IconData icon;
  final String title;
  final String content;
  final VoidCallback onTap;

  EventEditItem({this.icon, this.title, this.content, this.onTap,});

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
    final Color bgColor = theme.colorScheme.onBackground;
    final Color titleColor = theme.colorScheme.primary;
    final Color dateColor = theme.colorScheme.primary.withOpacity(0.7);

    final TextStyle titleStyle = TimeTheme.editItemTitleStyle.apply(color: titleColor,);
    final TextStyle dateStyle = TimeTheme.editItemContentStyle.apply(color: dateColor,);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 60,
        color: bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Icon(icon, size: 24, color: titleColor,),
            SizedBox(width: 10.0,),
            Text(title, style: titleStyle,),
            Spacer(),
            Text(content, style: dateStyle,),
          ],
        ),
      ),
    );
  }
}
