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
        physics: BouncingScrollPhysics(),
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
          SettingGroup(
            groupTitle: '其他',
            settingItems: [
              SettingItem(
                title: '分享 Time',
              ),
              SettingItem(
                title: '赠送 Time',
              ),
              SettingItem(
                title: 'App Store 评论',
              ),
            ],
          ),
          SettingGroup(
            groupTitle: '备份',
            settingItems: [
              SettingItem(
                title: 'iCloud 自动备份',
                content: '1秒前',
              ),
            ],
          ),
          SettingGroup(
            groupTitle: 'One more thing',
            settingItems: [
              SettingItem(
                title: '特别感谢',
                callback: (str) => Navigator.pushNamed(context, 'thanks'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
