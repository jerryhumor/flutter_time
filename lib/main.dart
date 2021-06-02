import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time/bloc/bloc_provider.dart';
import 'package:flutter_time/bloc/global_bloc.dart';
import 'package:flutter_time/pages/main_page.dart';
import 'package:flutter_time/router/router.dart';
import 'package:flutter_time/themes/time_theme_data.dart';
import 'package:flutter_time/value/strings.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
}

class MyApp extends StatelessWidget {

  final GlobalBloc bloc = GlobalBloc();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: bloc,
      child: MaterialApp(
        title: APP_NAME,
        theme: TimeTheme.lightThemeData,
        darkTheme: TimeTheme.darkThemeData,
        onGenerateRoute: routerFactory,
        home: MainPage(),
      ),
    );
  }
}
