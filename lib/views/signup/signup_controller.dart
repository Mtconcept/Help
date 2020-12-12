import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help/shared_views/loading_dialog.dart';
import 'package:help/views/home.dart';

class SingUpController extends GetxController {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController kinNameController = TextEditingController();
  TextEditingController kinAddressController = TextEditingController();

  void signUpClicked() async {
    String name = fullNameController.text.trim();
    String kName = kinNameController.text.trim();
    String kAddress = kinAddressController.text.trim();

    if (name.isEmpty || kName.isEmpty || kAddress.isEmpty) {
      Get.rawSnackbar(
          messageText: Text(
        "Please fill up the form correctly",
        style: TextStyle(color: Colors.white),
      ));
      return;
    }
    loadDialog(
      title: "Almost there",
      dismiss: true,
    );
    await Future.delayed(Duration(seconds: 3));

    FirebaseAuth auth = FirebaseAuth.instance;

    User user = auth.currentUser;

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    DocumentReference reference = firestore.collection("users").doc(user.uid);

    Map<String, String> data = {
      "fullName": name,
      "kinName": kName,
      "kAddress": kAddress,
      "acctType": "User",
    };

    await reference.set(data);

    Get.offAll(Home());
  }
}
