import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help/app/locator.dart';
import 'package:help/core/models/contacts.dart';
import 'package:help/core/utils/storageUtil.dart';
import 'package:help/core/services/firestore.dart';

class TalkController extends GetxController {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FireStoreServices _storeServices = locator<IFireStoreServices>();
  // bool isLoading = true;
  // bool hasError = false;
  List<Contacts> _users = [];
  Map<String, String> docs = Map<String, String>();

  //
  StreamController<List<Contacts>> _controller =
      StreamController<List<Contacts>>.broadcast();
  // StreamSubscription<List<Contacts>> _subscription;
  StreamSubscription<QuerySnapshot> _chatsub;

  @override
  void onInit() {
    bool isEnabled = _firestore.settings.persistenceEnabled;
    loading();
    super.onInit();
  }

  @override
  void onClose() {
    _chatsub.cancel();
    // _subscription.cancel();
    super.onClose();
  }

  void loading() {
    _chatsub = getchatsIds().listen(chatsIdsTransformer);
    Stream<List<Contacts>> usersDb = _firestore
        .collection("users")
        .doc(isActivist ? "regular_users" : "social_activist")
        .collection("users")
        .snapshots()
        .transform(transformer());
    _controller.addStream(usersDb).asStream();
    // _subscription = _controller.stream.listen(listOfUsers);
  }

  StreamTransformer<QuerySnapshot, List<Contacts>> transformer() =>
      new StreamTransformer.fromHandlers(handleData: listOfUsers);

  Stream<QuerySnapshot> getchatsIds() {
    return _firestore
        .collection('chats')
        .doc(isActivist ? 'social_activist' : 'regular_user')
        .collection(currentUser)
        .snapshots();
  }

  void chatsIdsTransformer(QuerySnapshot data) {
    {
      data.docs?.forEach((doc) {
        List<String> id = doc.id.split('Time');
        if (docs.isEmpty) {
          docs.addAll({id[0]: id[1]});
        } else if (!docs.containsKey(id[0])) {
          docs.addAll({id[0]: id[1]});
        } else {
          docs.update(id[0], (value) => id[1]);
        }
      });
      // print(docs);
    }
  }

  void listOfUsers(QuerySnapshot usersDb, EventSink<List<Contacts>> sink) {
    try {
      Map<String, String> chats = docs;
      for (DocumentSnapshot user in usersDb.docs) {
        // check if user is an activist
        if (isActivist) {
          for (MapEntry<String, String> contact in chats?.entries) {
            if (contact.key == user.id) {
              List<String> vars = contact.value.split('seconds=');
              String seconds = vars[1].split(',')[0];
              String nanoseconds = vars[2].split(')')[0];
              // print('unread is $unRead\n vars is $vars');
              Contacts newContact = Contacts(
                details: user,
                seconds: int.parse(seconds),
                nanoseconds: int.parse(nanoseconds),
                uid: contact.key,
              );
              _users.add(newContact);
            }
          }
        } else {
          List contact = chats.entries
                  ?.where((element) => element.key == user.id)
                  ?.toList() ??
              [];

          if (contact.isNotEmpty) {
            List<String> vars = contact[0]?.value?.split('seconds=');
            String seconds = vars[1]?.split(',')[0];
            String nanoseconds = vars[2]?.split(')')[0];

            Contacts newContact = Contacts(
              details: user,
              uid: user.id,
              seconds: int.parse(seconds) ?? null,
              nanoseconds: int.parse(nanoseconds) ?? null,
            );
            _users.add(newContact);
            update();
          }
        }
      }

      // sort to arrange according to latest
      _users.sort((a, b) => b?.time?.compareTo(a?.time));
      sink.add(_users);
      // if (isLoading) isLoading = false;
      // update();
    } catch (e) {
      print(e.toString());
      Get.rawSnackbar(
          messageText: Text(
        'Error occured, pls check your internet',
        style: TextStyle(color: Colors.white),
      ));
    }
  }

  Stream<int> getUnreads(String userId) {
    return _storeServices.getUnreads(userId);
  }

  // List<Contacts> get users => _users;
  StreamController<List<Contacts>> get controller => _controller;
  bool get isActivist => locator<StorageUtil>().isActivist;
  String get currentUser => _storeServices.currentUserId;
}

// void sendMessage(String message, bool isActivist) {
//   bool isActivists = false;
//   try {
//     //senders db
//     DocumentReference sender = _firestore
//         .collection('chats')
//         .doc(isActivists ? 'social_activist' : 'regular_user')
//         .collection('craHtpg4TAPnsTfBosWE2ZHmUO33')
//         .doc('WQ5BHHCGTjWz2zkd0XFUz9d6QIK2' + Timestamp.now().toString());
//     sender.set({
//       'isSender': true,
//       'receiverId': 'WQ5BHHCGTjWz2zkd0XFUz9d6QIK2',
//       'senderId': 'craHtpg4TAPnsTfBosWE2ZHmUO33',
//       'text': message,
//       'time': Timestamp.now(),
//       'isRead': true,
//     });
//     //receivers db
//     DocumentReference receiver = _firestore
//         .collection('chats')
//         .doc(isActivists ? 'regular_user' : 'social_activist')
//         .collection('WQ5BHHCGTjWz2zkd0XFUz9d6QIK2')
//         .doc('craHtpg4TAPnsTfBosWE2ZHmUO33' + Timestamp.now().toString());
//     receiver.set({
//       'isSender': false,
//       'receiverId': 'WQ5BHHCGTjWz2zkd0XFUz9d6QIK2',
//       'senderId': 'craHtpg4TAPnsTfBosWE2ZHmUO33',
//       'text': message,
//       'time': Timestamp.now(),
//       'isRead': false,
//     });
//   } catch (e) {
//     print('send message: $e');
//   }
// }
