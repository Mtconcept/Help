import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help/app/locator.dart';
import 'package:help/core/models/message.dart';
import 'package:help/core/services/firestore.dart';

class ChatControlller extends GetxController {
  final String currentUserId, recipientId;
  final bool isActivist;
  ScrollController scrollController = ScrollController();
  FireStoreServices _storeServices = locator<IFireStoreServices>();
  ChatControlller({this.currentUserId, this.recipientId, this.isActivist});
  String taggedMessage;

  StreamController<List<Message>> _controller =
      StreamController<List<Message>>.broadcast();

  @override
  void onInit() {
    // print('\n\n $currentUserId \n\n\n $recipientId');
    _controller.addStream(_storeServices.listOfChats(recipientId)).asStream();
    super.onInit();
  }

  void sendMessage(String message) {
    _storeServices.sendMessage(message, taggedMessage, recipientId);
    onCancel();
  }

  void onSwipe(String message) {
    taggedMessage = message;
    update();
  }

  void onCancel() {
    taggedMessage = null;
    update();
  }

  StreamController<List<Message>> get controller => _controller;
}
