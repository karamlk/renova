import 'package:shared_preferences/shared_preferences.dart';

Future<void> storePrefs(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<String?> getPrefs(String value) async {
  final prefs = await SharedPreferences.getInstance();
  final prefValue = prefs.getString(value);
  return prefValue;
}

Future<void> clearTPrefs(String value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(value);
}
