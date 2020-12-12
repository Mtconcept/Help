import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:help/constants/colors.dart';
import 'package:help/constants/textFields.dart';

/// Custom class to emulate the chats
/// We will swap out for messages from Firebase later
// class Message {
//   final String message;
//   final String date;
//   final String time;
//   final bool isMe;
//   final String receiverId, senderId;
//
//   Message({
//     this.message,
//     this.date,
//     this.time,
//     this.isMe,
//     this.receiverId,
//     this.senderId,
//   });
// }

class Chat extends StatelessWidget {
  final String currentUserId;
  final QueryDocumentSnapshot recipientInfo;
  final bool isActivist;

  Chat({Key key, this.currentUserId, this.recipientInfo, this.isActivist})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(isActivist);
    Store _store = Store(
      currentUserId: currentUserId,
      recipientId: recipientInfo.id,
      isActivist: isActivist,
    );
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              recipientInfo.data()['fullName'],
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
            child: StreamBuilder<QuerySnapshot>(
                stream: _store.listOfMessages(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // print(recipientId);
                    List<QueryDocumentSnapshot> list = snapshot.data.docs;
                    return ListView.builder(
                      reverse: false,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        if ((list[index].data()['receiverId'] ==
                                    recipientInfo.id &&
                                list[index].data()['isSender'] == true) ||
                            (list[index].data()['senderId'] ==
                                    recipientInfo.id &&
                                list[index].data()['isSender'] == false))
                          return convertToChatItem(list, index);
                        return Container();
                      },
                    );
                  } else
                    return Container(color: Colors.red);
                }),
          ),
          ChatTextField(
            store: _store,
          ),
        ],
      ),
    );
  }
}

ChatItem convertToChatItem(List<QueryDocumentSnapshot> snapshot, int index) {
  List<QueryDocumentSnapshot> list = snapshot;
  return ChatItem(
    date: list[index].data()['time'].toDate().toString().substring(0, 10),
    isUser: list[index].data()['isSender'],
    time: list[index].data()['time'].toDate().toString().substring(11, 16),
    message: list[index].data()['text'],
  );
}

class ChatTextField extends StatelessWidget {
  final Store store;
  ChatTextField({
    Key key,
    this.store,
  }) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 11,
              child: Container(
                constraints: BoxConstraints(maxHeight: 200),
                child: MyTextFields(
                  capitalization: TextCapitalization.sentences,
                  controller: _controller,
                  fillColor: Color(0xFFF6F6F6),
                  fieldTitle: 'Type Message',
                  maxline: null,
                  inputType: TextInputType.multiline,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: RaisedButton(
                padding: EdgeInsets.all(12),
                color: kBgColor,
                onPressed: () {
                  store.sendMessage(_controller.text);
                  _controller.clear();
                },
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
  }
}

class ChatItem extends StatelessWidget {
  final String message;
  final String date;
  final String time;
  final bool isUser;
  final String receiverId, senderId;

  const ChatItem({
    Key key,
    this.message,
    this.date,
    this.time,
    this.isUser,
    this.receiverId,
    this.senderId,
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

class Store {
  final String currentUserId, recipientId;
  final bool isActivist;

  Store({this.currentUserId, this.recipientId, this.isActivist});

  FirebaseFirestore _store = FirebaseFirestore.instance;

  void sendMessage(String message) {
    //senders db
    var sender = _store
        .collection('chats')
        .doc(isActivist ? 'social_activist' : 'regular_user')
        .collection(currentUserId)
        .doc(Timestamp.now().toString());
    sender.set({
      'isSender': true,
      'receiverId': recipientId,
      'senderId': currentUserId,
      'text': message,
      'time': Timestamp.now(),
    });

    //receivers db
    var receiver = _store
        .collection('chats')
        .doc(isActivist ? 'regular_user' : 'social_activist')
        .collection(recipientId)
        .doc(Timestamp.now().toString());
    receiver.set({
      'isSender': false,
      'receiverId': recipientId,
      'senderId': currentUserId,
      'text': message,
      'time': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> listOfMessages() {
    try {
      if (isActivist) {
        // print('recipientId is ' + recipientId);
        Stream<QuerySnapshot> userChatDb = _store
            .collection('chats')
            .doc('social_activist')
            .collection(currentUserId)
            .snapshots();
        return userChatDb;
      } else {
        // print('recipientId is ' + recipientId);
        Stream<QuerySnapshot> userChatDb = _store
            .collection('chats')
            .doc('regular_user')
            .collection(currentUserId)
            .snapshots();
        return userChatDb;
      }
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
