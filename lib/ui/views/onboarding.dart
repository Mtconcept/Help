import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login/login.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  PageController _pageController;
  int _currentIndex = 0;
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onChangedFunction(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void nextFunction() {
    _pageController.nextPage(duration: _kDuration, curve: _kCurve);
  }

  void register() {
    Get.to(LogIn());

    //  Navigator.of(context).push(MaterialPageRoute(builder: (_) => Register()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            PageView(
              controller: _pageController,
              onPageChanged: onChangedFunction,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/onboarding1.png'),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/onboarding2.png'),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
                top: 16,
                right: 0,
                child: FlatButton(
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  onPressed: register,
                ))
          ],
        ),
      ),
      bottomSheet: _currentIndex == 0
          ? BottomSheet(
              title: 'No More Pain !!!',
              description:
                  'Don’t leave in silence anymore share your current situation with us and watch u take your matter serious.',
              onNextPressed: nextFunction,
            )
          : BottomSheet(
              title: 'A shoulder to lean on',
              description:
                  'We want to be that shoulder you can lean on, any crime related cases should be brought to notice to the socitey as soon as possible.',
              onNextPressed: register,
            ),
    );
  }
}

class BottomSheet extends StatelessWidget {
  final String title;
  final String description;
  final Function onNextPressed;

  const BottomSheet({
    Key key,
    @required this.title,
    @required this.description,
    @required this.onNextPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            description,
            style: TextStyle(fontSize: 14.0),
          ),
          SizedBox(height: 32.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: Color(0x22333333),
                child: InkWell(
                  onTap: onNextPressed,
                  child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xFF333333),
                    child: Icon(Icons.arrow_forward),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
