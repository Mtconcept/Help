import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:help/constants/colors.dart';

class HomeCard extends StatelessWidget {
  final String title, imgPath;
  final Function pressed;

  const HomeCard({Key key, this.title, this.imgPath, @required this.pressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Expanded(
      child: InkWell(
        onTap: pressed,
        child: Container(
        height: 117,
        width: width,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: kWhite,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[100],
                blurRadius: 10,
                spreadRadius: 5,
                offset: Offset(0, 2),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(imgPath),
              SizedBox(
                height: 8,
              ),
              Text(title,
                  style: TextStyle(
                      color: kBgColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500))
            ],
          ),
        ),
        ),
      ),
    );
  }
}
