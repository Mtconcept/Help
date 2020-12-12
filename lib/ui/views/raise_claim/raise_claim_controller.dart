import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help/core/models/claim.dart';
import 'package:help/core/services/backend/backend.dart';
import '../../shared_views/loading_dialog.dart';
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

    loadDialog(
      title: "Please wait...",
      dismiss: true,
    );

    FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;

    Claim claim = Claim(
      age: int.parse(ageEditingController.text),
      name: nameEditingController.text,
      claim: claimEditingController.text,
      gender: gender,
      dateTime: DateTime.now().toIso8601String(),
      userId: user.uid,
    );

    await Get.find<Backend>().sendClaim(claim);

    Get.offAll(Home());
  }
}
