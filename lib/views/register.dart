import 'package:flutter/material.dart';
import 'package:help/constants/buttons.dart';
import 'package:help/constants/colors.dart';
import 'package:help/constants/textFields.dart';
import 'package:help/views/signUp.dart';

class LogIn extends StatelessWidget {
  String imagePath = 'assets/images/login.png';
  TextEditingController _phoneNumController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
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
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Image(
                  image: AssetImage(imagePath),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: SingleChildScrollView(
        child: Container(
          height: _height / 5 * 2,
          padding: EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: klightGrey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Hi Welcome,\nPls Add Your Number',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              MyTextFields(
                controller: _phoneNumController,
                fieldTitle: 'Phone Number*',
                maxline: 1,
                inputType: TextInputType.phone,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'This field is required',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                ),
              ),
              // MyTextFields(
              //   controller: _passwordController,
              //   fieldTitle: 'Password*',
              // ),
              Spacer(),
              Align(
                alignment: Alignment.center,
                child: MyButtons(
                  color: kBgColor,
                  textColor: kWhite,
                  text: 'get started',
                  onPress: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SignUp()));
                  },
                ),
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
