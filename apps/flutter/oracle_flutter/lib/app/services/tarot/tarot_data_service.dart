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
      _cache = decoded
          .map((e) => TarotCard.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } catch (error, stackTrace) {
      debugPrint('TarotDataService.loadCards failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      _cache = _fallbackDeck();
    }

    return _cache!;
  }

  List<TarotCard> _fallbackDeck() {
    if (TarotDeck.majorArcana.isNotEmpty) {
      return List<TarotCard>.from(TarotDeck.majorArcana);
    }

    return [
      TarotCard(
        id: 0,
        name: 'The Fool',
        nameKo: '바보',
        upright: 'New beginnings, innocence, adventure',
        uprightKo: '새로운 시작, 순수함, 모험',
        reversed: 'Recklessness, risk-taking, foolishness',
        reversedKo: '무모함, 위험 감수, 어리석음',
        description: 'A fresh start awaits. Trust your instincts.',
        descriptionKo: '새로운 시작이 기다립니다. 본능을 믿으세요.',
      ),
    ];
  }
}
