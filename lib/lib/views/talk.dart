import 'package:flutter/material.dart';
import 'package:help/constants/colors.dart';
import 'package:help/views/chat.dart';

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
                },
              ),
              Center(
                child: Image.asset('assets/images/talk big.png', width: 60),
              ),
              SizedBox(height: 25),
              Center(
                child: Text(
                  'Talk To Someone',
                  style: TextStyle(fontSize: 20, color: kBgColor),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Container(
                width: width,
                height: height,
                padding: EdgeInsets.only(top: 32),
                decoration: BoxDecoration(
                  color: klightGrey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  children: [
                    ChatTile(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => Chat()),
                        );
                      },
                      date: '12/02/2012',
                      jobPosition: 'Health Care Agents',
                      name: 'Shola Alison Parole',
                      unreads: 1,
                    ),
                    ChatTile(
                      date: '12/02/2012',
                      jobPosition: 'Health Care Agents',
                      name: 'Shola Alison Parole',
                      unreads: 3,
                    ),
                    ChatTile(
                      date: '12/02/2012',
                      jobPosition: 'Health Care Agents',
                      name: 'Shola Alison Parole',
                      unreads: 3,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChatTile extends StatelessWidget {
  final String name;
  final String jobPosition;
  final String date;
  final int unreads;
  final void Function() onPressed;

  const ChatTile({
    Key key,
    this.name,
    this.jobPosition,
    this.onPressed,
    this.date,
    this.unreads,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: kBgColor),
                ),
                unreads != null
                    ? CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 12,
                        child: Text('$unreads'),
                      )
                    : Container(),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  jobPosition,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: kBgColor.withOpacity(0.5)),
                ),
                Text(
                  date,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: kBgColor.withOpacity(0.5)),
                ),
              ],
            ),
            Divider(),
          ],
        ),
      ),
    );
  }
}
