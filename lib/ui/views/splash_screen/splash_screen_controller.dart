import 'package:get/get.dart';
import 'package:help/app/locator.dart';
import 'package:help/core/services/auth_service.dart';
import 'package:help/ui/constants/string_values.dart';
import 'package:help/ui/views/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:help/core/utils/storageUtil.dart';

import '../home.dart';
import '../onboarding.dart';

class SplashScreenController extends GetxController {
  AuthService _authService = locator<AuthService>();

  @override
  void onInit() {
    super.onInit();
    locator<StorageUtil>().init();
    decideNavigation();
  }

  void decideNavigation() async {
    print("decide navigation entered");

    SharedPreferences preferences = await SharedPreferences.getInstance();

    await Future.delayed(Duration(seconds: 3));

    bool _isFirstTime =
        preferences.getBool(ConstantString.is_first_time_user) ?? true;
    print('user is $_isFirstTime');

    if (_isFirstTime) {
      await preferences.setBool(ConstantString.is_first_time_user, false);
      Get.off(Onboarding());
    } else {
      if (_authService.isLoggedIn()) {
        Get.off(Home());
      } else {
        Get.off(LogIn());
      }
    }
  }
}
