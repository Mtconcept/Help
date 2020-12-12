import 'package:flutter/material.dart';
import 'package:help/views/onboarding.dart';
import 'package:help/views/register.dart';
import 'package:help/views/splashScreen.dart';
import 'package:help/views/talk.dart';

void main() {
  runApp(Help());
}

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Gilroy',
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
      ),
      home: Talk(),
    );
  }
}
