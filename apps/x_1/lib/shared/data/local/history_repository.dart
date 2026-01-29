import 'dart:convert';
import 'package:x_1/shared/domain/models/history.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final historyRepositoryProvider =
    Provider<HistoryRepository>((ref) => HistoryRepository());

class HistoryRepository {
  static const String _key = 'user_history';

  Future<List<History>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return [];
    try {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((e) => History.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveHistory(History item) async {
    final prefs = await SharedPreferences.getInstance();
    final currentList = await getHistory();
    // Add to top
    final newList = [item, ...currentList];
    final jsonString = jsonEncode(newList.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }

  Future<void> deleteHistory(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final currentList = await getHistory();
    final newList = currentList.where((h) => h.id != id).toList();
    final jsonString = jsonEncode(newList.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }
}
