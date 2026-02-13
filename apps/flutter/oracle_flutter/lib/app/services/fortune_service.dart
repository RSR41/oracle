import 'dart:convert';

import 'package:flutter/services.dart';

import '../database/history_repository.dart';
import '../models/fortune_result.dart';
import '../models/tarot_card.dart';

class FortuneService {
  final HistoryRepository _historyRepository;

  FortuneService({HistoryRepository? historyRepository})
    : _historyRepository = historyRepository ?? HistoryRepository();

  Future<void> save(FortuneResult result) async {
    await _historyRepository.save(result);
  }

  Future<List<FortuneResult>> getAll() async {
    return _historyRepository.getAll();
  }

  Future<void> clearAll() async {
    await _historyRepository.clearAll();
  }

  Future<List<Map<String, dynamic>>> loadSajuPatterns() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/saju_patterns.json',
    );
    final decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded
        .map((item) => Map<String, dynamic>.from(item as Map))
        .toList();
  }

  Future<List<TarotCard>> loadTarotCards() async {
    final jsonString = await rootBundle.loadString(
      'assets/data/tarot_cards.json',
    );
    final decoded = jsonDecode(jsonString) as List<dynamic>;
    return decoded
        .map((item) => TarotCard.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }
}
