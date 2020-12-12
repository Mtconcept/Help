import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help/app/locator.dart';
import 'package:help/core/utils/storageUtil.dart';
import 'package:help/shared_views/loading_dialog.dart';
import 'package:help/views/otp.dart';
import 'package:help/views/signup/signUp.dart';
import '../home.dart';
// import 'fire'

class LoginController extends GetxController {
  TextEditingController phoneNumController = TextEditingController();

  TextEditingController pin1 = TextEditingController();
  TextEditingController pin2 = TextEditingController();
  TextEditingController pin3 = TextEditingController();
  TextEditingController pin4 = TextEditingController();
  TextEditingController pin5 = TextEditingController();
  TextEditingController pin6 = TextEditingController();

  String verificationId;
  int forceResendingToken;

  FirebaseAuth auth = FirebaseAuth.instance;
  StorageUtil _storageUtil = locator<StorageUtil>();

  String otpCode = "";
  void clearPinFields() {
    pin1.clear();
    pin2.clear();
    pin3.clear();
    pin4.clear();
    pin5.clear();
    pin6.clear();
  }

  void getStarted() {
    String phoneNumber = phoneNumController.text;

    if (phoneNumber.isEmpty) {
      _showSnackBar(message: "Please enter a valid phone number");

      return;
    }

    loadDialog(title: "Please Hold on", dismiss: false);

    if (phoneNumber.startsWith("0")) {
      String formattedPhone = phoneNumber.substring(1, phoneNumber.length);
      phoneNumber = "+234$formattedPhone";
    } else {
      phoneNumber = "+234$phoneNumber";
    }

    //   phoneNumber ="+2348036007161";

    auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: (verificationId, forceResendingToken) {
          if (Get.isDialogOpen) {
            Get.back();
          }
          otpCode = "";
          this.verificationId = verificationId;
          this.forceResendingToken = forceResendingToken;
          print("otp sent");
          Get.to(OTP());
        },
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
        forceResendingToken: forceResendingToken);
  }

  void codeAutoRetrievalTimeout(String id) {}

  void verificationCompleted(PhoneAuthCredential credential) async {
    loadDialog(title: "Verifying", dismiss: false);

    await Future.delayed(Duration(seconds: 3));

    await auth.signInWithCredential(credential);

    User user = auth.currentUser;

    if (user != null) {
      readUserData(user);
    }
  }

  void verificationFailed(FirebaseAuthException e) {
    if (Get.isDialogOpen) {
      Get.back();
    }

    print("Exception thrown $e");
    Get.rawSnackbar(
        messageText: Text(
      "Unable to verify phone number",
      style: TextStyle(color: Colors.white),
    ));
  }

  void verifyOtp() async {
    if (otpCode.length < 6) {
      _showSnackBar(message: "Please enter complete OTP code");
      return;
    }

    loadDialog(title: "Verifying", dismiss: false);

    await Future.delayed(Duration(seconds: 3));

    PhoneAuthCredential credential;

    try {
      credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otpCode);
      await auth.signInWithCredential(credential);
    } catch (e) {
      if (Get.isDialogOpen) {
        Get.back();
      }

      print(e);
      _showSnackBar(message: "Unable to verify your number");
      return;
    }

    User user = auth.currentUser;

    if (user != null) {
      readUserData(user);
    } else {
      if (Get.isDialogOpen) {
        Get.back();
      }

      _showSnackBar(message: "Unable to verify your number");
    }
  }

  void _showSnackBar({String message}) {
    Get.rawSnackbar(
        messageText: Text(
      message,
      style: TextStyle(color: Colors.white),
    ));
  }

  // Future<bool> checkStatus() async {
  //   //check activist status
  //   User user = auth.currentUser;
  //   IdTokenResult _result = await auth.currentUser.getIdTokenResult();
  //   return _result.claims['isActivist'];
  // }

  readUserData(User user) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    IdTokenResult _result = await auth.currentUser.getIdTokenResult(true);
    // print('isActivist Status is ' + _result?.claims['isActivist'].toString());
    if (_result.claims['isActivist'] == null) {
      print('user status is null');
      _result = await auth.currentUser.getIdTokenResult(true);
    }
    _storageUtil.isActivist = _result.claims['isActivist'];

    DocumentReference reference = firestore
        .collection("users")
        .doc(_storageUtil.isActivist ? "social_activist" : "regular_users")
        .collection("users")
        .doc(user.uid);

    DocumentSnapshot documentSnapshot = await reference.get();

    if (Get.isDialogOpen) {
      Get.back();
    }

    if (documentSnapshot == null) {
      Get.to(Home());
    } else if (documentSnapshot.data() != null) {
      Get.to(Home());
    } else {
      Get.to(SignUp());
    }
  }
}
