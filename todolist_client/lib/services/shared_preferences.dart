import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future<String> get token async => await SharedPreferences.getInstance()
      .then((pref) => pref.getString("token"));
  static set token(String newValue) => SharedPreferences.getInstance()
      .then((pref) => pref.setString("token", newValue));

  static Future<String> get username async =>
      await SharedPreferences.getInstance()
          .then((pref) => pref.getString("username"));
  static set username(String newValue) => SharedPreferences.getInstance()
      .then((pref) => pref.setString("username", newValue));
}
