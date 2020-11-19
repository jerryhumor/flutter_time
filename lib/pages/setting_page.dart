import 'package:flutter/material.dart';
import 'package:flutter_time/ui/common_ui.dart';
import 'package:flutter_time/value/colors.dart';
import 'package:flutter_time/value/strings.dart';

class SettingPage extends StatelessWidget {

  SettingPage({Key key,}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorAppBarBg,
        title: AppBarTitle(SETTING),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
