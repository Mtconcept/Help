import 'dart:async';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:help/app/locator.dart';
import 'package:help/core/utils/storageUtil.dart';
import 'package:help/ui/constants/buttons.dart';
import 'package:help/ui/constants/colors.dart';
import 'package:help/ui/constants/homeCard.dart';
import 'package:help/ui/views/emergency_service/ambulance.dart';
import 'package:help/ui/views/recorder.dart';
import 'package:help/ui/views/talk/talk.dart';
import 'package:share/share.dart';
import 'raise_claim/raise_claim.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  Position currentPosition;
  String currentAddress = '';
  Timer timer;
  double progress = 0;
  bool isLoading = false;
  AnimationController controller;
  Animation animation;

  final Geolocator _geolocator = Geolocator()..forceAndroidLocationManager;

  checkStatus() {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.currentUser.getIdTokenResult(true).then((user) {
      print(user.claims);
      locator<StorageUtil>().isActivist = user.claims['isActivist'];
    });
    //  print(auth.currentUser.uid);
  }

  makeAdmin() {
    FirebaseAuth auth = FirebaseAuth.instance;
    CloudFunctions _functions = CloudFunctions.instance;
    HttpsCallable function =
        _functions.getHttpsCallable(functionName: 'addAdminRole');
    function.call(<String, dynamic>{
      'phoneNumber': auth.currentUser.phoneNumber
    }).then((value) {
      print(value.data);
      checkStatus();
    }).catchError((onError) => {
          print(onError.toString()),
        });
  }

  makeActivist(bool value) {
    locator<StorageUtil>().isActivist = value;
    FirebaseAuth auth = FirebaseAuth.instance;
    CloudFunctions _functions = CloudFunctions.instance;
    HttpsCallable function =
        _functions.getHttpsCallable(functionName: 'changeActivistStatus');
    function
        .call(<String, dynamic>{
          'phoneNumber': auth.currentUser.phoneNumber,
          'isActivist': value,
        })
        .then((value) => {
              print(value.data),
              checkStatus(),
            })
        .catchError((onError) => {
              print(onError.toString()),
            });
  }

  Future<bool> _getLocation() async {
    _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.bestForNavigation)
        .then((Position position) async {
      setState(() {
        currentPosition = position;
        // print(currentPosition);
      });
      _getAddressFromLatLng();
      return true;
    }).catchError((e) {
      print(e);
    });
    return false;
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await _geolocator.placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        currentAddress =
            "${place.thoroughfare},${place.locality},${place.administrativeArea}";
        print(currentAddress);
      });
    } catch (e) {
      print('Error is : ' + e.toString());
    }
  }

  void setLoadTime() {
    timer = Timer.periodic(Duration(milliseconds: 1000), (time) {
      setState(() {
        progress += 1;
      });
      if (progress == 5) {
        resetCounter();
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
    // makeAdmin();
    // makeActivist(true);
    // test();
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
                      onPress: () async {
                        _getLocation();
                        if (currentAddress != '') {
                          Share.share(
                              'Hey There You can Find me Here --- $currentAddress');
                          print(currentAddress);
                        } else {
                          Get.snackbar('No Location ',
                              'No location currently available');
                        }
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
                                    'Hold Emergency button Down for 5 second',
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
                              Get.to(Talk());
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => Talk()));
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
                                  builder: (context) => EmergencysCenters()));
                            },
                            imgPath: 'assets/svgs/ambulance.svg',
                            title: 'Emergency\nServices',
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
