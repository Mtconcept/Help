import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:help/app/locator.dart';
import 'package:help/core/utils/storageUtil.dart';
import 'package:help/ui/constants/colors.dart';

import 'splash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  AnimationController _controller;
  // Animation animation;
  @override
  void initState() {
    super.initState();
    locator<StorageUtil>().init();
    _controller = AnimationController(
      duration: Duration(milliseconds: 2000),
      upperBound: 100, vsync: this,
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

    // Timer(
    //   Duration(seconds: 5),
    //       () => Navigator.of(context)
    //       .push(MaterialPageRoute(builder: (context) => Onboarding())),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashScreenController>(
        init: SplashScreenController(),
        builder: (model) {
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
        });
  }
}
