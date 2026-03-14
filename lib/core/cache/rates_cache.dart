import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class RatesCache {
  static const String _parallelKey = 'rates_parallel_cache_v1';
  static const String _officialKey = 'rates_official_cache_v1';

  static Future<void> saveParallel(List<Map<String, dynamic>> rows) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_parallelKey, jsonEncode(rows));
  }

  static Future<void> saveOfficial(List<Map<String, dynamic>> rows) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_officialKey, jsonEncode(rows));
  }

  static Future<List<Map<String, dynamic>>?> loadParallel() async {
    return _load(_parallelKey);
  }

  static Future<List<Map<String, dynamic>>?> loadOfficial() async {
    return _load(_officialKey);
  }

  static Future<List<Map<String, dynamic>>?> _load(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(key);

    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) {
        return null;
      }

      return decoded
          .whereType<Map>()
          .map<Map<String, dynamic>>(
            (item) => item.map((key, value) => MapEntry(key.toString(), value)),
          )
          .toList();
    } catch (_) {
      return null;
    }
  }
}
