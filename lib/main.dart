import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time/bloc/bloc_provider.dart';
import 'package:flutter_time/bloc/global_bloc.dart';
import 'package:flutter_time/pages/count_down/count_down_detail_page.dart';
import 'package:flutter_time/pages/create_count_down_event_page.dart';
import 'package:flutter_time/pages/main_page.dart';
import 'package:flutter_time/pages/time_event_list_page.dart';
import 'package:flutter_time/pages/time_event_type_select_page.dart';
import 'package:flutter_time/router/router.dart';
import 'package:flutter_time/test/test_page.dart';
import 'package:flutter_time/value/strings.dart';

void main() {
  runApp(MyApp());
  SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      onGenerateRoute: routerFactory,
      home: BlocProvider(
        child: MainPage(),
        bloc: GlobalBloc(),
      ),
    );
  }
}
