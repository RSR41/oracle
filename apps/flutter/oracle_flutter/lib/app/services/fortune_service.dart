import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fortune_result.dart';

class FortuneService {
  static const String _storageKey = 'oracle_history';

  Future<void> save(FortuneResult result) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_storageKey) ?? [];

    // Add new item to the beginning
    history.insert(0, jsonEncode(result.toJson()));

    await prefs.setStringList(_storageKey, history);
  }

  Future<List<FortuneResult>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> history = prefs.getStringList(_storageKey) ?? [];

    return history
        .map((item) => FortuneResult.fromJson(jsonDecode(item)))
        .toList();
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
