import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_time/bloc/bloc_provider.dart';
import 'package:flutter_time/bloc/global_bloc.dart';
import 'package:flutter_time/db/event_db.dart';
import 'package:flutter_time/model/base/models.dart';
import 'package:flutter_time/model/list/event_list_page_state.dart';
import 'package:flutter_time/themes/time_theme_data.dart';
import 'package:flutter_time/ui/count_down/count_down_item.dart';
import 'package:flutter_time/ui/animation/item_gesture_wrapper.dart';
import 'package:flutter_time/router/navigator_utils.dart';
import 'package:flutter_time/value/strings.dart';

/// 时间事件列表界面
/// TODO(kengou): 没有数据时的兜底页面
class TimeEventListPage extends StatefulWidget {

  TimeEventListPage({Key key,}): super(key: key);

  @override
  _TimeEventListPageState createState() => _TimeEventListPageState();
}

class _TimeEventListPageState extends State<TimeEventListPage> {

  GlobalKey<AnimatedListState> listKey;
  EventListModel eventListModel;
  Random random;

  /// 添加事件
  /// [eventWrap] 时间事件包装对象
  void _addEvent(EventWrap eventWrap) {
    final bool isEmpty = eventListModel.eventLength == 0;
    /// 数据插入列表
    eventListModel.insertEvent(0, eventWrap);
    if (isEmpty) setState(() {});
    /// 数据插入列表
    listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 200));
  }
  
  /// 获取事件
  void _initData() async {
    await eventListModel.fetchEvents();
    setState(() {});
    if (eventListModel.eventLength <= 0) return;
    for (int i = 0; i < eventListModel.eventLength; i++) {
      listKey.currentState?.insertItem(i, duration: const Duration(milliseconds: 200));
      await Future.delayed(const Duration(milliseconds: 64));
    }
  }

  /// 跳转到添加时间事件的页面
  /// 返回时间事件的包装类
  Future<EventWrap> _navToAddEventPage() async {
    final dynamic res = await NavigatorUtils.startTimeEventTypeSelectWithAnimation(context);
    if (res == null || res is! EventWrap) return null;
    return res;
  }

  @override
  void initState() {
    super.initState();
    random = Random();
    listKey = GlobalKey();
    eventListModel = BlocProvider.of<GlobalBloc>(context).eventListModel;
  }

  @override
  Widget build(BuildContext context) {

    /// 下一帧绘制完毕后 执行获取数据的操作
    if (!eventListModel.initialized) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        if (!eventListModel.initialized) {
          eventListModel.initialized = true;
          _initData();
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(APP_NAME),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add,),
            onPressed: () async {
              final EventWrap eventWarp = await _navToAddEventPage();
              if (eventWarp == null) return;
              _addEvent(eventWarp);
            },
          ),
        ],
      ),
      body: _buildList(),
    );
  }

  /// 创建初始化数据的item 也就是第一次要展示的数据
  /// 添加从下往上渐变动画的item
  Widget _buildInitItem(BuildContext context, int index, TimeEventModel model, Animation<double> animation) {
    final Animation<Offset> offsetAnimation = animation.drive(Tween<Offset>(
        begin: Offset(0, 0.3),
        end: Offset.zero
    ));
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: offsetAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ItemGestureWrapper(
              leftAction: ActionIcon.archive(),
              rightAction: ActionIcon.delete(),
              onTap: () => NavigatorUtils.navToDetail(context, model, index),
              child: TimeEventItem(
                index: index,
                model: model,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
            SizedBox(height: 12,),
          ],
        ),
      ),
    );
  }

  /// 创建添加的item
  /// 从左往右平滑出现的item
  Widget _buildAddItem(BuildContext context, int index, TimeEventModel model, Animation<double> animation) {
    final Animation<Offset> offsetAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutSine,
    ).drive(Tween<Offset>(
        begin: Offset(-1, 0),
        end: Offset.zero,
    ));

    return SizeTransition(
      sizeFactor: animation,
      child: SlideTransition(
        position: offsetAnimation,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ItemGestureWrapper(
              child: TimeEventItem(
                index: index,
                model: model,
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
              onTap: () => NavigatorUtils.navToDetail(context, model, index),
            ),
            SizedBox(height: 12,),
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    if (!eventListModel.initialized) {
      return _buildProgress();
    } else {
      if (eventListModel.eventLength <= 0) {
        return _buildEmpty();
      } else {
        return _buildAnimationList();
      }
    }
  }

  /// 创建progress
  Widget _buildProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  /// 创建空的数据
  Widget _buildEmpty() {

    final ThemeData theme = Theme.of(context);
    final color = theme.colorScheme.secondaryVariant;
    final style = TimeTheme.normalTextStyle.apply(color: color, letterSpacingFactor: 2.0);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inbox,
            size: 64,
            color: color,
          ),
          SizedBox(height: 16.0,),
          Text(
            '点击右上角',
            style: style,
          ),
          SizedBox(height: 16.0,),
          Text(
            '创建「时间卡」吧👊',
            style: style,
          ),
        ],
      ),
    );
  }

  /// 创建带动画的事件列表
  Widget _buildAnimationList() {
    return AnimatedList(
      key: listKey,
      padding: const EdgeInsets.symmetric(vertical: 12),
      physics: BouncingScrollPhysics(),
      initialItemCount: eventListModel.eventLength,
      itemBuilder: (BuildContext context, int index, Animation<double> animation) {
        final model = eventListModel.eventWraps[index];
        Widget item;
        switch (model.origin) {
          case TimeEventOrigin.init:
            item = _buildInitItem(context, index, model.model, animation);
            break;
          case TimeEventOrigin.add:
            item = _buildAddItem(context, index, model.model, animation);
            break;
        }
        return item;
      },
    );
  }
}

/// 事件的包装类
class EventWrap {
  /// 来源 是添加还是初始数据
  TimeEventOrigin origin;
  TimeEventModel model;

  EventWrap(this.origin, this.model);

}

/// 用于决定返回哪种动画
enum TimeEventOrigin {
  /// 初始化的数据
  init,
  /// 添加的数据
  add,
}