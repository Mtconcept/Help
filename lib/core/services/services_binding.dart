import 'package:get/get.dart';
import 'backend/backend.dart';
import 'backend/firebase_backend.dart';

class ServicesBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Backend>(() => FirebaseBankend());
  }
}
