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
      children.add(_buildGroupItem(item.title, item.content, itemTitleTextStyle, groupTitleTextStyle, itemBackgroundColor, item.callback));
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

  Widget _buildGroupItem(String title, String content, TextStyle titleStyle, TextStyle contentStyle, Color backgroundColor, ItemTapCallback callback) {

    List<Widget> children = [Text(title, style: titleStyle,),];
    if (content != null && content.isNotEmpty)
      children.add(Text(content, style: contentStyle,));

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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: children,
                )
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
  final String content;
  final ItemTapCallback callback;

  SettingItem({this.title, this.content, this.callback,});
}