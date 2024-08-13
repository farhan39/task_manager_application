// shared_preferences_util.dart
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtil {
  static Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', userId);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  static Future<void> saveLoginStatus(bool loginStatus) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loginStatus', loginStatus);
  }

  static Future<bool?> getLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('loginStatus');
  }
}