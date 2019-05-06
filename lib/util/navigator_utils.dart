import 'package:flutter/material.dart';
import 'package:flutter_time/pages/time_event_type_select_page.dart';

class NavigatorUtils {

  // 启动事件类型选择界面带动画
  static void startTimeEventTypeSelectWithAnimation(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          // 从小到大变化的animation
          // 使用非线性动画
          final Animation<double> smallToBigAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
          return ScaleTransition(
            scale: smallToBigAnimation,
            alignment: Alignment.topRight,
            child: TimeEventTypeSelectPage(),
          );
        }
      )
    );
  }

}