import 'package:flutter/material.dart';
import 'package:help/ui/constants/colors.dart';

class ChatItem extends StatelessWidget {
  final String message;
  final String date;
  final String time;
  final bool isUser;
  final String taggedMessage;
  final String receiverId, senderId;
  final Stream<bool> isRead;

  ChatItem({
    Key key,
    this.message,
    this.date,
    this.time,
    this.isUser,
    this.receiverId,
    this.senderId,
    this.isRead,
    this.taggedMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isUser ? Color(0xFFEEEEEE) : kBgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.only(top: 16, right: 16, left: 16),
          padding: EdgeInsets.all(16),
          width: MediaQuery.of(context).size.width * 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              taggedMessage != null ? buildTaggedMessage() : Container(),
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
                  Spacer(),
                  StreamBuilder<bool>(
                    stream: isRead,
                    initialData: null,
                    builder: (__, snapshot) {
                      bool value = snapshot.data;
                      if (!isUser || value == null) {
                        return Container();
                      }
                      return Icon(
                        !value ? Icons.done : Icons.done_all,
                        color: kBgColor.withOpacity(0.7),
                        size: 15,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container buildTaggedMessage() {
    return Container(
      color: isUser
          ? kBgColor
          : klightGrey, //kBgColor, //kdarktGrey.withOpacity(0.3),
      margin: EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 3),
              color: isUser ? klightGrey : kdarktGrey, //klightGrey,
              child: Container(
                padding: EdgeInsets.all(10.0),
                color: isUser
                    ? kdarktGrey.withOpacity(0.3)
                    : kBgColor.withOpacity(0.3), // kdarktGrey.withOpacity(0.3),
                child: Stack(
                  children: [
                    Text(
                      taggedMessage,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        color: isUser ? kBgColor : kWhite,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
