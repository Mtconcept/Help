import 'package:flutter/material.dart';
import 'package:help/constants/buttons.dart';
import 'package:help/constants/colors.dart';
import 'package:help/constants/textFields.dart';
import 'package:help/views/login.dart';

class SignUp extends StatelessWidget {
  String imagePath = 'assets/images/signup.png';
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _phoneNumController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _kinNameController = TextEditingController();
  TextEditingController _kinAddressController = TextEditingController();
  // dynamic _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaData = MediaQuery.of(context);
    double _height = _mediaData.size.height -
        _mediaData.padding.top -
        _mediaData.padding.bottom;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: _height,
          child: Column(
            children: [
              Image(
                image: AssetImage(imagePath),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: SingleChildScrollView(
        child: Container(
          height: _height / 10 * 7,
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: klightGrey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Form(
            // key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Let\'s Have Your\nInformation',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                MyTextFields(
                  controller: _fullNameController,
                  fieldTitle: 'Full Name*',
                ),
                SizedBox(
                  height: 30,
                ),
                MyTextFields(
                  controller: _kinNameController,
                  fieldTitle: 'Next Of Kin Name',
                ),
                SizedBox(
                  height: 30,
                ),
                MyTextFields(
                  controller: _kinAddressController,
                  fieldTitle: 'Next of Kin Address',
                ),
                SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Center(
                    child: MyButtons(
                      color: kBgColor,
                      textColor: kWhite,
                      text: 'CREATE ACCOUNT',
                      onPress: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => LogIn()));
                      },
                    ),
                  ),
                ),
                // Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
