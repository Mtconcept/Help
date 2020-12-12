import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:help/app/locator.dart';
import 'package:help/core/models/message.dart';
import 'package:help/core/services/firestore.dart';

class FireStoreUtils {
  static FireStoreServices _storedb = locator<IFireStoreServices>();
  // String currentUserId = FirebaseAuth.instance.currentUser.uid;
  // bool isActivist = locator<StorageUtil>().isActivist;

  static StreamTransformer<QuerySnapshot, List<Message>> transformer(
      String recipientId) {
    return StreamTransformer<QuerySnapshot, List<Message>>.fromHandlers(
      handleData: (QuerySnapshot data, EventSink<List<Message>> sink) {
        final chats = data.docs
            .where((element) => element.id.startsWith(recipientId))
            .toList();
        List<Message> formattedChats =
            chats.map((chat) => convertToMessage(chat, recipientId)).toList();
        sink.add(formattedChats);
      },
    );
  }

  static Message convertToMessage(
      QueryDocumentSnapshot chat, String recipientId) {
    _storedb.readMessage(chat, recipientId);
    return Message(
      date: chat.data()['time'].toDate().toString().substring(0, 10),
      isUser: chat.data()['isSender'],
      time: chat.data()['time'].toDate().toString().substring(11, 16),
      message: chat.data()['text'],
      isRead: _storedb.checkReadStatus(chat.id, recipientId),
      taggedMessage: chat.data()['taggedMessage'],
    );
  }
}
