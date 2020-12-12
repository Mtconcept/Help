import 'package:flutter/material.dart';
import 'package:help/constants/colors.dart';



class Talk extends StatefulWidget {
  @override
  _TalkState createState() => _TalkState();
}

class _TalkState extends State<Talk> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              Center(
                  child: Image.asset('assets/images/talk big.png', width: 60)),
              SizedBox(height: 25),
              Center(
                  child: Text(
                'Talk To Someone',
                style: TextStyle(fontSize: 20, color: kBgColor),
              )),
              SizedBox(
                height: 24,
              ),
              Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  color: klightGrey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 24.0, left: 16, right: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: kBgColor,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Image.asset(
                                  'assets/images/help 1.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(
                                width: 12,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Text(
                                        'Shola Alison',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w300,
                                            color: kBgColor),
                                      ),
                                      Padding(
                                        padding:EdgeInsets.only(top:28.0),
                                        child: Text(
                                          ' Health Care Agents',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                              color: kBgColor.withOpacity(0.5)),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Image.asset('assets/images/send.png'),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
