import 'package:shared_preferences/shared_preferences.dart';
import 'database.dart';

class UserSession {
  static int? currentUserId;
  static Map<String, dynamic>? currentUser;

  /// Carrega ID + dados do usuário
  static Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getInt("user_id");


    if (currentUserId != null) {
    currentUser = await DatabaseHelper.instance.getUserById(currentUserId!);
    }


  }

  /// Salva ID e carrega dados completos
  static Future<void> saveUser(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("user_id", id);


    currentUserId = id;
    currentUser = await DatabaseHelper.instance.getUserById(id);


  }

  /// Logout total
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("user_id");


    currentUserId = null;
    currentUser = null;


  }
}
