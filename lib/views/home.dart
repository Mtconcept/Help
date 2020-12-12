import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:help/constants/buttons.dart';
import 'package:help/constants/colors.dart';
import 'package:help/constants/homeCard.dart';
import 'package:help/views/ambulance.dart';
import 'package:help/views/raise_claim/raise_claim.dart';
import 'package:help/views/recorder.dart';
import 'package:help/views/talk.dart';
import 'package:share/share.dart';
import 'package:tutorial_coach_mark/target_focus.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List<TargetFocus> targets = [];
  Position currentPosition;
  String currentAddress = '';
  Timer timer;
  double progress = 0;
  bool isLoading = false;
  AnimationController controller;
  Animation animation;

  final Geolocator _geolocator = Geolocator()..forceAndroidLocationManager;

  _getLocation() {
    _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        currentPosition = position;
        // print(currentPosition);
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await _geolocator.placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        currentAddress =
            "${place.thoroughfare},${place.locality},${place.administrativeArea}";
        // print(currentAddress);
      });
    } catch (e) {
      print(e);
    }
  }

  void setLoadTime() {
    timer = Timer.periodic(Duration(milliseconds: 1000), (time) {
      setState(() {
        progress += 1;
      });
      if (progress == 5) {
        timer.cancel();
        progress = 0;
        showDialog(
            context: context,
            builder: (context) => Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    height: 400,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Text(
                            'Select an emergency',
                            style: TextStyle(
                                fontSize: 24,
                                color: kdarktGrey,
                                decoration: TextDecoration.none),
                          ),
                        ),
                        FlatButton(
                          child: Text(
                            'Accident',
                            style: TextStyle(color: kBgColor, fontSize: 16),
                          ),
                          onPressed: () => null,
                        ),
                        FlatButton(
                          child: Text(
                            'Fire Outbreak',
                            style: TextStyle(color: kBgColor, fontSize: 16),
                          ),
                          onPressed: () => null,
                        ),
                        FlatButton(
                          child: Text(
                            'Rape Allegation',
                            style: TextStyle(color: kBgColor, fontSize: 16),
                          ),
                          onPressed: () => null,
                        ),
                        FlatButton(
                          child: Text(
                            'Fight Outbreak',
                            style: TextStyle(color: kBgColor, fontSize: 16),
                          ),
                          onPressed: () => null,
                        ),
                        FlatButton(
                          child: Text(
                            'Other',
                            style: TextStyle(color: kBgColor, fontSize: 16),
                          ),
                          onPressed: () => null,
                        ),
                      ],
                    ),
                  ),
                ));
      }
    });
  }

  void resetCounter() {
    timer.cancel();
    setState(() {
      progress = 0;
    });
  }

  @override
  void initState() {
    super.initState();
    isLoading = false;
    controller = AnimationController(
        duration: Duration(
          milliseconds: 1000,
        ),
        vsync: this);

    animation = Tween(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: controller, curve: Curves.linear));
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: true);

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: klightGrey,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: height / 2,
              width: width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  color: kWhite),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.location_on,
                              ),
                              onPressed: () {
                                _getLocation();
                              },
                              color: kBgColor,
                            ),
                            currentAddress != ''
                                ? Text(currentAddress,
                                    style: TextStyle(
                                        fontSize: 14, color: kBgColor))
                                : Text('Tap to enable Location',
                                    style: TextStyle(
                                        fontSize: 14, color: kBgColor))
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.notifications_active,
                              color: kBgColor,
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 26,
                    ),
                    Center(
                        child: GestureDetector(
                            onTapDown: (_) => setLoadTime(),
                            onTapUp: (details) => resetCounter(),
                            child: Image.asset('assets/images/alarm.png'))),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      'Tap Incase of an Emergency',
                      style: TextStyle(color: kBgColor, fontSize: 16),
                    ),
                    SizedBox(
                      height: 26,
                    ),
                    MyButtons(
                      color: klightGrey,
                      textColor: kBgColor,
                      text: 'Send Live Location',
                      onPress: () {
                        Share.share(
                            'Hey There You can Find me Here --- $currentAddress');
                      },
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    Container(
                      width: width,
                      height: 60,
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: kdarktGrey.withOpacity(0.2),
                        ),
                      ),
                      child: AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) => Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Hold Emergency button Down for 10 second',
                                    style: TextStyle(
                                      color: kBgColor,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    '$progress',
                                    style: TextStyle(
                                        color: kBgColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12.0),
                              child: LinearProgressIndicator(
                                backgroundColor: klightGrey,
                                value: double.parse(progress.toString()) / 5,
                                valueColor: AlwaysStoppedAnimation(kBgColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        children: [
                          HomeCard(
                            pressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => RaiseClaim()));
                            },
                            imgPath: 'assets/svgs/claim.svg',
                            title: 'Raise a\nClaim ',
                          ),
                          SizedBox(
                            width: 36,
                          ),
                          HomeCard(
                            pressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Recorder()));
                            },
                            imgPath: 'assets/svgs/record.svg',
                            title: 'Record\nVoice',
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        children: [
                          HomeCard(
                            pressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Talk()));
                            },
                            imgPath: 'assets/svgs/talk.svg',
                            title: 'Talk to\nSomeone',
                          ),
                          SizedBox(
                            width: 36,
                          ),
                          HomeCard(
                            pressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Ambulance()));
                            },
                            imgPath: 'assets/svgs/ambulance.svg',
                            title: 'Call\nAmbulance',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
