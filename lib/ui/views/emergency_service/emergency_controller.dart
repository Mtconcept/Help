import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';
import 'package:help/ui/views/emergency_service/emergency_model.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyController extends GetxController {
  // @override
  // void onInit() {
  //   _loadFromAssets();
  //   super.onInit();
  // }

  get assetsJson => _loadFromAssets();
  get parseJson => _parseJson();

  Future<String> _loadFromAssets() async {
    return await rootBundle.loadString(
        'assets/json/health-care-facilities-primary-secondary-and-tertiary.geojson');
  }

  HealthCenters healthCenters;
  var currentAddress;
  var healthCenterList;

  Future<HealthCenters> _parseJson() async {
    try {
      String jsonString = await _loadFromAssets();
      final jsonResponse = jsonDecode(jsonString);
      print(jsonResponse);
      return healthCenters = HealthCenters.fromJson(jsonResponse);
    } catch (e) {
      print(e);
    }
    return healthCenters;
  }

   Future<List<HealthCenters>> getHealthCenters() async {
    print('i tried accessing1');
    try {
      http.Response response =
          await http.get('https://help-me-cfc1d.firebaseio.com/features.json');
      print(response.body);
      healthCenterList = healthCentersFromJson(response.body);
      return healthCenterList;
       
    } on Exception catch (e) {
      Get.snackbar('Oops Somethings Wrong',
          'we have noticed an issue kindly check your internet comnection');
      print(e);
    }
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw Exception('Can\'t open Map');
    }
  }
}
