import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:help/app/locator.dart';
import 'package:help/core/models/message.dart';
import 'package:help/core/utils/firestore_utils.dart';
import 'package:help/core/utils/storageUtil.dart';

abstract class IFireStoreServices {
  FirebaseFirestore store = FirebaseFirestore.instance;
  String currentUserId = FirebaseAuth.instance.currentUser.uid;
  bool isActivist = locator<StorageUtil>().isActivist;

  
  Stream<List<Message>> listOfChats(String recipientId);
  void sendMessage(String message, String taggedMessage, String recipientId);
  void readMessage(QueryDocumentSnapshot element, String recipientId);
  Stream<bool> checkReadStatus(String id, String recipientId);
  Stream<int> getUnreads(String userId);
}

class FireStoreServices extends IFireStoreServices {
  @override
  Stream<List<Message>> listOfChats(String recipientId) {
    try {
      Stream<List<Message>> userChatDb = store
          .collection('chats')
          .doc(isActivist ? 'social_activist' : 'regular_user')
          .collection(currentUserId)
          .orderBy(FieldPath.fromString('time'), descending: true)
          .snapshots()
          .transform(FireStoreUtils.transformer(recipientId));
      return userChatDb;
    } catch (e) {
      print('\n\n---LIST OF CHATS ERROR---\n $e\n\n');
      throw Exception(e.toString());
    }
  }

  @override
  void sendMessage(String message, String taggedMessage, String recipientId) {
    try {
      final Timestamp time = Timestamp.now();
      //senders db
      DocumentReference sender = store
          .collection('chats')
          .doc(isActivist ? 'social_activist' : 'regular_user')
          .collection(currentUserId)
          .doc(recipientId + time.toString());

      sender.set({
        'isSender': true,
        'receiverId': recipientId,
        'senderId': currentUserId,
        'text': message,
        'time': time,
        'isRead': true,
        'taggedMessage': taggedMessage,
      });
      //receivers db
      DocumentReference receiver = store
          .collection('chats')
          .doc(isActivist ? 'regular_user' : 'social_activist')
          .collection(recipientId)
          .doc(currentUserId + time.toString());
      receiver.set({
        'isSender': false,
        'receiverId': recipientId,
        'senderId': currentUserId,
        'text': message,
        'time': time,
        'isRead': false,
        'taggedMessage': taggedMessage,
      });
    } catch (e) {
      print('\n\n---SEND MESSAGE ERROR---\n $e\n\n');
    }
  }

  @override
  void readMessage(QueryDocumentSnapshot element, String recipientId) {
    try {
      if (element.id.startsWith(recipientId) &&
          element.data()['isRead'] == false) {
        store
            .collection('chats')
            .doc(isActivist ? 'social_activist' : 'regular_user')
            .collection(currentUserId)
            .doc(element.id)
            .update({'isRead': true});
        // print('updated');
      }
    } catch (e) {
      print('\n\n---READ MESSAGE ERROR---\n $e\n\n');
    }
  }

  @override
  Stream<bool> checkReadStatus(String id, String recipientId) {
    try {
      String chatId = currentUserId + id.split(recipientId)[1].trim();

      Stream<bool> chat = store
          .collection('chats')
          .doc(isActivist ? 'regular_user' : 'social_activist')
          .collection(recipientId)
          .doc(chatId)
          .snapshots()
          .transform(StreamTransformer<DocumentSnapshot, bool>.fromHandlers(
            handleData: (DocumentSnapshot data, EventSink<bool> sink) =>
                sink.add(data.data()['isRead']),
          ));
      return chat;
    } catch (e) {
      print('\n\n---CHECK READ STATUS ERROR---\n $e\n\n');
      throw Exception(e.toString());
    }
  }

  @override
  Stream<int> getUnreads(String userId) {
    try {
      Stream<int> number = store
          .collection('chats')
          .doc(isActivist ? 'social_activist' : 'regular_user')
          .collection(currentUserId)
          .where('isSender', isEqualTo: false)
          .where('senderId', isEqualTo: userId)
          .where('isRead', isEqualTo: false)
          .snapshots()
          .transform(new StreamTransformer<QuerySnapshot, int>.fromHandlers(
        handleData: (QuerySnapshot data, EventSink<int> sink) {
          // print(data.docs.length);
          sink.add(data.docs.length);
        },
      ));
      return number;
    } catch (e) {
      print('get unread error: ' + e.toString());
      throw Exception();
    }
  }
}
