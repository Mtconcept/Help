import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/claim.dart';
import 'backend.dart';

class FirebaseBankend implements Backend {
  Future<String> sendClaim(Claim claim) async {
    DocumentReference ref = await FirebaseFirestore.instance
        .collection('claims')
        .add(claim.toJson());

    return ref.id;
  }
}
