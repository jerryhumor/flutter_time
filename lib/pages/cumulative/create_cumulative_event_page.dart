import 'package:flutter/material.dart';
import 'package:flutter_time/constant/time_event_constant.dart';
import 'package:flutter_time/model/base/models.dart';
import 'package:flutter_time/pages/count_down/create_count_down_event_page.dart';
import 'package:flutter_time/pages/time_event_list_page.dart';
import 'package:flutter_time/ui/common_ui.dart';
import 'package:flutter_time/ui/count_down/count_down_item.dart';
import 'package:flutter_time/value/colors.dart';
import 'package:flutter_time/value/strings.dart';

class CreateCumulativeEventPage extends StatefulWidget {

  @override
  _CreateCumulativeEventPageState createState() => _CreateCumulativeEventPageState();
}

class _CreateCumulativeEventPageState extends State<CreateCumulativeEventPage> {

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
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          /// 分隔
          VerticalSeparator(18.0),
          /// 倒计日名称
          ValueListenableBuilder(
            valueListenable: modelNotifier.titleNotifier,
            builder: (context, value, child) => EventNameTile(
              name: value,
              hint: CUMULATIVE_EVENT_NAME,
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
              child: TimeEventItem(model: value,),
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
