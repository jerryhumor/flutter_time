import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_saber/log/log_utils.dart';
import 'package:flutter_time/bloc/bloc_provider.dart';
import 'package:flutter_time/bloc/global_bloc.dart';
import 'package:flutter_time/constant/time_event_constant.dart';
import 'package:flutter_time/model/base/models.dart';
import 'package:flutter_time/model/list/event_list_page_state.dart';
import 'package:flutter_time/ui/common_ui.dart';
import 'package:flutter_time/ui/count_down/count_down_item.dart';
import 'package:flutter_time/ui/item_gesture_wrapper.dart';
import 'package:flutter_time/util/navigator_utils.dart';
import 'package:flutter_time/value/colors.dart';
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
  EventListPageState state;
  Random random;

  /// 添加事件
  /// [eventWrap] 时间事件包装对象
  void _addEvent(EventWrap eventWrap) {
    state.insertEvent(0, eventWrap);
    listKey.currentState?.insertItem(0, duration: const Duration(milliseconds: 200));
  }
  
  /// 获取事件
  void _initData() async {
    final List<EventWrap> eventWrapList = await _fetchEvents();
    if (eventWrapList == null || eventWrapList.isEmpty) return;
    state.addInitEvents(eventWrapList);
//    /// debug模式下 不延迟会导致崩溃 原因如下
//    /// i = 0 时，listKey.currentState 为空 所以第一个元素并没有插入列表
//    /// i = 1 时，listKey.currentState 不为空 插入第二个元素
//    /// 这时列表元素个数为0 但是我们却要插入index为1的元素 所以导致报错
//    await Future.delayed(const Duration(milliseconds: 500));
    for (int i = 0; i < state.eventLength; i++) {
      listKey.currentState?.insertItem(i, duration: const Duration(milliseconds: 200));
      await Future.delayed(const Duration(milliseconds: 64));
    }
  }

  /// 获取本地存储的时间事件数据
  /// 返回时间事件的包装类 声明这些时间事件是初始数据
  Future<List<EventWrap>> _fetchEvents() async {
    /// 模拟数据耗时操作
//    await Future.delayed(const Duration(milliseconds: 200));
    List<EventWrap> events = [];
    for (int i = 0; i < 6; i++) {
      final TimeEventModel model = TimeEventModel(
        color: bgColorList[random.nextInt(13)].value,
        title: '测试标题',
        remark: '这是备注',
        startTime: 1609430400000,
        endTime: 1616308077000,
        type: TimeEventType.countDownDay.index,
      );
      events.add(EventWrap(TimeEventOrigin.init, model));
    }
    return events;
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
    state = BlocProvider.of<GlobalBloc>(context).eventListPageState;
  }

  @override
  Widget build(BuildContext context) {

    /// 下一帧绘制完毕后 执行获取数据的操作
    if (!state.initialized) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        if (!state.initialized) {
          state.initialized = true;
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
      body: _buildAnimationList(),
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
              child: TimeEventItem(
                index: index,
                model: model,
              ),
              onTap: () => NavigatorUtils.navToDetail(context, model, index),
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
              ),
              onTap: () => NavigatorUtils.navToDetail(context, model, index),
            ),
            SizedBox(height: 12,),
          ],
        ),
      ),
    );
  }

  /// 创建带动画的事件列表
  Widget _buildAnimationList() {
    return AnimatedList(
      key: listKey,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      physics: BouncingScrollPhysics(),
      initialItemCount: state.eventLength,
      itemBuilder: (BuildContext context, int index, Animation<double> animation) {
        final model = state.modelList[index];
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