import 'package:shared_preferences/shared_preferences.dart';

// Stores persistent data using SharedPreferences
class Prefs {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static String? getString(String key) {
    return _prefs.getString(key);
  }

  static int? getInt(String key) {
    return _prefs.getInt(key);
  }

  static bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  static List<String>? getStringList(String key) {
    return _prefs.getStringList(key);
  }

  static Future<void> addToStringList(String key, String value) async {
    List<String>? list = _prefs.getStringList(key);
    list ??= [];
    list.add(value);
    await _prefs.setStringList(key, list);
  }

  static Future<void> removeFromStringList(String key, String value) async {
    List<String>? list = _prefs.getStringList(key);
    list ??= [];
    list.remove(value);
    await _prefs.setStringList(key, list);
  }

  static Future<void> setString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static Future<void> setInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }

  static Future<void> setBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }

  static Future<void> setStringList(String key, List<String> value) async {
    await _prefs.setStringList(key, value);
  }

  static Future<void> removeAll() async {
    await _prefs.clear();
  }
}
