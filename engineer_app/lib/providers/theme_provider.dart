import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _storageKey = 'is_dark_mode';

  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  Future<void> load() async {
    final preferences = await SharedPreferences.getInstance();
    _isDarkMode = preferences.getBool(_storageKey) ?? false;
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    notifyListeners();

    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(_storageKey, value);
  }
}
