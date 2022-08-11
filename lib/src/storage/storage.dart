import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final storageProvider = Provider((_) {
  return LocalStorage();
});

class LocalStorage {
  late final SharedPreferences _prefs;

  LocalStorage({SharedPreferences? prefs}) {
    if (prefs != null) {
      _prefs = prefs;
    }
  }

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> save(String key, Object value) async {
    _prefs.setString(key, json.encode(value));
  }

  Future<Object?> load(String key) async {
    final jsonString = _prefs.getString(key);
    if (jsonString == null) {
      return null;
    }

    return json.decode(jsonString);
  }

  Future<void> clear() async {
    _prefs.clear();
  }
}
