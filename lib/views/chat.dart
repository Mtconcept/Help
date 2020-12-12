import 'package:flutter/material.dart';
import 'package:help/constants/colors.dart';
import 'package:help/constants/textFields.dart';

/// Custom class to emulate the chats
/// We will swap out for messages from Firebase later
class Message {
  final String message;
  final String date;
  final String time;
  final bool isMe;

  Message({
    this.message,
    this.date,
    this.time,
    this.isMe,
  });
}

class Chat extends StatelessWidget {
  final List<Message> messages = <Message>[
    Message(
      date: '1/12/2020',
      isMe: true,
      message: 'Can you see the injury this is what he left me with',
      time: '4:00 PM',
    ),
    Message(
      date: '1/12/2020',
      isMe: false,
      message:
          'Been keeping this for long i just needed to spill it out as soon as possible in 2010, i had a car that i bought for my wife she gave her boyfriend then but we settled it again now i need to know can i still do the same thing to people outside the oripo',
      time: '2:00 PM',
    ),
    Message(
      date: '1/12/2020',
      isMe: true,
      message: 'Hi dear how may i help',
      time: '12:00 PM',
    ),
    Message(
      date: '1/12/2020',
      isMe: false,
      message:
          'Greetings ma good morning i hope your night went well i need to talk to you about something',
      time: '10:00 AM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shola Alison Parole',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
              ),
            ),
            SizedBox(height: 5),
            Text(
              'Health Care Agent',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        backgroundColor: kBgColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ChatItem(
                  date: messages[index].date,
                  isUser: messages[index].isMe,
                  time: messages[index].time,
                  message: messages[index].message,
                );
              },
            ),
          ),
          chatTextField,
        ],
      ),
    );
  }
}

Widget get chatTextField => Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 11,
              child: MyTextFields(
                fillColor: Color(0xFFF6F6F6),
                fieldTitle: 'Type Message',
                maxline: 1,
                inputType: TextInputType.text,
              ),
            ),
            Expanded(
              flex: 2,
              child: RaisedButton(
                padding: EdgeInsets.all(12),
                color: kBgColor,
                onPressed: () {},
                child: Icon(
                  Icons.arrow_forward,
                  color: kWhite,
                ),
              ),
            )
          ],
        ),
      ),
    );

class ChatItem extends StatelessWidget {
  final String message;
  final String date;
  final String time;
  final bool isUser;

  const ChatItem({
    Key key,
    this.message,
    this.date,
    this.time,
    this.isUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isUser ? Color(0xFFF6F6F6) : kBgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.only(top: 16, right: 16, left: 16),
          padding: EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 16,
                  color: isUser ? kBgColor : kWhite,
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: isUser ? kBgColor : kWhite,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    time,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: isUser ? kBgColor : kWhite,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
