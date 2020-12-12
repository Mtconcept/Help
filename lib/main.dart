import 'package:flutter/material.dart';
import 'package:help/views/onboarding.dart';
import 'package:help/views/splashScreen.dart';

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
      home: SplashScreen(),
    );
  }
}
