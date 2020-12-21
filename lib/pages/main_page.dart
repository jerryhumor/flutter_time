import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_saber/log/log_utils.dart';
import 'package:flutter_time/pages/setting_page.dart';
import 'package:flutter_time/pages/time_event_list_page.dart';
import 'package:flutter_time/ui/common_ui.dart';

/// 主页面
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  bool isListPage = true;

  TimeEventListPage listPage = TimeEventListPage(key: UniqueKey(),);
  SettingPage settingPage = SettingPage(key: UniqueKey(),);

  void _navToListPage() {
    if (isListPage) return;
    setState(() {
      isListPage = !isListPage;
    });
  }

  void _navToSettingPage() {
    if (!isListPage) return;
    setState(() {
      isListPage = !isListPage;
    });
  }

  @override
  void initState() {
    super.initState();
    log('Main page init state', tag: 'MAIN');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Column(
        children: <Widget>[
          // 事件列表和设置页面
          Expanded(
            child: PageTransitionSwitcher(
              duration: const Duration(milliseconds: 300),
              reverse: isListPage,
              child: isListPage ? listPage : settingPage,
              transitionBuilder: (child, animation, secondaryAnimation) {
                return SharedAxisTransition(
                  child: child,
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  transitionType: SharedAxisTransitionType.horizontal,
                );
              },
            ),
          ),
          // 底部tab bar
          MainPageBottomBar(
            isListPage: isListPage,
            onTapListPage: _navToListPage,
            onTapSettingPage: _navToSettingPage,
          ),
        ],
      ),
    );
  }
}

class MainPageBottomBar extends StatelessWidget {

  final bool isListPage;
  final VoidCallback onTapListPage;
  final VoidCallback onTapSettingPage;

  MainPageBottomBar({
    this.isListPage,
    this.onTapListPage,
    this.onTapSettingPage,
  });

  @override
  Widget build(BuildContext context) {

    final Color backgroundColor = Theme.of(context).colorScheme.onBackground;

    return Material(
      elevation: 16.0,
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // 事件列表页面按钮
          Expanded(
            child: ListPageButton(
              checked: isListPage,
              onTap: onTapListPage,
            ),
          ),
          // 设置页面按钮
          Expanded(
            child: SettingPageButton(
              checked: !isListPage,
              onTap: onTapSettingPage,
            ),
          ),
        ],
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
    icon: Icons.dashboard,
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
      icon: Icons.assessment,
      size: const Size(48.0, 48.0),
      onTap: onTap,
      checked: checked
  );
}
