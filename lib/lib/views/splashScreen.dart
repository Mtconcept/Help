import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help/constants/colors.dart';
import 'package:help/views/login.dart';
import 'package:help/views/onboarding.dart';
import 'package:help/views/register.dart';
import 'package:help/views/signUp.dart';

import 'otp.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 5),
      () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LogIn())),
    );
    super.initState();
  }

  void animation() {}
  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBgColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/help 1.png'),
            SizedBox(
              height: 8,
            ),
            AnimatedDefaultTextStyle(
              curve: Curves.bounceIn,
              duration: Duration(milliseconds: 1500),
              child: Text(
                'Help Me',
              ),
              style: TextStyle(
                  color: kWhite, fontSize: 30, decoration: TextDecoration.none),
            )
          ],
        ),
      ),
    );
  }
}
