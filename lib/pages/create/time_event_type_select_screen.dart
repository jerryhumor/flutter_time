import 'package:flutter/material.dart';
import 'package:flutter_time/pages/cumulative/create_cumulative_event_screen.dart';
import 'package:flutter_time/ui/animation/animation_column_2.dart';
import 'package:flutter_time/ui/common_ui.dart';
import 'package:flutter_time/util/navigator_utils.dart';
import 'package:flutter_time/value/colors.dart';
import 'package:flutter_time/value/strings.dart';

import '../count_down/create_count_down_event_screen.dart';

typedef ScreenSelectedCallback = void Function(String route);

class TimeEventTypeSelectScreen extends StatefulWidget {

  final ScreenSelectedCallback onScreenSelected;

  TimeEventTypeSelectScreen({this.onScreenSelected,});

  @override
  _TimeEventTypeSelectScreenState createState() => _TimeEventTypeSelectScreenState();
}

class _TimeEventTypeSelectScreenState extends State<TimeEventTypeSelectScreen> with SingleTickerProviderStateMixin {

  bool countDownTapped = false, cumulativeTapped = false;
  ItemState from = ItemState.completed, to = ItemState.completed;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CREATE),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              color: colorGrey,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: AnimationColumn2(
        onAnimationFinished: () {
          if (widget.onScreenSelected != null) {
            if (countDownTapped) {
              widget.onScreenSelected(CREATE_COUNT_DOWN_EVENT);
            } else if (cumulativeTapped) {
              widget.onScreenSelected(CREATE_CUMULATIVE_EVENT);
            }
          }
        },
        children: [
          AnimationColumnItem(
            first: countDownTapped,
            child: EventTypeItem(
              title: COUNT_DOWN_TYPE_ITEM_TITLE,
              subTitle: COUNT_DOWN_TYPE_ITEM_SUB_TITLE,
              bgColor: colorRed1,
              onTap: handleTapCountDownItem,
            ),
          ),
          SizedBox(height: 32.0,),
          AnimationColumnItem(
            first: cumulativeTapped,
            child: EventTypeItem(
              title: CUMULATIVE_TYPE_ITEM_TITLE,
              subTitle: CUMULATIVE_TYPE_ITEM_SUB_TITLE,
              bgColor: colorBlue1,
              onTap: handleTapCumulativeItem,
            ),
          ),
        ],
        fromState: from,
        toState: to,
        animationType: AnimationType.showOneFirst,
      ),
    );
  }

  void handleTapCountDownItem() {
    setState(() {
      countDownTapped = true;
      from = ItemState.completed;
      to = ItemState.dismissed;
    });
  }

  void handleTapCumulativeItem() {
    setState(() {
      cumulativeTapped = true;
      from = ItemState.completed;
      to = ItemState.dismissed;
    });
  }
}
