import 'package:flutter/material.dart';
import 'package:flutter_time/model/base/models.dart';
import 'package:flutter_time/ui/common_ui.dart';

// 时间事件的条目
class CountDownItem extends StatelessWidget {

  /// 序号
  final int index;
  /// 数据
  final TimeEventModel model;

  CountDownItem({this.index, this.model,});

  @override
  Widget build(BuildContext context) {

    String bgHeroTag = 'bg_hero_$index';
    String titleHeroTag = 'title_hero_$index';

    return SizedBox(
      width: double.infinity,
      /// todo 提取常量
      height: 120,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('count_down_detail', arguments: {
            'model': model,
            'bgHeroTag': bgHeroTag,
            'labelHeroTag': titleHeroTag,
          });
        },
        child: Stack(
          children: <Widget>[
            _buildBackground(model.color, bgHeroTag),
            _buildContent(model, titleHeroTag),
          ],
        )
      ),
    );
  }

  /// 创建背景
  Widget _buildBackground(int color, String tag) {
    Widget background =  Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Color(color),
        borderRadius: BorderRadius.circular(16.0),
      ),
    );
    if (tag != null && tag.isNotEmpty) {
      background = Hero(
        tag: tag,
        child: background,
      );
    }
    return background;
  }

  /// 创建内容
  Widget _buildContent(TimeEventModel model, String tag) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: <Widget>[
          // 包含标题 类型信息的row
          TitleRow(title: model.title, type: model.type, titleHeroTag: tag,),
          // 间隔
          SizedBox(height: 8.0,),
          // 包含日期信息的row
          TimeRow(model.type, null, null),
        ],
      ),
    );
  }
}