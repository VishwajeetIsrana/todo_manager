import 'package:flutter/material.dart';
import '../core/services/local_storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  final LocalStorageService _storage;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider(this._storage);

  Future<void> loadTheme() async {
    final isDark = await _storage.isDarkMode();
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    await _storage.setDarkMode(_themeMode == ThemeMode.dark);
    notifyListeners();
  }
}
