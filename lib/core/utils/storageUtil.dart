import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  SharedPreferences _sharedPrefs;

  Future<void> init() async {
    if (_sharedPrefs == null)
      _sharedPrefs = await SharedPreferences.getInstance();
  }

  set isActivist(bool value) => _sharedPrefs.setBool('isActivist', value);
  bool get isActivist => _sharedPrefs.getBool('isActivist') ?? false;
}
