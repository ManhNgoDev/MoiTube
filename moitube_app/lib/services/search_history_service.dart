import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SearchHistoryService {
  static const _storage = FlutterSecureStorage();
  static const _key = 'recent_searches_v1';
  static const _maxItems = 10;

  Future<List<String>> getRecentSearches() async {
    final raw = await _storage.read(key: _key);
    if (raw == null || raw.trim().isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.map((e) => e.toString()).where((s) => s.trim().isNotEmpty).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<void> addRecentSearch(String term) async {
    final t = term.trim();
    if (t.isEmpty) return;
    final list = await getRecentSearches();
    list.removeWhere((x) => x.toLowerCase() == t.toLowerCase());
    list.insert(0, t);
    if (list.length > _maxItems) list.removeRange(_maxItems, list.length);
    await _storage.write(key: _key, value: jsonEncode(list));
  }

  Future<void> clear() async {
    await _storage.delete(key: _key);
  }
}

