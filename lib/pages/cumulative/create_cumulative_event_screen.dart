import 'package:flutter/material.dart';
import 'package:flutter_time/constant/time_event_constant.dart';
import 'package:flutter_time/model/base/models.dart';
import 'package:flutter_time/pages/count_down/create_count_down_event_screen.dart';
import 'package:flutter_time/pages/time_event_list_page.dart';
import 'package:flutter_time/ui/animation/animation_column_2.dart';
import 'package:flutter_time/ui/common_ui.dart';
import 'package:flutter_time/ui/count_down/count_down_item.dart';
import 'package:flutter_time/util/time_utils.dart';
import 'package:flutter_time/value/colors.dart';
import 'package:flutter_time/value/strings.dart';

const CREATE_CUMULATIVE_EVENT = 'create_cumulative_event';

class CreateCumulativeEventScreen extends StatefulWidget {

  @override
  _CreateCumulativeEventScreenState createState() => _CreateCumulativeEventScreenState();
}

class _CreateCumulativeEventScreenState extends State<CreateCumulativeEventScreen> {

  TimeEventModelChangeNotifier modelNotifier;

  @override
  void initState() {
    super.initState();

    modelNotifier = TimeEventModelChangeNotifier(TimeEventModel(
      color: bgColorList[0].value,
      title: '',
      remark: '',
      startTime: TimeUtils.getTodayStartTime().millisecondsSinceEpoch,
      endTime: -1,
      type: TimeEventType.cumulativeDay.index,
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
        title: Text(CREATE_CUMULATIVE_TIME_EVENT),
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

  void handleTapStartTime(int timestamp) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.fromMillisecondsSinceEpoch(timestamp),
      firstDate: DateTime(2000,),
      lastDate: TimeUtils.getTodayStartTime(),
    );
    if (selectedDate != null) {
      onStartTimeChanged(selectedDate.millisecondsSinceEpoch);
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
    modelNotifier.startTime = timestamp;
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
