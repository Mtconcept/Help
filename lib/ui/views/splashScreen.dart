import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help/app/locator.dart';
import 'package:help/constants/colors.dart';
import 'package:help/core/utils/storageUtil.dart';
import 'package:help/views/onboarding.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  StorageUtil _storageUtil = locator<StorageUtil>();
  // Animation animation;
  @override
  void initState() {
    _storageUtil.init();
    Timer(
      Duration(seconds: 5),
      () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Onboarding())),
    );
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      upperBound: 100,
      vsync: this,
    );
    _controller.forward();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBgColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/svgs/Helplogo.svg',
              height: _controller.value,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              'Help Me',
              style: TextStyle(
                  color: kWhite,
                  fontSize: 30,
                  fontFamily: 'Gilroy',
                  decoration: TextDecoration.none),
            )
          ],
        ),
      ),
    );
  }
}
