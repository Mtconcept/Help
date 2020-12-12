import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help/core/models/message.dart';
import 'package:help/ui/widgets/chat_item.dart';
import 'package:help/ui/constants/colors.dart';
import 'package:help/ui/constants/textFields.dart';
import 'package:help/ui/widgets/tagged_message.dart';
import 'package:swipe_to/swipe_to.dart';

import 'chat_controller.dart';

class Chat extends StatelessWidget {
  final String currentUserId;
  final QueryDocumentSnapshot recipientInfo;
  final bool isActivist;
  FocusNode focusNode = FocusNode();

  Chat({Key key, this.currentUserId, this.recipientInfo, this.isActivist})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatControlller>(
      init: ChatControlller(
        currentUserId: currentUserId,
        recipientId: recipientInfo.id,
        isActivist: isActivist,
      ),
      builder: (model) => Scaffold(
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
              child: StreamBuilder<List<Message>>(
                stream: model.controller.stream,
                builder: (context, snapshot) {
                  List<Message> list = snapshot.data;
                  if (snapshot.hasData && list.isNotEmpty) {
                    // print(recipientId);
                    return ListView.builder(
                      controller: model.scrollController,
                      reverse: true,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        Message message = list[index];
                        // model.readMessage(message);
                        // () {
                        //   model.scrollController.animateTo(list[, duration: null, curve: null)
                        // };
                        return SwipeTo(
                          offsetDx: 0.2,
                          onRightSwipe: () {
                            model.onSwipe(message.message);
                            focusNode.requestFocus();
                          },
                          child: ChatItem(
                            message: message.message,
                            isUser: message.isUser,
                            time: message.time,
                            date: message.date,
                            isRead: message.isRead,
                            taggedMessage: message.taggedMessage,
                          ),
                        );
                      },
                    );
                  } else
                    return Center(
                      child: Text(
                        'No messages between you and ' +
                            recipientInfo.data()['fullName'],
                        style: TextStyle(
                          color: kBgColor.withOpacity(0.7),
                        ),
                      ),
                    );
                },
              ),
            ),
            ChatTextField(
              store: model,
              node: focusNode,
              message: model.taggedMessage,
              onTap: () => model.onCancel(),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatTextField extends StatelessWidget {
  final ChatControlller store;
  final FocusNode node;
  final String message;
  final VoidCallback onTap;
  ChatTextField({
    Key key,
    this.store,
    this.node,
    this.message,
    this.onTap,
  }) : super(key: key);

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Container(
        child: Column(
          children: [
            message != null
                ? TaggedMessage(message: message, onTap: onTap)
                : Container(),
            Row(
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
                      focusNode: node,
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
          ],
        ),
      ),
    );
  }
}