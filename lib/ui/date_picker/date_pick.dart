import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time/ui/common_ui.dart';
import 'package:flutter_time/ui/date_picker/date_picker_theme.dart';
import 'package:flutter_time/util/time_utils.dart';

typedef DateSelectedCallback = void Function(Day day);

class DatePicker extends StatefulWidget {

  final String title;
  final DateTime initialDate;
  final DateTime startDate;
  final DateTime endDate;

  DatePicker({
    this.title = '',
    this.initialDate,
    @required this.startDate,
    @required this.endDate,
  });

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {

  Day selectedDay;

  @override
  void initState() {
    super.initState();
    DateTime initialDate = widget.initialDate ?? DateTime.now();
    selectedDay = Day(year: initialDate.year, month: initialDate.month, day: initialDate.day,);
  }

  @override
  Widget build(BuildContext context) {

    DatePickerThemeData theme = DatePickerTheme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 48.0),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        color: theme.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            children: [
              Text(widget.title, style: theme.titleStyle,),
              SizedBox(height: 16.0,),
              Expanded(
                child: MonthPicker(
                  initialDate: widget.initialDate,
                  startDate: widget.startDate,
                  endDate: widget.endDate,
                  callback: onDaySelected,
                ),
              ),
              buildButtonBar(theme),
            ],
          ),
        ),
      ),
    );
  }

  /// 底部按钮
  Widget buildButtonBar(DatePickerThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16,),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onTap: onCancel,
            backgroundColor: theme.secondaryBackgroundColor,
            text: '取消',
            textStyle: theme.secondaryButtonStyle,
            borderRadius: BorderRadius.circular(24),
            constraints: BoxConstraints.tightFor(
              width: 100,
              height: 40,
            ),
          ),
          TextButton(
            onTap: onConfirm,
            backgroundColor: theme.primaryBackgroundColor,
            text: '确定',
            textStyle: theme.primaryButtonStyle,
            borderRadius: BorderRadius.circular(24),
            constraints: BoxConstraints.tightFor(
              width: 100,
              height: 40,
            ),
          ),
        ],
      ),
    );
  }

  void onDaySelected(Day day) {
    selectedDay = day;
  }

  void onConfirm() {
    Navigator.pop(context, DateTime(selectedDay.year, selectedDay.month, selectedDay.day));
  }

  void onCancel() {
    Navigator.pop(context);
  }

}

class MonthPicker extends StatefulWidget {

  final DateTime initialDate;
  final DateTime startDate;
  final DateTime endDate;
  final DateSelectedCallback callback;
  
  MonthPicker({this.initialDate, this.startDate, this.endDate, this.callback,});

  @override
  _MonthPickerState createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthPicker> {

  PageController controller;

  ValueNotifier<Day> selectedDayNotifier;

  /// 记录上一次选中的月份和本地选中的月份
  DateTime lastMonth;
  ValueNotifier<DateTime> currentMonthNotifier;

  @override
  void initState() {
    super.initState();
    initDay();
    controller = PageController(initialPage: selectedMonthIndex);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Day get selectedDay => selectedDayNotifier.value;

  DateTime get currentMonth => currentMonthNotifier.value;

  void initDay() {
    /// 赋值默认选中的日期
    DateTime now = DateTime.now();
    DateTime initialDate = widget.initialDate ?? now;
    selectedDayNotifier = ValueNotifier(Day(
      year: initialDate.year,
      month: initialDate.month,
      day: initialDate.day,
      today: now.day == widget.initialDate.day && now.month == widget.initialDate.month && now.year == widget.initialDate.year,
      enable: false,
    ));

    /// 赋值选中的月份
    lastMonth = widget.initialDate ?? now;
    currentMonthNotifier = ValueNotifier(lastMonth);
  }

  DayPage generateDayPage(int year, int month,) {
    DateTime now = DateTime.now();
    List<Day> previousMonthDayList = generatePreviousMonthDay(year, month, now,);
    List<Day> thisMonthDayList = generateThisMonthDay(year, month, now,);
    List<Day> nextMonthDayList = generateNextMonthDay(
      year,
      month,
      42 - previousMonthDayList.length - thisMonthDayList.length,
      now,
    );

    List<Day> dayList = [];
    dayList.addAll(previousMonthDayList.reversed);
    dayList.addAll(thisMonthDayList);
    dayList.addAll(nextMonthDayList);
    return DayPage(
      year: year,
      month: month,
      dateList: dayList,
    );
  }

  /// 生成上一个月的日期列表
  List<Day> generatePreviousMonthDay(int year, int month, DateTime today) {
    final DateTime firstTime = DateTime(year, month, 1);
    if (firstTime.weekday == 7) return [];
    List<Day> dayList = [];
    int previousMonthDay = firstTime.weekday;
    DateTime previousMonth = TimeUtils.getPreviousMonth(year, month);
    int previousDayCount = TimeUtils.getMonthDayCount(year, previousMonth.month);
    for (int i = 0; i < previousMonthDay; i++) {
      dayList.add(Day(
        year: previousMonth.year,
        month: previousMonth.month,
        day: previousDayCount - i,
        today: today.day == i && today.month == previousMonth.month && today.year == previousMonth.year,
        enable: false,
      ));
    }
    return dayList;
  }

  /// 生成本月的日期列表
  List<Day> generateThisMonthDay(int year, int month, DateTime today,) {
    final int dayCount = TimeUtils.getMonthDayCount(year, month);
    int start = (widget.startDate.month == month && widget.startDate.year == year) ? widget.startDate.day : 0;
    int end = (widget.endDate.month == month && widget.endDate.year == year) ? widget.endDate.day : 32;
    List<Day> dayList = [];
    for (int i = 1; i <= dayCount; i++) {
      dayList.add(Day(
        year: year,
        month: month,
        day: i,
        today: today.day == i && today.month == month && today.year == year,
        enable: i >= start && i <= end,
      ));
    }
    return dayList;
  }

  /// 生成下一个月的日期列表
  List<Day> generateNextMonthDay(int year, int month, int count, DateTime today) {
    DateTime nextMonth = TimeUtils.getNextMonth(year, month);
    List<Day> dayList = [];
    for (int i = 1; i <= count; i++) {
      dayList.add(Day(
        year: nextMonth.year,
        month: nextMonth.month,
        day: i,
        today: today.day == i && today.month == nextMonth.month && today.year == nextMonth.year,
        enable: false,
      ));
    }
    return dayList;
  }

  int get monthCount {
    return (widget.endDate.year - widget.startDate.year) * 12 + widget.endDate.month - widget.startDate.month + 1;
  }

  int get selectedMonthIndex {
    return (selectedDay.year - widget.startDate.year) * 12 + selectedDay.month - widget.startDate.month;
  }

  Widget buildDayPageWidget(BuildContext context, int index) {
    DateTime dateTime = DateTime(widget.startDate.year, widget.startDate.month + index);
    DayPage dayPage = generateDayPage(dateTime.year, dateTime.month);
    return DayPageWidget(
      selectedDay: selectedDay,
      dayPage: dayPage,
      onDateSelected: onDaySelected,
    );
  }

  Widget buildDayPageView() {
    return ValueListenableBuilder<Day>(
      valueListenable: selectedDayNotifier,
      builder: (context, value, child) {
        return PageView.builder(
          controller: controller,
          itemCount: monthCount,
          physics: BouncingScrollPhysics(),
          itemBuilder: buildDayPageWidget,
          onPageChanged: (index) {
            DateTime date = DateTime(widget.startDate.year, widget.startDate.month + index);
            onMonthChanged(date.year, date.month);
          },
        );
      },
    );
  }

  /// 选中的月份
  Widget buildSelectedMonth(DatePickerThemeData theme) {

    return ValueListenableBuilder<DateTime>(
      valueListenable: currentMonthNotifier,
      builder: (context, value, child) {
        bool reverse = currentMonth.isBefore(lastMonth);
        return PageTransitionSwitcher(
          reverse: reverse,
          child: Text('${value.month}月 ${value.year}', key: ValueKey(value), style: theme.tagTitleStyle,),
          transitionBuilder: (child, animation, secondaryAnimation) {
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
              fillColor: theme.backgroundColor,
            );
          },
        );
      },
    );
  }

  /// 选中的日期
  Widget buildSelectedDate(DatePickerThemeData theme) {
    return ValueListenableBuilder(
      valueListenable: selectedDayNotifier,
      builder: (context, value, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('${value.year}年${value.month}月${value.day}日', style: theme.displayDateStyle,),
            TextButton(
              textStyle: theme.tagTitleStyle,
              text: '今天',
              constraints: BoxConstraints.tightFor(
                width: 50,
                height: 24,
              ),
              backgroundColor: theme.secondaryBackgroundColor,
              borderRadius: BorderRadius.circular(6.0),
              onTap: onTapToday,
            ),
          ],
        );
      },
    );
  }

  void onTapToday() {
    DateTime now = DateTime.now();
    final index =  (now.year - widget.startDate.year) * 12 + now.month - widget.startDate.month;
    controller.animateToPage(index, duration: Duration(milliseconds: 600), curve: Curves.decelerate,);
  }

  /// 月份改变的回调
  void onMonthChanged(int year, int month) {
    if (currentMonth.year == year && currentMonth.month == month) return;
    lastMonth = currentMonth;
    currentMonthNotifier.value = DateTime(year, month);
  }

  /// 周几的标签
  Widget buildWeekTitle(DatePickerThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text('周日', style: theme.tagTitleStyle,),
        Text('周一', style: theme.tagTitleStyle,),
        Text('周二', style: theme.tagTitleStyle,),
        Text('周三', style: theme.tagTitleStyle,),
        Text('周四', style: theme.tagTitleStyle,),
        Text('周五', style: theme.tagTitleStyle,),
        Text('周六', style: theme.tagTitleStyle,),
      ],
    );
  }

  /// 日期改变的回调
  void onDaySelected(Day day) {
    selectedDayNotifier.value = day;
    widget.callback?.call(day);
  }

  @override
  Widget build(BuildContext context) {

    DatePickerThemeData theme = DatePickerTheme.of(context);

    return Column(
      children: [
        buildSelectedDate(theme),
        SizedBox(height: 10.0,),
        buildSelectedMonth(theme),
        SizedBox(height: 8.0,),
        buildWeekTitle(theme),
        Expanded(
          child: buildDayPageView(),
        ),
      ],
    );
  }
}

class DayPageWidget extends StatelessWidget {

  final Day selectedDay;
  final DayPage dayPage;
  final DateSelectedCallback onDateSelected;

  DayPageWidget({this.selectedDay, this.dayPage, this.onDateSelected,});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: dayPage.dateList
          .map(
            (e) => DayWidget(
              day: e,
              selected: (e.day == selectedDay.day) &&
                  (e.month == selectedDay.month) &&
                  (e.year == selectedDay.year),
              onDateSelected: onDateSelected,
            ),
          )
          .toList(),
    );
  }
}

class Day {

  int year;
  int month;
  int day;

  bool today;
  bool enable;

  Day({this.year, this.month, this.day, this.today, this.enable,});

}

class DayPage {
  final int year;
  final int month;
  final List<Day> dateList;

  DayPage({this.year, this.month, this.dateList,});
}

const double _kDayWidgetSize = 60;
const Duration _kSelectDuration = Duration(milliseconds: 300);

class DayWidget extends StatefulWidget {
  final Day day;
  final bool selected;
  /// 日期选中的回调
  final DateSelectedCallback onDateSelected;

  DayWidget({this.day, this.selected, this.onDateSelected,});

  @override
  _DayWidgetState createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> with SingleTickerProviderStateMixin {

  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: _kSelectDuration);
    if (widget.day.enable && widget.selected) {
      controller.value = 1;
    } else {
      controller.value = 0;
    }
  }

  @override
  void didUpdateWidget(DayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    changeSelectedStatus(oldWidget.selected, widget.selected);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  /// 改变选中状态
  void changeSelectedStatus(bool oldStatus, bool newStatus) {
    if (oldStatus == newStatus) return;
    if (newStatus)
      controller.forward();
    else
      controller.reverse();
  }

  /// 处理点击事件
  void handleTapDay() {
    if (widget.onDateSelected == null) return;
    if (widget.selected || !widget.day.enable) return;
    widget.onDateSelected(widget.day);
  }

  @override
  Widget build(BuildContext context) {

    DatePickerThemeData theme = DatePickerTheme.of(context);
    Widget text = Text(
      '${widget.day.today ? '今' : widget.day.day}',
      style: widget.day.enable ? theme.dayStyle : theme.unableDayStyle,
    );

    return GestureDetector(
      onTap: handleTapDay,
      child: AnimatedBuilder(
        animation: controller,
        child: text,
        builder: (context, child) {
          return Container(
            width: _kDayWidgetSize,
            height: _kDayWidgetSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.selectedDayBackgroundColor.withOpacity(controller.value),
            ),
            child: Center(
              child: child,
            ),
          );
        },
      ),
    );
  }
}

Future<DateTime> showTimeDatePicker({
  BuildContext context,
  String title,
  DateTime initialDate,
  DateTime startDate,
  DateTime endDate,
}) {
  return showDialog<DateTime>(
    context: context,
    barrierDismissible: true,
    child: DatePickerTheme(
      child: DatePicker(
        title: title,
        initialDate: initialDate,
        startDate: startDate,
        endDate: endDate,
      ),
    ),
  );
}