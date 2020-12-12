import 'package:flutter/material.dart';

class MyButtons extends StatelessWidget {
  final Color color, textColor;
  final String text;
  final Function onPress;

  const MyButtons(
      {Key key, this.color, this.text, this.textColor, this.onPress})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPress,
      child: Text(text.toUpperCase(),
          style: TextStyle(
            color: textColor,
            fontSize: 16,
          )),
      color: color,
      padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }
}
