import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time/pages/count_down/create_count_down_event_screen.dart';
import 'package:flutter_time/pages/cumulative/create_cumulative_event_screen.dart';
import 'package:flutter_time/pages/create/time_event_type_select_screen.dart';

class CreateEventPage extends StatefulWidget {
  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  
  TimeEventTypeSelectScreen selectPage;
  CreateCountDownEventScreen countDownScreen;
  CreateCumulativeEventScreen cumulativeScreen;
  
  Widget selectedPage;
  
  @override
  void initState() {
    super.initState();
    
    selectPage = TimeEventTypeSelectScreen(
      onScreenSelected: onScreenSelected,
    );
    countDownScreen = CreateCountDownEventScreen();
    cumulativeScreen = CreateCumulativeEventScreen();

    selectedPage = selectPage;
  }
  
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 300),
        reverse: false,
        child: selectedPage,
        transitionBuilder: (child, animation, secondaryAnimation) {
          return SharedAxisTransition(
            child: child,
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
          );
        },
      ),
    );
  }

  void onScreenSelected(String page) {
    Widget needToBeSelected;
    switch(page) {
      case CREATE_COUNT_DOWN_EVENT:
        needToBeSelected = countDownScreen;
        break;
      case CREATE_CUMULATIVE_EVENT:
        needToBeSelected = cumulativeScreen;
        break;
    }
    if (selectedPage != needToBeSelected) {
      setState(() {
        selectedPage = needToBeSelected;
      });
    }
  }
}
