import 'package:shared_preferences/shared_preferences.dart';

class MyFavorites {
  Future<void> saveInPreferences(String letter) async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    shared.setString("favorites", letter);
  }

  Future<void> clearAllPreferences() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    shared.remove("favorites");
  }

  Future<String> getFavorites() async {
    final SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getString("favorites") ?? '[]';
  }
}
