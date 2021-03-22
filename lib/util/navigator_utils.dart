import 'package:flutter/material.dart';
import 'package:flutter_time/model/base/models.dart';
import 'package:flutter_time/pages/count_down/create_count_down_event_page.dart';
import 'package:flutter_time/pages/time_event_list_page.dart';
import 'package:flutter_time/pages/time_event_type_select_page.dart';

class NavigatorUtils {

  static Future<dynamic> navToDetail(BuildContext context, TimeEventModel model) async {
    Navigator.of(context).pushNamed('count_down_detail', arguments: {
      'model': model,
    });
  }

  /// 启动事件类型选择界面带动画
  static Future<dynamic> startTimeEventTypeSelectWithAnimation(BuildContext context) async {
    return Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          /// 从小到大变化的animation
          /// 使用非线性动画
          final Animation<double> smallToBigAnimation = Tween(begin: 0.0, end: 1.0)
              .animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
          ),);
          return ScaleTransition(
            scale: smallToBigAnimation,
            alignment: Alignment(1.0, -0.85),
            child: TimeEventTypeSelectPage(),
          );
        }
      )
    );
  }

  /// 一般是由当前事件类型选择页面调用的
  /// 所以会先pop掉当前页面 然后在启动创建倒计时事件页面
  static Future<dynamic> startCreateCountDownTimeEvent(BuildContext context) async {
    return await Navigator.popAndPushNamed(
      context,
      'create_count_down_event_page',
    );
  }

  static Future<dynamic> startCreateCumulativeTimeEvent(BuildContext context) async {
    return await Navigator.popAndPushNamed(
      context,
      'create_cumulative_event_page',
    );
  }

}