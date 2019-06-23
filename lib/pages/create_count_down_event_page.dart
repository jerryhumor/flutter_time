import 'package:flutter/material.dart';
import 'package:flutter_time/ui/animation_column.dart';
import 'package:flutter_time/ui/common_ui.dart';
import 'package:flutter_time/value/colors.dart';
import 'package:flutter_time/value/strings.dart';

class CreateCountDownEventPage extends StatefulWidget {
  @override
  _CreateCountDownEventPageState createState() => _CreateCountDownEventPageState();
}

class _CreateCountDownEventPageState extends State<CreateCountDownEventPage> with SingleTickerProviderStateMixin {

  // todo 记录变量

  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(CREATE_COUNT_DOWN_TIME_EVENT),
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
          children: <Widget>[
            // 分隔
            VerticalSeparator(18.0),
            // 倒计日名称
            EventNameTile.countDown(null),
            // 分隔
            VerticalSeparator(18.0),
            // 起始日期
            StartDateTile('2019-03-19', () {}),
            // 分隔
            VerticalSeparator(18.0),
            // 目标日期
            TargetDateTile('2019-03-20', (){}),
            // 分隔
            VerticalSeparator(18.0),
            // 备注
            RemarkTile('无', (){}),
            // 分隔
            VerticalSeparator(18.0),
            // 颜色选择条
            ColorSelectTile(0),
            // 分隔
            VerticalSeparator(18.0),
            // 预览效果
          ],
        ),
      ),
    );
  }
}
