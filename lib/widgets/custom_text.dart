import 'package:flutter/material.dart';

Widget customText({
  required String text,
  required color,
  required double fontSize,
  required fontWeight,
  bool needOverflow = false,
  decoration = TextDecoration.none,
  textAlign,
}) {
  return Text(
    text,
    textAlign: textAlign,
    overflow: needOverflow ? TextOverflow.ellipsis : null,
    style: TextStyle(
      decoration: decoration,
      color: color,
      fontSize: fontSize,
      fontWeight: fontWeight,
    ),
  );
}
