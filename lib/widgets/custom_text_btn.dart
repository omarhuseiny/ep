import 'package:flutter/material.dart';

import '../utilites/colors.dart';
import 'custom_text.dart';

Widget customTextBtn({
  required VoidCallback function,
  required String text,
  decoration = TextDecoration.underline,
  Color color = AppColor.white,
}) {
  return TextButton(
    onPressed: function,
    child: customText(
      decoration: decoration,
      text: text,
      color: color,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  );
}
