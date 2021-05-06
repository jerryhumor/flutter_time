import 'package:flutter/material.dart';
import 'package:flutter_time/themes/time_theme_data.dart';
import 'package:flutter_time/value/strings.dart';

class ThanksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    ThemeData theme = Theme.of(context);
    Color contentColor = theme.colorScheme.onSecondary;
    Color dividerColor = contentColor.withOpacity(0.5);

    TextStyle contentStyle = TimeTheme.smallTextStyle.apply(color: contentColor,);
    TextStyle dividerStyle = TimeTheme.titleTextStyle.apply(color: dividerColor,);
    TextStyle versionStyle = TimeTheme.smallTextStyle.apply(color: dividerColor,);
    TextStyle thanksStyle = TimeTheme.smallTextStyle.apply(color: contentColor, fontFamily: 'Pacifico',);

    final Widget paragraphDivider = Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Text(
        '·',
        textAlign: TextAlign.center,
        style: dividerStyle,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(THANKS_TITLE),
      ),
      body: ListView(
        padding: const EdgeInsets.all(60.0),
        physics: BouncingScrollPhysics(),
        children: [
          Image.asset(
            'images/time_launcher_foreground.png',
            height: 150.0,
            width: 150.0,
          ),
          Text(
            THANKS_CONTENT_1,
            textAlign: TextAlign.center,
            style: contentStyle,
          ),
          paragraphDivider,
          Text(
            THANKS_CONTENT_2,
            textAlign: TextAlign.center,
            style: contentStyle,
          ),
          paragraphDivider,
          SizedBox(height: 30.0,),
          Text(
            'Thanks!',
            textAlign: TextAlign.center,
            style: thanksStyle,
          ),
          Text(
            'Version 1.0.0',
            textAlign: TextAlign.center,
            style: versionStyle,
          ),
        ],
      ),
    );
  }
}
