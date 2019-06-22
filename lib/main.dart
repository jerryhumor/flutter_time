import 'package:flutter/material.dart';
import 'package:flutter_time/pages/create_count_down_event_page.dart';
import 'package:flutter_time/pages/main_page.dart';
import 'package:flutter_time/pages/time_event_list_page.dart';
import 'package:flutter_time/pages/time_event_type_select_page.dart';
import 'package:flutter_time/test/test_page.dart';
import 'package:flutter_time/value/strings.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}
