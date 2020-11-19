import 'package:flutter/material.dart';
import 'package:flutter_time/ui/animation_column.dart';
import 'package:flutter_time/ui/common_ui.dart';
import 'package:flutter_time/util/navigator_utils.dart';
import 'package:flutter_time/value/colors.dart';
import 'package:flutter_time/value/strings.dart';

class TimeEventTypeSelectPage extends StatefulWidget {
  @override
  _TimeEventTypeSelectPageState createState() => _TimeEventTypeSelectPageState();
}

class _TimeEventTypeSelectPageState extends State<TimeEventTypeSelectPage> with SingleTickerProviderStateMixin {

  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = 
      AnimationController(
        vsync: this, 
        duration: const Duration(milliseconds: 300)
      );
      controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          NavigatorUtils.startCreateCountDownTimeEvent(context).then((value) {
            Navigator.pop(context, value);
          });
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorAppBarBg,
        title: AppBarTitle(CREATE),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              color: colorGrey,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: AnimationColumn(
        fadeStart: 1.0,
        fadeEnd: 0.0,
        positionStart: Offset.zero,
        positionEnd: Offset(-0.2, 0.0),
        controller: controller,
        children: <Widget>[
          // 倒计日条目
          EventTypeItem.countDownDay(() {
            controller.forward();
          }),
          // 分隔
          SizedBox(height: 32.0,),
          // 累计日条目
          EventTypeItem.cumulativeDay(() {
            controller.forward();
          }),
        ],
      ),
    );
  }
}
