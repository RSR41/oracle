import 'dart:convert';

import 'package:flutter/services.dart';

/// Represents a Tarot card with its meaning
class TarotCard {
  final int id;
  final String name;
  final String nameKo;
  final String upright;
  final String uprightKo;
  final String reversed;
  final String reversedKo;
  final String description;
  final String descriptionKo;
  final bool isReversed;

  TarotCard({
    required this.id,
    required this.name,
    required this.nameKo,
    required this.upright,
    required this.uprightKo,
    required this.reversed,
    required this.reversedKo,
    required this.description,
    required this.descriptionKo,
    this.isReversed = false,
  });

  TarotCard copyWith({bool? isReversed}) {
    return TarotCard(
      id: id,
      name: name,
      nameKo: nameKo,
      upright: upright,
      uprightKo: uprightKo,
      reversed: reversed,
      reversedKo: reversedKo,
      description: description,
      descriptionKo: descriptionKo,
      isReversed: isReversed ?? this.isReversed,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'nameKo': nameKo,
    'upright': upright,
    'uprightKo': uprightKo,
    'reversed': reversed,
    'reversedKo': reversedKo,
    'description': description,
    'descriptionKo': descriptionKo,
    'isReversed': isReversed,
  };

  factory TarotCard.fromJson(Map<String, dynamic> json) {
    int parseId(dynamic rawId, dynamic number) {
      if (number is int) return number;
      if (rawId is int) return rawId;
      if (rawId is String) {
        final parsed = int.tryParse(rawId.split('_').last);
        if (parsed != null) return parsed;
      }
      return 0;
    }

    return TarotCard(
      id: parseId(json['id'], json['number']),
      name: (json['name'] ?? json['nameEn'] ?? '') as String,
      nameKo: (json['nameKo'] ?? '') as String,
      upright: (json['upright'] ?? json['uprightMeaningEn'] ?? '') as String,
      uprightKo:
          (json['uprightKo'] ?? json['uprightMeaningKo'] ?? '') as String,
      reversed:
          (json['reversed'] ?? json['reversedMeaningEn'] ?? '') as String,
      reversedKo:
          (json['reversedKo'] ?? json['reversedMeaningKo'] ?? '') as String,
      description:
          (json['description'] ?? json['uprightMeaningEn'] ?? '') as String,
      descriptionKo:
          (json['descriptionKo'] ?? json['uprightMeaningKo'] ?? '') as String,
      isReversed: json['isReversed'] as bool? ?? false,
    );
  }
}

class TarotDeckLoader {
  static const String _assetPath = 'assets/data/tarot_cards.json';

  static Future<List<TarotCard>> loadDeck() async {
    try {
      final raw = await rootBundle.loadString(_assetPath);
      final decoded = jsonDecode(raw);

      final cardsJson = switch (decoded) {
        List<dynamic> l => l,
        Map<String, dynamic> m => (m['cards'] as List<dynamic>? ?? <dynamic>[]),
        _ => <dynamic>[],
      };

      final cards = cardsJson
          .whereType<Map<String, dynamic>>()
          .map(TarotCard.fromJson)
          .toList();

      if (cards.isEmpty) {
        return List.from(TarotDeck.majorArcana);
      }

      cards.sort((a, b) => a.id.compareTo(b.id));
      return cards;
    } catch (_) {
      return List.from(TarotDeck.majorArcana);
    }
  }
}
