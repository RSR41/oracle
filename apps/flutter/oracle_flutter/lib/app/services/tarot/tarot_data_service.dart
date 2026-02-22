import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:oracle_flutter/app/models/tarot_card.dart';

class TarotDataService {
  static List<TarotCard>? _cache;

  Future<List<TarotCard>> loadCards() async {
    if (_cache != null) return _cache!;

    try {
      final raw = await rootBundle.loadString('assets/data/tarot_cards.json');
      final decoded = jsonDecode(raw) as List<dynamic>;
      final cards = decoded
          .map((e) => TarotCard.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      _cache = cards.isEmpty ? List<TarotCard>.from(TarotDeck.majorArcana) : cards;
    } catch (e, st) {
      debugPrint('Failed to load tarot cards: $e');
      debugPrintStack(stackTrace: st);
      _cache = List<TarotCard>.from(TarotDeck.majorArcana);
    }

    return _cache!;
  }
}
