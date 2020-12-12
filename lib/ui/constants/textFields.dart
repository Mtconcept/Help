import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:help/ui/constants/colors.dart';

class MyTextFields extends StatelessWidget {
  final TextEditingController controller;
  final String fieldTitle;
  final int maxLength;
  final int maxline;
  final Color fillColor;
  final TextInputType inputType;
  final FocusNode focusNode;
  final Function onChange;
  final TextCapitalization capitalization;
  final Function(String val) validator;
  final Function() onEditingComplete;

  const MyTextFields({
    Key key,
    this.controller,
    this.fieldTitle,
    this.maxLength,
    this.fillColor = kWhite,
    this.maxline,
    this.inputType,
    this.focusNode,
    this.onChange,
    this.capitalization = TextCapitalization.none,
    this.validator,
    this.onEditingComplete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      focusNode: focusNode,
      // selectionWidthStyle: BoxWidthStyle.max,
      maxLength: maxLength,
      maxLines: maxline,
      keyboardType: inputType,
      cursorColor: kBgColor,
      controller: controller,
      keyboardAppearance: Brightness.dark,
      textCapitalization: capitalization,
      onEditingComplete: onEditingComplete,
      decoration: InputDecoration(
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
        errorStyle: TextStyle(
            fontSize: 12, fontWeight: FontWeight.normal, color: kBgColor),
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        hintText: fieldTitle,
        hintStyle: TextStyle(color: kBgColor.withOpacity(0.5)),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onChanged: onChange,
    );
  }
}
