import 'package:shared_preferences/shared_preferences.dart';

class UserDataManager {

  // Save UID and Email
  Future<void> saveUserData(String uid, String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', uid);
    await prefs.setString('email', email);
  }

  // Retrieve UID and Email
  Future<Map<String, String?>> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');
    String? email = prefs.getString('email');
    return {'uid': uid, 'email': email};
  }

  // Retrieve UID
   Future<String> getUid() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('uid') ?? '';
  }

  // Remove UID and Email (for logout)
  Future<void> clearUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    await prefs.remove('email');
  }
}