import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LocalStorage {
  static read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(key);

    if(value == null) {
      return null;
    }

    return json.decode(value);
  }

  static save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }
}