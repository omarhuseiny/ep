import 'package:flutter/material.dart';

import 'custom_text.dart';

Widget rowSpanText({
  required text1,
  required text2,
  required color1,
  color2,
  double fontSize = 30,
  TextDecoration decoration = TextDecoration.underline,
  fontWeight = FontWeight.bold,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      customText(
        text: text1,
        color: color1,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      customText(
        text: text2,
        color: color2 ?? color1,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: decoration,
      ),
    ],
  );
}
