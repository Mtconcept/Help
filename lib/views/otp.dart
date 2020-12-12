import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help/constants/colors.dart';
import 'package:help/views/login/login_controller.dart';
import 'package:help/views/signUp.dart';
import '../constants/buttons.dart';

class OTP extends StatefulWidget {
  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  String imagePath = 'assets/images/otp.png';
  // int countryCode = 234;
  // int phoneNum = 9012345679;
//  String OTP = '';

  _pinFields(double width,
      {bool autofocus, TextEditingController editingController}) {
    LoginController controller = Get.find<LoginController>();

    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Center(
        child: TextField(
          controller: editingController,
          maxLength: 1,
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
            counter: Text(''),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: kdarktGrey)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: klightGrey)),
            filled: true,
            fillColor: kWhite,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: kWhite)),
          ),
          onChanged: (val) {
            if (val.length == 1) {
              FocusScope.of(context).nextFocus();
            } else if (val.length == 0) {
              FocusScope.of(context).previousFocus();
            }

            String code = controller.pin1.text.trim() +
                controller.pin2.text.trim() +
                controller.pin3.text.trim() +
                controller.pin4.text.trim() +
                controller.pin5.text.trim() +
                controller.pin6.text.trim();
            controller.otpCode = code;
            print(code);
          },
        ),
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
    return GetBuilder<LoginController>(
      builder: (model) {
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
                          padding:
                              EdgeInsets.only(top: 32, left: 32, right: 32),
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
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                '${model.phoneNumController.text.trim()}',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: _pinFields(_width / 4,
                                          autofocus: false,
                                          editingController: model.pin1)),
                                  Expanded(
                                    flex: 1,
                                    child: _pinFields(_width / 4,
                                        editingController: model.pin2),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: _pinFields(_width / 4,
                                        editingController: model.pin3),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: _pinFields(_width / 4,
                                        editingController: model.pin4),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: _pinFields(_width / 4,
                                        editingController: model.pin5),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: _pinFields(_width / 4,
                                        editingController: model.pin6),
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
                                    model.verifyOtp();
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
      },
    );
  }
}
