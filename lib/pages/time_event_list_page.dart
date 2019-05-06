import 'package:flutter/material.dart';
import 'package:flutter_time/constant/time_event_constant.dart';
import 'package:flutter_time/ui/common_ui.dart';
import 'package:flutter_time/util/navigator_utils.dart';
import 'package:flutter_time/value/colors.dart';
import 'package:flutter_time/value/strings.dart';

class TimeEventListPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppBarTitle(APP_NAME),
        centerTitle: true,
        backgroundColor: colorAppBarBg,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              color: colorGrey,
            ),
            onPressed: () {
              NavigatorUtils.startTimeEventTypeSelectWithAnimation(context);
            },
          )
        ],
      ),
      body: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: 13,
        itemBuilder: (context, index) {
          return TimeEventItem(Colors.red, TimeEventType.countDownDay, '还是计算机', 0);
        },
      ),
    );
  }
}

