import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:get/get.dart';
import '../../constants/buttons.dart';
import '../../constants/colors.dart';
import '../../constants/textFields.dart';
import 'login_controller.dart';

class LogIn extends StatelessWidget {
  final String imagePath = 'assets/images/login.png';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 375, height: 812, allowFontScaling: true);

    MediaQueryData _mediaData = MediaQuery.of(context);
    double _height = _mediaData.size.height -
        _mediaData.padding.top -
        _mediaData.padding.bottom;
    return GetBuilder<LoginController>(
        init: LoginController(),
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
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image(
                            image: AssetImage(imagePath),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
//                    height: _height / 5 * 2,
                          padding: EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: klightGrey,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Get Started With Just Your\nPhone Number',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  MyTextFields(
                                    validator: (val) => val.length < 1
                                        ? 'This field is required'
                                        : null,
                                    maxLength: 11,
                                    focusNode: model.phoneNumberFocus,
                                    controller: model.phoneNumController,
                                    fieldTitle: 'Phone Number*',
                                    maxline: 1,
                                    inputType: TextInputType.phone,
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  // Padding(
                                  //   padding: EdgeInsets.all(8.0),
                                  //   child: Text(
                                  //     'This field is required',
                                  //     style: TextStyle(
                                  //         fontSize: 12,
                                  //         fontWeight: FontWeight.normal),
                                  //   ),
                                  // ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: MyButtons(
                                      color: kBgColor,
                                      textColor: kWhite,
                                      text: 'get started',
                                      onPress: () {
                                        if (_formKey.currentState.validate()) {
                                          model.getStarted();
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
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
        });
  }
}
