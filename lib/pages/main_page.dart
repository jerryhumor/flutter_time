import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_saber/log/log_utils.dart';
import 'package:flutter_time/pages/setting_page.dart';
import 'package:flutter_time/pages/time_event_list_page.dart';
import 'package:flutter_time/ui/animation_page_container.dart';
import 'package:flutter_time/ui/common_ui.dart';

/// 主页面
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  bool isListPage = true;
  PageController pageController;

  void _navToListPage() {
    if (isListPage) return;
    setState(() {
      isListPage = !isListPage;
      pageController.jumpToPage(0);
    });
  }

  void _navToSettingPage() {
    if (!isListPage) return;
    setState(() {
      isListPage = !isListPage;
      pageController.jumpToPage(1);
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    log('Main page init state', tag: 'MAIN');
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            // 事件列表和设置页面
            Expanded(
              child: PageView(
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
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
                      onTap: _navToListPage,
                    ),
                  ),
                  // 设置页面按钮
                  Expanded(
                    child: SettingPageButton(
                      checked: !isListPage,
                      onTap: _navToSettingPage,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
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
