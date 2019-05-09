import 'package:flutter/material.dart';
import 'package:flutter_time/ui/common_ui.dart';

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          // 事件列表和设置页面
          Expanded(
            child: Container(),
          ),
          // 底部tab bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              PageButton(
                onTap: () {
                  print('点击第一个按钮');
                },
              ),
//              PageButton(
//                onTap: () {
//                  print('点击第二个按钮');
//                },
//              ),
            ],
          )
        ],
      ),
    );
  }
}
