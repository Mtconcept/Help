import 'package:cloud_firestore/cloud_firestore.dart';

class Contacts {
  final String uid;
  final int seconds, nanoseconds;

  final DocumentSnapshot details;

  Contacts({this.uid, this.seconds, this.nanoseconds, this.details});

  DateTime get time {
    if (this.seconds != null && this.nanoseconds != null) {
      return Timestamp(this.seconds, this.nanoseconds).toDate();
    }
    return null;
  }

  String toDateString() {
    return time?.toString()?.substring(0, 16) ?? '';
  }
//  2020-10-18 14:54:25.195563
}
