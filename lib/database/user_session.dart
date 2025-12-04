import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static int? currentUserId;

  static Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getInt("user_id");
  }

  static Future<void> saveUser(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("user_id", id);
    currentUserId = id;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("user_id");
    currentUserId = null;
  }
}
