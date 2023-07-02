import 'package:flutter/material.dart';
import 'custom_text.dart';

Widget customBtn({
  required String text,
  required color,
  required VoidCallback function,
  double width = 350,
  borderColor,
  textColor,
}) {
  return ElevatedButton(
    onPressed: function,
    style: ElevatedButton.styleFrom(
      minimumSize: Size(width, 50),
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: BorderSide(
          color: borderColor ?? color,
          width: 2.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 25,
      ),
    ),
    child: customText(
      text: text,
      color: textColor,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  );
}
