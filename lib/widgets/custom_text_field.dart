import 'package:flutter/material.dart';

import '../utilites/colors.dart';

// TODO: Function Widget Or Stateless Widget ?

Widget customTextFormField({
  required TextEditingController? controller,
  required String? Function(String? value)? validate,
  String? label,
  required iconData,
  required String? hint,
  required fillColor,
  required enabledBorderColor,
  required focusBorderColor,
  required errorBorderColor,
  double borderWidth = 2,
  bool hasSuffixButton = false,
  bool visibleText = false,
  bool isEnabled = true,
  IconData? suffixIcon,
  TextInputType type = TextInputType.text,
  VoidCallback? Function(String value)? onChange,
  VoidCallback? textButton,
  VoidCallback? Function()? onTap,
}) =>
    TextFormField(
      controller: controller,
      validator: validate,
      keyboardType: type,
      onChanged: onChange,
      obscureText: visibleText,
      onTap: onTap,
      enabled: isEnabled,
      cursorColor: AppColor.black,
      decoration: InputDecoration(
        // contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        fillColor: fillColor,
        filled: true,
        hintText: hint,
        hintStyle: const TextStyle(
          color: AppColor.pinkClr,
          fontSize: 14,
        ),
        prefixIcon: Icon(iconData),
        suffixIcon: hasSuffixButton
            ? TextButton(
                onPressed: textButton,
                child: Icon(
                  suffixIcon,
                  color: AppColor.pinkClr,
                ),
              )
            : null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: enabledBorderColor,
            width: borderWidth,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: focusBorderColor,
            width: borderWidth,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: errorBorderColor,
            width: borderWidth,
          ),
        ),
      ),
    );
