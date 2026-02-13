import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/tarot_card.dart';

class TarotContentService {
  static const String _assetPath = 'assets/data/tarot_cards.json';

  Future<List<TarotCard>> loadDeck() async {
    final jsonString = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(jsonString) as List<dynamic>;

    return decoded
        .map((item) => TarotCard.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
