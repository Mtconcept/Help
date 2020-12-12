import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:help/constants/colors.dart';

class MyTextFields extends StatelessWidget {
  final TextEditingController controller;
  final String fieldTitle;
  final int maxLength;
  final int maxline;
  final TextInputType inputType;
  final Function onChange;

  const MyTextFields(
      {Key key,
      this.controller,
      this.fieldTitle,
      this.maxLength,
      this.maxline,
      this.inputType,
        this.onChange,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      selectionWidthStyle: BoxWidthStyle.max,
      maxLength: maxLength,
      maxLines: maxline,
      keyboardType: inputType,
      cursorColor: kBgColor,
      controller: controller,
      keyboardAppearance: Brightness.dark,
      decoration: InputDecoration(
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        hintText: fieldTitle,
        hintStyle: TextStyle(color: kBgColor.withOpacity(0.5)),
        filled: true,
        fillColor: kWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: onChange,
    );
  }
}
