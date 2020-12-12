import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help/app/locator.dart';
import 'package:help/core/utils/storageUtil.dart';
import 'package:help/ui/shared_views/loading_dialog.dart';
import 'package:help/ui/views/otp.dart';
import 'package:help/ui/views/signup/signUp.dart';
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

  FocusNode phoneNumberFocus = FocusNode();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
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

  void getStarted() async {
    String phoneNumber = phoneNumController.text;

    if (phoneNumber.isEmpty || phoneNumber.length < 11) {
      _showSnackBar(message: "Please enter a valid phone number");
      return;
    }

    print(phoneNumber);

    loadDialog(title: "Please Hold on", dismiss: false);

    if (phoneNumber.startsWith("0")) {
      String formattedPhone = phoneNumber.substring(1, phoneNumber.length);
      phoneNumber = "+234$formattedPhone";
    } else {
      _showSnackBar(message: "Invalid phone number format");
      return;
    }
    phoneNumberFocus.unfocus();

    loadDialog(title: "Please Hold on", dismiss: false);

    // phoneNumber ="+2348036007161";

    auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: (verificationId, forceResendingToken) {
          Get.back();

          otpCode = "";
          this.verificationId = verificationId;
          this.forceResendingToken = forceResendingToken;
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

  readUserData(User user) async {
    IdTokenResult _result = await auth.currentUser.getIdTokenResult(true);
    bool isActivist = await _result.claims['isActivist'];

    print('\n\n\nisActivist Status is $isActivist \n\n\n');
    _storageUtil.isActivist = isActivist;

    DocumentReference reference = firestore
        .collection("users")
        .doc(_storageUtil.isActivist ? "social_activist" : "regular_users")
        .collection("users")
        .doc(user.uid);

    DocumentSnapshot documentSnapshot = await reference.get();

    if (Get.isDialogOpen) {
      Get.back();
    }

    if (isActivist == null) {
      _result = await auth.currentUser.getIdTokenResult(true);
      isActivist = await _result.claims['isActivist'];

      print('\n\n\nisActivist Status is $isActivist \n\n\n');
      _storageUtil.isActivist = isActivist;
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
