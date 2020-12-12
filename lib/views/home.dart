import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:help/constants/buttons.dart';
import 'package:help/constants/colors.dart';
import 'package:help/constants/homeCard.dart';
import 'package:help/views/ambulance.dart';
import 'package:help/views/raiseClaim.dart';
import 'package:help/views/recorder.dart';
import 'package:help/views/talk.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Position currentPosition;
  String currentAddress;
  int progress = 0;
  bool isLoading;

  final Geolocator _geolocator = Geolocator()..forceAndroidLocationManager;
  _getLocation() {
    _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        currentPosition = position;
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
            "${place.locality},${place.subLocality},${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    progress = 0;
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: klightGrey,
      body: Stack(
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
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                          if (currentPosition != null)
                            Text(
                                isLoading
                                    ? 'Tap Icon to view Address'
                                    : currentAddress.toString(),
                                style:
                                    TextStyle(fontSize: 14, color: kBgColor)),
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
                          onLongPress: () {
                            setState(() {
                              progress++;
                            });
                          },
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
                    onPress: () {},
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
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Hold Emergency button Down for 10 second',
                                style: TextStyle(
                                  color: kBgColor,
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '${(progress * 10).round()}%',
                                style: TextStyle(
                                    color: kBgColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: LinearProgressIndicator(
                            backgroundColor: klightGrey,
                            value: progress.toDouble(),
                            valueColor: AlwaysStoppedAnimation(kBgColor),
                          ),
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
                                builder: (context) => RaiseClaim()));
                          },
                          imgPath: 'assets/images/claim small.png',
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
                          imgPath: 'assets/images/mic small.png',
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
                          imgPath: 'assets/images/talk small.png',
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
                          imgPath: 'assets/images/ambulance small.png',
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
    );
  }

  void moveProgress(value) {
    if (progress < value) {
      progress++;
      value = progress;
    }
  }
}
