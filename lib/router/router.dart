import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time/pages/count_down/count_down_detail_page.dart';
import 'package:flutter_time/pages/count_down/create_count_down_event_screen.dart';
import 'package:flutter_time/pages/cumulative/create_cumulative_event_screen.dart';
import 'package:flutter_time/pages/thanks/thanks_page.dart';
import 'package:flutter_time/pages/unknown/unknown_page.dart';

RouteFactory routerFactory = (RouteSettings settings) {
  return MaterialPageRoute(
    settings: settings,
    builder: (BuildContext context) => buildPage(context, settings),
  );
};

Widget Function(BuildContext context, RouteSettings settings) buildPage = (context, settings) {
  String pageName = settings.name;
  dynamic argument = settings.arguments;
  Widget page;
  switch (pageName) {
    case 'count_down_detail': {
      page = CountDownDetailPage(
        model: argument['model'],
        heroTag: argument['heroTag'],
      );
      break;
    }
    case 'create_count_down_event_page': {
      page = CreateCountDownEventScreen();
      break;
    }
    case 'create_cumulative_event_page': {
      page = CreateCumulativeEventScreen();
      break;
    }
    case 'thanks': {
      page = ThanksPage();
      break;
    }
  }
  return page ?? UnknownPage();
};

