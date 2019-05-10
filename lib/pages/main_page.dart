import 'package:flutter/material.dart';
import 'package:flutter_time/pages/setting_page.dart';
import 'package:flutter_time/pages/time_event_list_page.dart';
import 'package:flutter_time/ui/common_ui.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  bool isListPage = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // 事件列表和设置页面
        Expanded(
          child: IndexedStack(
            index: isListPage ? 0 : 1,
            children: <Widget>[
              TimeEventListPage(),
              SettingPage(),
            ],
          ),
        ),
        // 底部tab bar
        Material(
          elevation: 16.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // 事件列表页面按钮
              Expanded(
                child: ListPageButton(
                  checked: isListPage,
                  onTap: () {
                    setState(() {
                      isListPage = true;
                    });
                  },
                ),
              ),
              // 设置页面按钮
              Expanded(
                child: SettingPageButton(
                  checked: !isListPage,
                  onTap: () {
                    setState(() {
                      isListPage = false;
                    });
                  },
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}



// 事件列表页面按钮
class ListPageButton extends PageButton {
  const ListPageButton({
    VoidCallback onTap,
    bool checked = false
  }) : super(
    unCheckedImgAsset: 'images/time_event_list_page_normal.png',
    checkedImgAsset: 'images/time_event_list_page_selected.png',
    size: const Size(48.0, 48.0),
    onTap: onTap,
    checked: checked,
  );
}

// 设置页面按钮
class SettingPageButton extends PageButton {
  const SettingPageButton({
    VoidCallback onTap,
    bool checked = false
  }): super(
      unCheckedImgAsset: 'images/time_event_setting_page_normal.png',
      checkedImgAsset: 'images/time_event_setting_page_selected.png',
      size: const Size(48.0, 48.0),
      onTap: onTap,
      checked: checked
  );
}
