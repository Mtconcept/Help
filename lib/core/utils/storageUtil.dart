import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  SharedPreferences _sharedPrefs;

  Future<void> init() async {
    if (_sharedPrefs == null)
      _sharedPrefs = await SharedPreferences.getInstance();
  }

  set isActivist(bool value) =>
      value != null ? _sharedPrefs.setBool('isActivist', value) : null;
  bool get isActivist => _sharedPrefs.getBool('isActivist');
}
