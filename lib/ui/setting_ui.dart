import 'dart:html';

import 'package:flutter/material.dart';

typedef ItemTapCallback = void Function(String title);

/// 设置组
class SettingGroup extends StatelessWidget {

  final String groupTitle;
  final List<SettingItem> settingItems;
  
  SettingGroup({
    this.groupTitle, 
    this.settingItems,
  });

  @override
  Widget build(BuildContext context) {

    final ThemeData theme = Theme.of(context);
//    final groupTitleTextStyle = theme.textTheme.
    final itemTitleTextStyle = theme.textTheme.headline5.apply(
      color: theme.colorScheme.onPrimary,);

    return null;
  }
}

class SettingItem {
  
  final String title;
  final ItemTapCallback callback;

  SettingItem({this.title, this.callback,});
}