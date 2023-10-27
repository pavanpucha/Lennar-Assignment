import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/picsum_model.dart';

class AppPrefsRepository {
  static SharedPreferences? _preferences;

  final picsum_key = "picsum";

  init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  PicsumPayload? get images {
    var payloadFromDisk = getFromDisk(picsum_key);
    if (payloadFromDisk == null) {
      return null;
    }
    return PicsumPayload(picsumImageFromJson(payloadFromDisk));
  }

  dynamic getFromDisk(String key) {
    var value = _preferences?.get(key);
    return value;
  }

  void savePicsumPayload(String content) async {
    await _preferences?.setString(picsum_key, content);
  }

  void setLogin() async {
    print("setLogin");
    final currTime = DateTime.now();
    await _preferences?.setInt("cookie-time", currTime.millisecondsSinceEpoch);
    await _preferences?.setBool("login", true);
  }

  void clearCredentials() async {
    await _preferences?.setBool("login", false);
    await _preferences!.setInt("cookie-time", 0);
  }

  int? lastLoginTime() {
    // Non null because we always check if the user is logged in
    return _preferences!.getInt("cookie-time") ?? 0;
  }

  bool get isLoggedIn {
    return _preferences?.getBool("login") ?? false;
  }
}

final localRepository = AppPrefsRepository();
