import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _loginKey = 'is_logged_in';
  static const String _themeKey = 'is_dark_mode';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loginKey) ?? false;
  }

  Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loginKey, value);
  }

  Future<void> clearLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginKey);
  }

  Future<bool> isDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, value);
  }
}
