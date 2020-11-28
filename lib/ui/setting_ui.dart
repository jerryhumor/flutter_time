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
    final groupTitleTextStyle = TextStyle(
      color: theme.colorScheme.secondaryVariant,
      fontSize: 16.0,
    );
    final itemTitleTextStyle = TextStyle(
      color: theme.colorScheme.primary,
      fontSize: 18.0,
    );
    final Color itemBackgroundColor = theme.colorScheme.onBackground;

    final List<Widget> children = [];
    children.add(_buildGroupTitle(groupTitle, groupTitleTextStyle));
    for (SettingItem item in settingItems) {
      children.add(_buildGroupItem(item.title, itemTitleTextStyle, itemBackgroundColor, item.callback));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _buildGroupTitle(String title, TextStyle textStyle) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(title, style: textStyle,),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupItem(String title, TextStyle textStyle, Color backgroundColor, ItemTapCallback callback) {
    return Row(
      children: [
        Expanded(
          child: Material(
            color: backgroundColor,
            child: InkWell(
              onTap: () {
                if (callback != null) callback(title);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(title, style: textStyle,),
              ),
            ),
          ),
        ),
      ],
    );
  }

}

class SettingItem {
  
  final String title;
  final ItemTapCallback callback;

  SettingItem({this.title, this.callback,});
}