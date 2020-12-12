import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help/ui/constants/buttons.dart';
import 'package:help/ui/constants/colors.dart';
import 'package:help/ui/constants/textFields.dart';
import 'signup_controller.dart';

class SignUp extends StatelessWidget {
  final String imagePath = 'assets/images/signup.png';

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaData = MediaQuery.of(context);
    double _height = _mediaData.size.height -
        _mediaData.padding.top -
        _mediaData.padding.bottom;
    return GetBuilder<SignUpController>(
        init: SignUpController(),
        builder: (model) {
          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  height: _height,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Column(
                        children: [
                          Image(
                            image: AssetImage(imagePath),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: _height / 10 * 7,
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
                                // key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Let\'s Have Your\nInformation',
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    MyTextFields(
                                      controller: model.fullNameController,
                                      fieldTitle: 'Full Name*',
                                      inputType: TextInputType.name,
                                      onEditingComplete: () =>
                                          FocusScope.of(context).nextFocus(),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    MyTextFields(
                                      controller: model.kinNameController,
                                      fieldTitle: 'Next Of Kin Name',
                                      inputType: TextInputType.name,
                                      onEditingComplete: () =>
                                          FocusScope.of(context).nextFocus(),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    MyTextFields(
                                      controller: model.kinAddressController,
                                      fieldTitle: 'Next of Kin Address',
                                      inputType: TextInputType.streetAddress,
                                      onEditingComplete: () =>
                                          FocusScope.of(context).nextFocus(),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Center(
                                      child: MyButtons(
                                        color: kBgColor,
                                        textColor: kWhite,
                                        text: 'CREATE ACCOUNT',
                                        onPress: () {
                                          model.signUpClicked();
                                        },
                                      ),
                                    ),
                                    // Spacer()
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
            ),
          );
        });
  }
}
