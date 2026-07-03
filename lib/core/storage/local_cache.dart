import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Generic JSON-by-key local cache, used for the dashboard's offline snapshot
/// and the irrigation offline command queue. Not for secrets — see
/// TokenStorage for that.
class LocalCache {
  const LocalCache();

  Future<void> putJson(String key, Map<String, dynamic> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(value));
  }

  Future<Map<String, dynamic>?> getJson(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return null;
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> putJsonList(String key, List<Map<String, dynamic>> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, jsonEncode(value));
  }

  Future<List<Map<String, dynamic>>> getJsonList(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);
    if (raw == null) return const [];
    return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
  }

  Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
