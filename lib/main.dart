import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time/bloc/bloc_provider.dart';
import 'package:flutter_time/bloc/global_bloc.dart';
import 'package:flutter_time/pages/count_down/count_down_detail_page.dart';
import 'package:flutter_time/pages/count_down/create_count_down_event_screen.dart';
import 'package:flutter_time/pages/main_page.dart';
import 'package:flutter_time/pages/time_event_list_page.dart';
import 'package:flutter_time/pages/create/time_event_type_select_screen.dart';
import 'package:flutter_time/router/router.dart';
import 'package:flutter_time/test/test_page.dart';
import 'package:flutter_time/themes/time_theme_data.dart';
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
    return BlocProvider(
      bloc: GlobalBloc(),
      child: MaterialApp(
        title: APP_NAME,
        theme: TimeThemeData.lightThemeData,
        darkTheme: TimeThemeData.darkThemeData,
        onGenerateRoute: routerFactory,
        home: MainPage(),
      ),
    );
  }
}
