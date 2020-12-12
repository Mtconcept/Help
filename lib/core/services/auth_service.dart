import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthService {

  bool isLoggedIn();

  String currentUserId();

}


class AuthServiceFake extends AuthService{

  @override
  bool isLoggedIn() {
    return false;
  }

  @override
  String currentUserId() {
    // TODO: implement currentUserId
    throw UnimplementedError();
  }

}

class AuthServiceReal extends AuthService{

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  bool isLoggedIn() {
   return auth.currentUser != null;
  }

  @override
  String currentUserId() {

    if(auth.currentUser == null)return "";

    return auth.currentUser.uid;
  }

}