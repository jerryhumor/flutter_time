import 'package:flutter/material.dart';
import 'package:flutter_time/ui/common_ui.dart';
import 'package:flutter_time/util/navigator_utils.dart';
import 'package:flutter_time/value/colors.dart';
import 'package:flutter_time/value/strings.dart';

class TimeEventTypeSelectPage extends StatelessWidget {
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
      body: Padding(
        padding: const EdgeInsets.only(left: 32.0, right: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // 倒计日条目
            EventTypeItem.countDownDay(() {
              NavigatorUtils.startCreateCountDownTimeEvent(context);
            }),
            // 分隔
            SizedBox(height: 32.0,),
            // 累计日条目
            EventTypeItem.cumulativeDay(() {
              NavigatorUtils.startCreateCumulativeTimeEvent(context);
            }),
          ],
        ),
      ),
    );
  }
}
