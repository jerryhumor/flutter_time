import 'package:flutter/material.dart';
import 'package:flutter_time/constant/time_event_constant.dart';
import 'package:flutter_time/model/base/models.dart';
import 'package:flutter_time/pages/time_event_list_page.dart';
import 'package:flutter_time/ui/animation_column.dart';
import 'package:flutter_time/ui/common_ui.dart';
import 'package:flutter_time/value/colors.dart';
import 'package:flutter_time/value/strings.dart';

/// 创建倒计日事件页面
class CreateCountDownEventPage extends StatefulWidget {
  @override
  _CreateCountDownEventPageState createState() => _CreateCountDownEventPageState();
}

class _CreateCountDownEventPageState extends State<CreateCountDownEventPage> with SingleTickerProviderStateMixin {

  // todo 记录变量

  AnimationController controller;
  TimeEventModel model;

  @override
  void initState() {
    super.initState();
    model = TimeEventModel(
      color: bgColorList[0].value,
      title: '',
      remark: '默认备注',
      startTime: 0,
      endTime: 0,
      type: TimeEventType.countDownDay.index,
    );
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final Color eventColor = Color(model.color);
    final TimeEventType eventType = TimeEventType.countDownDay;

    return Scaffold(
      appBar: AppBar(
        title: Text(CREATE_COUNT_DOWN_TIME_EVENT),
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
            EventNameTile(
              name: model.title,
              hint: COUNT_DOWN_EVENT_NAME,
              onTap: () => showTitleEditDialog(context),
            ),
            /// 分隔
            VerticalSeparator(18.0),
            /// 起始日期
            StartDateTile('2019-03-19', () {}),
            /// 分隔
            VerticalSeparator(18.0),
            /// 目标日期
            TargetDateTile('2019-03-20', (){}),
            /// 分隔
            VerticalSeparator(18.0),
            /// 备注
            RemarkTile('无', (){}),
            /// 分隔
            VerticalSeparator(18.0),
            /// 颜色选择条
            ColorSelectTile(
              colorList: bgColorList,
              selectedColor: eventColor,
              colorChangedCallback: onColorChanged,
            ),
            /// 分隔
            VerticalSeparator(18.0),
            // 预览效果
            Padding(padding: const EdgeInsets.only(left: 16.0), child: Text(PREVIEW_EFFECT),),
            VerticalSeparator(8.0),
            TimeEventItem(eventColor, eventType, model.title, 1, null),
            VerticalSeparator(8.0),
            /// 分割

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
                    final EventWrap eventWrap =  EventWrap(
                      TimeEventOrigin.add,
                      TimeEventModel(
                        color: bgColorList[0].value,
                        title: '添加标题', remark: '添加备注',
                        type: TimeEventType.countDownDay.index,
                      ),
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

  void onColorChanged(Color color) {
    if (model.color == color.value) return;
    setState(() {
      model.color = color.value;
    });
  }

  void showTitleEditDialog(BuildContext context) async {
    final String text = await showDialog(
      context: context,
      builder: (context) {
        return EditDialog(
          title: COUNT_DOWN_EVENT_NAME,
          maxLength: 30,
          text: model.title,
          autoFocus: true,
        );
      },
    );
    if (text != null && text.isNotEmpty) {
      setState(() {
        model.title = text;
      });
    }
  }
}
