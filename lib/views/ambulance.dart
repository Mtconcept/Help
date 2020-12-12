import 'package:flutter/material.dart';
import 'package:help/constants/buttons.dart';
import 'package:help/constants/colors.dart';

class Ambulance extends StatefulWidget {
  @override
  _AmbulanceState createState() => _AmbulanceState();
}

class _AmbulanceState extends State<Ambulance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: kBgColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: kWhite,
        elevation: 0,
      ),
      backgroundColor: kWhite,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/ambulance big.png",
              width: 60,
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              'Apapa Fire Station',
              style: TextStyle(color: kBgColor, fontSize: 20),
            ),
            SizedBox(
              height: 16,
            ),
            Text('3Km Away',
                style:
                    TextStyle(color: kBgColor.withOpacity(0.5), fontSize: 16)),
            SizedBox(
              height: 36,
            ),
            MyButtons(
              color: kBgColor,
              textColor: kWhite,
              text: 'Call',
              onPress: () {},
            )
          ],
        ),
      ),
    );
  }
}
