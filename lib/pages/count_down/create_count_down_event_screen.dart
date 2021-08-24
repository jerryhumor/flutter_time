import 'package:flutter/material.dart';
import 'package:flutter_time/constant/time_event_constant.dart';
import 'package:flutter_time/model/base/models.dart';
import 'package:flutter_time/themes/time_theme_data.dart';
import 'package:flutter_time/ui/animation/animation_column_2.dart';
import 'package:flutter_time/ui/common_ui.dart';
import 'package:flutter_time/ui/count_down/count_down_item.dart';
import 'package:flutter_time/ui/date_picker/date_pick.dart';
import 'package:flutter_time/util/time_utils.dart';
import 'package:flutter_time/value/colors.dart';
import 'package:flutter_time/value/strings.dart';

const CREATE_COUNT_DOWN_EVENT = 'create_count_down_event';

/// 创建倒计日事件页面
class CreateCountDownEventScreen extends StatefulWidget {
  @override
  _CreateCountDownEventScreenState createState() => _CreateCountDownEventScreenState();
}

class _CreateCountDownEventScreenState extends State<CreateCountDownEventScreen> with SingleTickerProviderStateMixin {

  TimeEventModelChangeNotifier modelNotifier;

  @override
  void initState() {
    super.initState();
    modelNotifier = TimeEventModelChangeNotifier(TimeEventModel(
      color: bgColorList[0].value,
      title: '',
      remark: '',
      startTime: TimeUtils.getTodayStartTime().millisecondsSinceEpoch,
      endTime: TimeUtils.getTodayEndTime().millisecondsSinceEpoch,
      type: TimeEventType.countDownDay.index,
    ));
  }

  @override
  void dispose() {
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
        child: AnimationColumn2(
          onAnimationFinished: showTitleEditDialog,
          fromState: ItemState.dismissed,
          toState: ItemState.completed,
          positionBegin: Offset(0.3, 0.0),
          crossAxisAlignment: CrossAxisAlignment.start,
          displayAnimationWhenInit: true,
          children: <Widget>[
            /// 分隔
            VerticalSeparator(18.0),
            /// 倒计日名称
            AnimationColumnItem(
              child: ValueListenableBuilder(
                valueListenable: modelNotifier.titleNotifier,
                builder: (context, value, child) => EventNameTile(
                  name: value,
                  hint: COUNT_DOWN_EVENT_NAME,
                  onTap: () => showTitleEditDialog(),
                ),
              ),
            ),
            /// 分隔
            VerticalSeparator(18.0),
            /// 起始日期
            AnimationColumnItem(
              child: ValueListenableBuilder(
                valueListenable: modelNotifier.startTimeNotifier,
                builder: (context, value, child) => StartDateTile(
                  startTime: value,
                  onTap: handleTapStartTime,
                ),
              ),
            ),
            /// 分隔
            VerticalSeparator(18.0),
            /// 目标日期
            AnimationColumnItem(
              child: ValueListenableBuilder(
                valueListenable: modelNotifier.endTimeNotifier,
                builder: (context, value, child) => TargetDateTile(
                  targetTime: value,
                  onTap: handleTapTargetTime,
                ),
              ),
            ),
            /// 分隔
            VerticalSeparator(18.0),
            /// 备注
            AnimationColumnItem(
              child: ValueListenableBuilder(
                valueListenable: modelNotifier.remarkNotifier,
                builder: (context, value, child) => RemarkTile(
                  remark: modelNotifier.remark,
                  onTap: () => showRemarkEditDialog()
                ),
              ),
            ),
            /// 分隔
            VerticalSeparator(18.0),
            /// 颜色选择条
            AnimationColumnItem(
              child: ValueListenableBuilder(
                valueListenable: modelNotifier.colorNotifier,
                builder: (context, value, child) => ColorSelectTile(
                  colorList: bgColorList,
                  selectedColor: Color(value),
                  colorChangedCallback: onColorChanged,
                ),
              ),
            ),
            /// 预览
            AnimationColumnItem(
              child: ValueListenableBuilder(
                valueListenable: modelNotifier.modelNotifier,
                builder: (context, value, child) {
                  return ItemPreview(
                    model: value,
                    onTap: handleTapSave,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 点击起始时间 显示dialog选择起始时间
  /// 起始时间最早2000年 最晚就是目标时间
  /// [timestamp] 上一个选定的起始时间
  void handleTapStartTime(int timestamp) async {
    final selectedDate = await showTimeDatePicker(
      context: context,
      title: '选择起始日',
      initialDate: DateTime.fromMillisecondsSinceEpoch(timestamp),
      startDate: DateTime(2000,),
      endDate: DateTime.fromMillisecondsSinceEpoch(modelNotifier.endTimeNotifier.value),
    );
    if (selectedDate != null) {
      onStartTimeChanged(selectedDate.millisecondsSinceEpoch);
    }
  }

  void handleTapTargetTime(int timestamp) async {
    final selectedDate = await showTimeDatePicker(
      context: context,
      title: '选择目标日',
      initialDate: DateTime.fromMillisecondsSinceEpoch(timestamp),
      startDate: DateTime.fromMillisecondsSinceEpoch(modelNotifier.startTimeNotifier.value),
      endDate: DateTime(2030),
    );
    if (selectedDate != null) {
      onTargetTimeChanged(selectedDate.millisecondsSinceEpoch);
    }
  }

  void handleTapSave() {
    Navigator.pop(context, modelNotifier.model);
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
    final DateTime start = TimeUtils.getStartTime(DateTime.fromMillisecondsSinceEpoch(timestamp));
    modelNotifier.startTime = start.millisecondsSinceEpoch;
  }

  void onTargetTimeChanged(int timestamp) {
    final DateTime end = TimeUtils.getEndTime(DateTime.fromMillisecondsSinceEpoch(timestamp));
    modelNotifier.endTime = end.millisecondsSinceEpoch;
  }

  void showTitleEditDialog() async {
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

  void showRemarkEditDialog() async {
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

class ItemPreview extends StatelessWidget {
  
  final TimeEventModel model;
  final VoidCallback onTap;

  ItemPreview({
    this.model,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    final Color previewColor = Theme.of(context).colorScheme.primary.withOpacity(0.7);
    final TextStyle previewStyle = TimeTheme.editItemContentStyle.apply(color: previewColor,);
    final bool canSave = model.title != null && model.title.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(PREVIEW_EFFECT, style: previewStyle,),
          SizedBox(height: 8.0,),
          TimeEventItem(model: model,),
          SizedBox(height: 30.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                text: SAVE,
                textStyle: TextStyle(
                  color: Colors.white,
                ),
                constraints: BoxConstraints.tightFor(
                  width: 66,
                  height: 30,
                ),
                backgroundColor: canSave ? colorBlue2 : Color(0xFFDEDEDE),
                borderRadius: BorderRadius.circular(18.0),
                onTap: canSave ? onTap : null,
              ),
            ],
          ),
        ],
      ),
    );
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
