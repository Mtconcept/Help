import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/locator.dart';
import 'core/services/services_binding.dart';
import 'ui/views/splash_screen/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(Help());
}

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: ServicesBinding(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Gilroy',
        bottomSheetTheme:
            BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
      ),
      home: SplashScreen(),//EmergencysCenters(),
    );
  }
}
