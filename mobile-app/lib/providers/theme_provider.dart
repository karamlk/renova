import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDark = false;
  ThemeMode get thememode => isDark ? ThemeMode.dark : ThemeMode.light;
  void toggleTheme() {
    isDark = !isDark;
    notifyListeners();
  }
}
