import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/claim.dart';
import '../home.dart';

class RaiseClaimController extends GetxController {
  final nameEditingController = TextEditingController();
  final ageEditingController = TextEditingController();
  final claimEditingController = TextEditingController();
  int gender = 0;
  bool isChecked = false;
  bool isLoading = false;

  void setGender(int newGender) {
    gender = newGender;
    update();
  }

  void agreeChecked(bool agree) {
    isChecked = agree;
    update();
  }

  void sendClaim() async {
    if (ageEditingController.text.isEmpty ||
        nameEditingController.text.isEmpty ||
        claimEditingController.text.isEmpty) {
      Get.rawSnackbar(
          messageText: Text(
        "Please fill up the form correctly",
        style: TextStyle(color: Colors.white),
      ));
      return;
    }

    if (isChecked == false) {
      Get.rawSnackbar(
          messageText: Text(
        "Agree to terms and conditions",
        style: TextStyle(color: Colors.white),
      ));
      return;
    }

    Claim claim = Claim(
      age: ageEditingController.text,
      name: nameEditingController.text,
      claim: claimEditingController.text,
      gender: gender,
      dateTime: DateTime.now().toUtc().millisecondsSinceEpoch,
    );

    await FirebaseFirestore.instance.collection('claims').add(claim.toJson());

    Get.off(Home());
  }
}
