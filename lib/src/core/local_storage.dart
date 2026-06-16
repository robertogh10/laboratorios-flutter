import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  LocalStorage({SharedPreferences? sharedPreferences})
    : prefs =
          sharedPreferences ??
          _prefs ??
          (throw StateError('LocalStorage has not been initialized.'));

  final SharedPreferences prefs;

  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static void setPrefs(SharedPreferences prefs) {
    _prefs = prefs;
  }
}
