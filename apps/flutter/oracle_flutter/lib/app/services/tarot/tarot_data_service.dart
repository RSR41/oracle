import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:oracle_flutter/app/models/tarot_card.dart';

class TarotDataService {
  static List<TarotCard>? _cache;

  Future<List<TarotCard>> loadCards() async {
    if (_cache != null) return _cache!;

    final raw = await rootBundle.loadString('assets/data/tarot_cards.json');
    final decoded = jsonDecode(raw) as List<dynamic>;
    _cache = decoded
        .map((e) => TarotCard.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
    return _cache!;
  }
}
