import 'package:flutter/material.dart';
import '../utilites/colors.dart';
import 'custom_text.dart';
import 'custom_text_btn.dart';

Widget curvyContainer({
  required text1,
  required text2,
  required VoidCallback function,
  required color,
}) {
  return Container(
    alignment: Alignment.bottomCenter,
    width: double.infinity,
    height: 100,
    decoration: BoxDecoration(
      color: color,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          customText(
            text: text1,
            color: AppColor.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          customTextBtn(function: function, text: text2),
        ],
      ),
    ),
  );
}
