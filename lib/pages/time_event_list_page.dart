import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time/bloc/bloc_provider.dart';
import 'package:flutter_time/bloc/global_bloc.dart';
import 'package:flutter_time/db/event_db.dart';
import 'package:flutter_time/model/base/models.dart';
import 'package:flutter_time/model/list/event_list_page_state.dart';
import 'package:flutter_time/themes/time_theme_data.dart';
import 'package:flutter_time/ui/animation/animation_column_2.dart';
import 'package:flutter_time/ui/count_down/count_down_item.dart';
import 'package:flutter_time/ui/animation/item_gesture_wrapper.dart';
import 'package:flutter_time/router/navigator_utils.dart';
import 'package:flutter_time/value/colors.dart';
import 'package:flutter_time/value/strings.dart';

const _kTimeEventItemMargin = EdgeInsets.symmetric(horizontal: 16.0);
const _kListPadding = EdgeInsets.symmetric(vertical: 24.0);
const _kListDivider = SizedBox(height: 12.0,);
const _kFakeItem = SizedBox(height: 140, width: double.infinity,);
const _kAddAnimationDuration = Duration(milliseconds: 300);

/// 时间事件列表界面
class TimeEventListPage extends StatefulWidget {

  TimeEventListPage({Key key,}): super(key: key);

  @override
  _TimeEventListPageState createState() => _TimeEventListPageState();
}

class _TimeEventListPageState extends State<TimeEventListPage> with SingleTickerProviderStateMixin {

  GlobalKey<AnimatedListState> listKey;
  EventListModel eventListModel;
  Random random;
  
  bool isAddAnimation = false;
  bool isInitAnimation = false;
  AnimationController animationController;

  /// 添加事件
  /// [eventWrap] 时间事件包装对象
  Future<void> _addModel(BuildContext context, TimeEventModel model) async {
    /// 数据插入列表
    final res = await eventListModel.insertEvent(model);
    _showInsertRes(res, context);
    if (res <= 0) return;
    /// 刷新页面 并且开始播放动画
    setState(() {
      isAddAnimation = true;
    });
    animationController.forward(from: 0.0);
  }
  
  /// 获取事件
  void _initData() async {
    await eventListModel.fetchEvents();

    /// 执行
    setState(() {
      isAddAnimation = false;
      if (eventListModel.eventLength > 0) {
        isInitAnimation = true;
        animationController.forward(from: 0.0);
      }
    });
  }

  void _showInsertRes(int res, BuildContext context) {

    bool success = res > 0;
    final color = success ? Color(eventListModel.models[0].color) : colorRed1;
    final text = success ? '添加成功' : '添加失败';

    ScaffoldState state = Scaffold.of(context);
    state.removeCurrentSnackBar();
    state.showSnackBar(SnackBar(
      backgroundColor: color,
      content: Text(text),
    ));
    HapticFeedback.lightImpact();
  }

  /// 跳转到添加时间事件的页面
  /// 返回时间事件的包装类
  Future<TimeEventModel> _navToAddEventPage() async {
    return await NavigatorUtils.startTimeEventTypeSelectWithAnimation(context);
  }

  @override
  void initState() {
    super.initState();
    random = Random();
    listKey = GlobalKey();
    eventListModel = BlocProvider.of<GlobalBloc>(context).eventListModel;
    animationController = AnimationController(vsync: this, duration: _kAddAnimationDuration);
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) 
        setState(() { isAddAnimation = false; });
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    /// 下一帧绘制完毕后 执行获取数据的操作
    if (!eventListModel.initialized) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        if (!eventListModel.initialized) {
          _initData();
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(APP_NAME),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.add,),
              onPressed: () async {
                final model = await _navToAddEventPage();
                if (model == null) return;
                _addModel(context ,model);
              },
            ),
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  /// 根据当前的状态和数据创建空页面或者列表
  Widget _buildBody() {
    /// 未初始化 则显示loading
    if (!eventListModel.initialized) return _buildProgress();
    /// 数据为空 显示空页面
    if (eventListModel.eventLength <= 0) return _buildEmpty();
    /// 展示添加动画
    if (isAddAnimation) return _buildAddAnimationList();
    /// 展示初始动画
    if (isInitAnimation) return _buildInitAnimationList();
    /// 显示正常的列表
    return _buildEventList();
  }

  /// 创建progress
  Widget _buildProgress() {
    print('build progress');
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  /// 创建空的数据
  Widget _buildEmpty() {
    print('build empty');
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

  /// 创建事件列表
  Widget _buildEventList() {
    print('build event list');
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      padding: _kListPadding,
      itemBuilder: (context, index) {
        final model = eventListModel.models[index];
        Widget content = ItemGestureWrapper(
          child: TimeEventItem(
            index: index,
            model: model,
            margin: _kTimeEventItemMargin,
          ),
          onTap: () => NavigatorUtils.navToDetail(context, model, index),
        );
        if (isAddAnimation && index == 0) content = _wrapAnimation(content);
        return content;
      },
      separatorBuilder: (context, index) => _kListDivider,
      itemCount: eventListModel.eventLength,
    );
  }

  /// 创建添加动画层
  Widget _buildAddAnimationLayer() {
    print('build add animation layer');
    final slideAnimation = animationController.drive(Tween<Offset>(
      begin: Offset(-1, 0),
      end: Offset.zero,
    ),);
    return SlideTransition(
      position: slideAnimation,
      child: Padding(
        padding: _kListPadding,
        child: TimeEventItem(
          model: eventListModel.models[0],
          margin: _kTimeEventItemMargin,
        ),
      ),
    );
  }

  /// 创建带有动画的列表 用于在事件被添加到列表的时候展示动画
  Widget _buildAddAnimationList() {
    return Stack(
      children: [
        _buildAddAnimationLayer(),
        _buildEventList(),
      ],
    );
  }

  ///  创建带有动画的列表 用于在列表刚被添加的时候展示动画
  Widget _buildInitAnimationList() {
    print('build init animation list');
    /// 获取前6条数据作为需要添加到列表的数据
    List<TimeEventModel> models = eventListModel.models.getRange(
      0,
      min(eventListModel.eventLength, 6),
    ).toList();

    List<Widget> children = [];
    models.forEach((element) {
      children.add(AnimationColumnItem(
        child: TimeEventItem(
          model: element,
          margin: _kTimeEventItemMargin,
        ),
      ));
      children.add(_kListDivider);
    });

    return SingleChildScrollView(
      child: Padding(
        padding: _kListPadding,
        child: AnimationColumn2(
          children: children,
          positionBegin: Offset(0.0, 0.5),
          displayAnimationWhenInit: true,
          fromState: ItemState.dismissed,
          toState: ItemState.completed,
          onAnimationFinished: () => setState(() { isInitAnimation = false; }),
        ),
      ),
    );
  }

  /// 给item包裹动画
  Widget _wrapAnimation(Widget content) {
    final slideAnimation = animationController.drive(Tween<Offset>(
      begin: Offset(-1, 0),
      end: Offset.zero,
    ),);

    return SizeTransition(
      sizeFactor: animationController,
      child: SlideTransition(
        position: slideAnimation,
        child: _kFakeItem,
      ),
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