import 'package:flutter/cupertino.dart';

class TextUtils {

  static TextPainter _painter = TextPainter();

  static Size measureText({
    String text,
    TextStyle style,
    TextDirection textDirection = TextDirection.ltr,
  }) {
    _painter.textDirection = textDirection;
    _painter.text = TextSpan(
      text: text,
      style: style,

    );
    _painter.layout();

    return Size(_painter.width, _painter.height);
  }

}