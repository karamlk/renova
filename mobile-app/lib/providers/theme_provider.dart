import 'package:flutter/material.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool isDark = false;
  ThemeProvider({required this.isDark});
  ThemeMode get thememode => isDark ? ThemeMode.dark : ThemeMode.light;

  Future<void> loadTheme() async {
    String? saved = await getPrefs('darkMode');

    if (saved != null) {
      isDark = saved == 'true';
      notifyListeners();
    }
    print("Loaded theme: $isDark");
  }

  void toggleTheme() async {
    isDark = !isDark;
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('darkMode', isDark);
    notifyListeners();
  }
}
