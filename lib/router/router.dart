import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time/pages/count_down/count_down_detail_page.dart';
import 'package:flutter_time/pages/create_count_down_event_page.dart';
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
        bgHeroTag: argument['bgHeroTag'],
        labelHeroTag: argument['labelHeroTag'],
      );
      break;
    }
    case 'create_count_down_event_page': {
      page = CreateCountDownEventPage();
      break;
    }
  }
  return page ?? UnknownPage();
};

