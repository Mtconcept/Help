import 'package:flutter/material.dart';
import 'package:help/constants/colors.dart';

import '../constants/buttons.dart';
import '../constants/textFields.dart';

class OTP extends StatefulWidget {
  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  String imagePath = 'assets/images/otp.png';
  int countryCode = 234;
  int phoneNum = 9012345679;
  String OTP = '';

  _pinFields(double width, {bool autofocus}) {
    return Center(
      child: TextField(
//        maxLength: 1,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        autofocus: autofocus ?? false,
        cursorColor: kBgColor,
        keyboardAppearance: Brightness.dark,
        style: TextStyle(
            fontSize: Theme.of(context).textTheme.headline4.fontSize,
            fontWeight: FontWeight.bold),
        showCursor: false,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: kdarktGrey)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: klightGrey)),
          filled: true,
          fillColor: kWhite,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: kWhite)),
        ),
        onChanged: (val) {
          if (val.length == 1) {
            FocusScope.of(context).nextFocus();
            OTP = OTP + val;
            print(OTP);
          } else if (val.length == 0) {
            OTP = OTP.substring(0, -2);
            print(OTP);
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaData = MediaQuery.of(context);
    double _height = _mediaData.size.height -
        _mediaData.padding.top -
        _mediaData.padding.bottom;
    double _width = _mediaData.size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: _height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Image(
                      image: AssetImage(imagePath),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SingleChildScrollView(
                    child: Container(
                      height: _height / 10 * 5,
                      width: _width,
                      padding: EdgeInsets.only(top: 32, left: 32, right: 32),
                      decoration: BoxDecoration(
                        color: klightGrey,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(32),
                          topRight: Radius.circular(32),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Secured\nVerificaton OTP',
                            style: TextStyle(
                                fontSize: 25, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Please type the verifiction code sent to',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.normal),
                          ),
                          Text(
                            '+$countryCode $phoneNum',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 2,
                                  child:
                                      _pinFields(_width / 5, autofocus: false)),
                              Spacer(),
                              Expanded(
                                flex: 2,
                                child: _pinFields(_width / 5),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 2,
                                child: _pinFields(_width / 5),
                              ),
                              Spacer(),
                              Expanded(
                                flex: 2,
                                child: _pinFields(_width / 5),
                              ),
                            ],
                          ),
                          Spacer(),
                          Center(
                            child: MyButtons(
                              color: kBgColor,
                              textColor: kWhite,
                              text: 'verify otp',
                              onPress: () {
                                print('i am pressed');
                              },
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
