import 'package:flutter/material.dart';
import 'package:flutter_time/constant/time_event_constant.dart';
import 'package:flutter_time/model/base/models.dart';
import 'package:flutter_time/pages/time_event_list_page.dart';
import 'package:flutter_time/ui/animation_column.dart';
import 'package:flutter_time/ui/common_ui.dart';
import 'package:flutter_time/ui/count_down/count_down_item.dart';
import 'package:flutter_time/util/time_utils.dart';
import 'package:flutter_time/value/colors.dart';
import 'package:flutter_time/value/strings.dart';

/// 创建倒计日事件页面
class CreateCountDownEventPage extends StatefulWidget {
  @override
  _CreateCountDownEventPageState createState() => _CreateCountDownEventPageState();
}

class _CreateCountDownEventPageState extends State<CreateCountDownEventPage> with SingleTickerProviderStateMixin {

  AnimationController controller;
  TimeEventModelChangeNotifier modelNotifier;

  @override
  void initState() {
    super.initState();
    final DateTime dateTime = DateTime.now();
    modelNotifier = TimeEventModelChangeNotifier(TimeEventModel(
      color: bgColorList[0].value,
      title: '',
      remark: '',
      startTime: dateTime.millisecondsSinceEpoch,
      endTime: dateTime.millisecondsSinceEpoch,
      type: TimeEventType.countDownDay.index,
    ));
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    modelNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(CREATE_COUNT_DOWN_TIME_EVENT),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: AnimationColumn(
          fadeStart: 0.0,
          fadeEnd: 1.0,
          positionStart: Offset(0.2, 0.0),
          positionEnd: Offset.zero,
          controller: controller,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /// 分隔
            VerticalSeparator(18.0),
            /// 倒计日名称
            ValueListenableBuilder(
              valueListenable: modelNotifier.titleNotifier,
              builder: (context, value, child) => EventNameTile(
                name: value,
                hint: COUNT_DOWN_EVENT_NAME,
                onTap: () => showTitleEditDialog(context),
              ),
            ),
            /// 分隔
            VerticalSeparator(18.0),
            /// 起始日期
            ValueListenableBuilder(
              valueListenable: modelNotifier.startTimeNotifier,
              builder: (context, value, child) => StartDateTile(
                startTime: value,
                onTap: handleTapStartTime,
              ),
            ),
            /// 分隔
            VerticalSeparator(18.0),
            /// 目标日期
            ValueListenableBuilder(
              valueListenable: modelNotifier.endTimeNotifier,
              builder: (context, value, child) => TargetDateTile(
                targetTime: value,
                onTap: handleTapTargetTime,
              ),
            ),
            /// 分隔
            VerticalSeparator(18.0),
            /// 备注
            ValueListenableBuilder(
              valueListenable: modelNotifier.remarkNotifier,
              builder: (context, value, child) => RemarkTile(
                remark: modelNotifier.remark,
                onTap: () => showRemarkEditDialog(context)
              ),
            ),
            /// 分隔
            VerticalSeparator(18.0),
            /// 颜色选择条
            ValueListenableBuilder(
              valueListenable: modelNotifier.colorNotifier,
              builder: (context, value, child) => ColorSelectTile(
                colorList: bgColorList,
                selectedColor: Color(value),
                colorChangedCallback: onColorChanged,
              ),
            ),
            /// 分隔
            VerticalSeparator(18.0),
            /// 预览效果
            Padding(padding: const EdgeInsets.only(left: 16.0), child: Text(PREVIEW_EFFECT),),
            VerticalSeparator(8.0),
            ValueListenableBuilder<TimeEventModel>(
              valueListenable: modelNotifier.modelNotifier,
              builder: (context, value, child) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: CountDownItem(model: value,),
              ),
            ),
            VerticalSeparator(8.0),
            /// 分割
            SizedBox(height: 8.0,),
            /// 保存按钮
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  text: SAVE,
                  textStyle: TextStyle(
                    color: Colors.white,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 12.0),
                  backgroundColor: colorBlue2,
                  borderRadius: BorderRadius.circular(12.0),
                  onTap: () {
                    final EventWrap eventWrap = EventWrap(
                      TimeEventOrigin.add,
                      modelNotifier.model,
                    );
                    Navigator.pop(context, eventWrap);
                  },
                ),
                SizedBox(width: 8.0,),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void handleTapStartTime(int timestamp) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.fromMillisecondsSinceEpoch(timestamp),
      firstDate: DateTime(2000,),
      lastDate: DateTime(2030),
    );
    if (selectedDate != null) {
      onStartTimeChanged(selectedDate.millisecondsSinceEpoch);
    }
  }

  void handleTapTargetTime(int timestamp) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.fromMillisecondsSinceEpoch(timestamp),
      firstDate: DateTime(2000,),
      lastDate: DateTime(2030),
    );
    if (selectedDate != null) {
      onTargetTimeChanged(selectedDate.millisecondsSinceEpoch);
    }
  }

  void onTitleChanged(String title) {
    if (title != null && title.isNotEmpty) {
      modelNotifier.title = title;
    }
  }

  void onColorChanged(Color color) {
    if (modelNotifier.color == color.value) return;
    modelNotifier.color = color.value;
  }

  void onStartTimeChanged(int timestamp) {
    modelNotifier.startTime = timestamp;
  }

  void onTargetTimeChanged(int timestamp) {
    modelNotifier.endTime = timestamp;
  }

  void showTitleEditDialog(BuildContext context) async {
    final String text = await showDialog(
      context: context,
      builder: (context) {
        return EditDialog(
          title: COUNT_DOWN_EVENT_NAME,
          maxLength: 30,
          text: modelNotifier.title,
          autoFocus: true,
        );
      },
    );
    if (text != null && text.isNotEmpty) {
      modelNotifier.title = text;
    }
  }

  void showRemarkEditDialog(BuildContext context) async {
    final String text = await showDialog(
      context: context,
      builder: (context) {
        return EditDialog(
          title: REMARK,
          maxLength: 30,
          text: modelNotifier.remark,
          autoFocus: true,
        );
      },
    );
    if (text != null && text.isNotEmpty) {
      modelNotifier.remark = text;
    }
  }
}

class TimeEventModelChangeNotifier {

  TimeEventModel model;

  ValueNotifier<TimeEventModel> modelNotifier;
  ValueNotifier<int> colorNotifier;
  ValueNotifier<String> titleNotifier;
  ValueNotifier<String> remarkNotifier;
  ValueNotifier<int> startTimeNotifier;
  ValueNotifier<int> endTimeNotifier;

  TimeEventModelChangeNotifier(TimeEventModel model) {
    this.model = model;
    modelNotifier = ValueNotifier(model);
    colorNotifier = ValueNotifier(model.color);
    titleNotifier = ValueNotifier(model.title);
    remarkNotifier = ValueNotifier(model.remark);
    startTimeNotifier = ValueNotifier(model.startTime);
    endTimeNotifier = ValueNotifier(model.endTime);
  }

  int get color {
    return model.color;
  }

  set color(int value) {
    model.color = value;
    colorNotifier.value = value;
    modelNotifier.notifyListeners();
  }

  String get title {
    return model.title;
  }

  set title(String value) {
    model.title = value;
    titleNotifier.value = value;
    modelNotifier.notifyListeners();
  }

  String get remark {
    return model.remark;
  }

  set remark(String value) {
    model.remark = value;
    remarkNotifier.value = value;
    modelNotifier.notifyListeners();
  }

  int get startTime {
    return model.startTime;
  }

  set startTime(int value) {
    model.startTime = value;
    startTimeNotifier.value = value;
    modelNotifier.notifyListeners();
  }

  int get endTime {
    return model.endTime;
  }

  set endTime(int value) {
    model.endTime = value;
    endTimeNotifier.value = value;
    modelNotifier.notifyListeners();
  }

  void dispose() {
    modelNotifier.dispose();
    colorNotifier.dispose();
    titleNotifier.dispose();
    remarkNotifier.dispose();
    startTimeNotifier.dispose();
    endTimeNotifier.dispose();
  }
}
