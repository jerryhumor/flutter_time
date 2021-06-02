import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time/value/colors.dart';

class TimeTheme {

  static const _lightFillColor = colorAppBarTitle;
  static const _darkFillColor = Colors.white;

  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  static final SystemUiOverlayStyle lightSystemStyle = SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
  );
  static final SystemUiOverlayStyle darkSystemStyle = SystemUiOverlayStyle(
    systemNavigationBarColor: Color(0xFF3B3B3B),
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    statusBarColor: Colors.transparent,
  );

  static ThemeData lightThemeData = themeData(lightColorScheme, _lightFocusColor);
  static ThemeData darkThemeData = themeData(darkColorScheme, _darkFocusColor);

  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      colorScheme: colorScheme,
      // Matches manifest.json colors and background color.
      primaryColor: const Color(0xFF030303),
      appBarTheme: AppBarTheme(
        color: colorScheme.onBackground,
        iconTheme: IconThemeData(color: colorScheme.primary),
        brightness: colorScheme.brightness,
        centerTitle: true,
        textTheme: _textTheme.apply(bodyColor: colorScheme.primary,),
      ),
      iconTheme: IconThemeData(color: colorScheme.onPrimary),
      canvasColor: colorScheme.background,
      scaffoldBackgroundColor: colorScheme.background,
      highlightColor: Colors.transparent,
      accentColor: colorScheme.primary,
      focusColor: focusColor,
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color.alphaBlend(
          _lightFillColor.withOpacity(0.80),
          _darkFillColor,
        ),
      ),
    );
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color(0xFF636585),
    primaryVariant: Color(0xFF2E3641),
    secondary: Color(0xFFFFFFFF),
    secondaryVariant: Color(0xFFDEDEDE),
    background: Color(0xFFF8F8F8),
    surface: Color(0xFFFAFBFB),
    onBackground: Colors.white,
    error: _lightFillColor,
    onError: _lightFillColor,
    onPrimary: _lightFillColor,
    onSecondary: Color(0xFF434756),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    primary: Color(0xFFEBEBEB),
    primaryVariant: Color(0xFFB7B7B7),
    secondary: Color(0xFFDDDDDD),
    secondaryVariant: Color(0xFF5B5B5B),
    background: Color(0xFF242424),
    surface: Color(0xFF1F1929),
    onBackground: Color(0xFF3B3B3B), // White with 0.05 opacity
    error: _darkFillColor,
    onError: _darkFillColor,
    onPrimary: _darkFillColor,
    onSecondary: _darkFillColor,
    onSurface: _darkFillColor,
    brightness: Brightness.dark,
  );

  static const _regular = FontWeight.w400;
  static const _medium = FontWeight.w500;
  static const _semiBold = FontWeight.w600;
  static const _bold = FontWeight.w700;

  static final TextTheme _textTheme = TextTheme(
    headline4: TextStyle(fontWeight: _bold, fontSize: 20.0),
    headline5: TextStyle(fontWeight: _medium, fontSize: 14.0),
    headline6: TextStyle(fontWeight: _bold, fontSize: 20.0),
    bodyText1: TextStyle(fontWeight: _regular, fontSize: 14.0),
    bodyText2: TextStyle(fontWeight: _regular, fontSize: 16.0),
    subtitle1: TextStyle(fontWeight: _medium, fontSize: 16.0),
    subtitle2: TextStyle(fontWeight: _medium, fontSize: 14.0),
    caption: TextStyle(fontWeight: _semiBold, fontSize: 16.0),
    overline: TextStyle(fontWeight: _medium, fontSize: 12.0),
    button: TextStyle(fontWeight: _semiBold, fontSize: 14.0),
  );

  static final TextTheme myTextTheme = TextTheme(
    headline1: TextStyle(fontSize: 32.0, fontWeight: _bold),
    /// big
    headline2: TextStyle(fontSize: 24.0, fontWeight: _bold),
    /// normal
    headline3: TextStyle(fontSize: 18.0, letterSpacing: 1.0,),
    /// small
    headline4: TextStyle(fontSize: 14.0),
    /// tiny
    headline5: TextStyle(fontSize: 10.0),
    /// minimum
    headline6: TextStyle(fontSize: 8.0),
    /// large 1
    bodyText1: TextStyle(fontSize: 54.0, fontWeight: _bold,),
    /// large 2
    bodyText2: TextStyle(fontSize: 32.0, fontWeight: _bold),
  );

  static TextStyle get dayStyle1 {
    return myTextTheme.bodyText1;
  }

  static TextStyle get dayStyle2 {
    return myTextTheme.bodyText2;
  }

  static TextStyle get titleTextStyle {
    return myTextTheme.headline2;
  }

  static TextStyle get normalTextStyle {
    return myTextTheme.headline3;
  }

  static TextStyle get smallTextStyle {
    return myTextTheme.headline4;
  }

  static TextStyle get tinyTextStyle {
    return myTextTheme.headline5;
  }

  static TextStyle get minimumTextStyle {
    return myTextTheme.headline6;
  }
  
  static final TextStyle editItemTitleStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle editItemContentStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.normal,
  );

  static Color getTitleColor(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return theme.colorScheme.onBackground;
  }

  static Color getTitleColorWithOpacity(BuildContext context, double opacity) {
    return getTitleColor(context).withOpacity(opacity);
  }

}