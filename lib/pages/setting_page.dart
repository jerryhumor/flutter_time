import 'package:flutter/material.dart';
import 'package:flutter_time/ui/common_ui.dart';
import 'package:flutter_time/ui/setting_ui.dart';
import 'package:flutter_time/value/colors.dart';
import 'package:flutter_time/value/strings.dart';

class SettingPage extends StatelessWidget {

  SettingPage({Key key,}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(SETTING),),
      body: ListView(
        children: [
          SettingGroup(
            groupTitle: '通用',
            settingItems: [
              SettingItem(
                title: 'URL Schemes',
              ),
              SettingItem(
                title: '使用指南',
              ),
              SettingItem(
                title: '已归档',
              ),
            ],
          ),
          SettingGroup(
            groupTitle: '反馈',
            settingItems: [
              SettingItem(
                title: 'iMessage',
              ),
              SettingItem(
                title: '邮件',
              ),
            ],
          ),
          SettingGroup(
            groupTitle: '关于作者',
            settingItems: [
              SettingItem(
                title: '邮箱',
              ),
              SettingItem(
                title: 'Twitter',
              ),
              SettingItem(
                title: 'Weibo',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
