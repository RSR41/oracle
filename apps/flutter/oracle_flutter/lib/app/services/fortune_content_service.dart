import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class FortunePattern {
  final String id;
  final int overall;
  final int love;
  final int money;
  final int health;
  final int work;
  final String message;
  final String luckyColor;
  final int luckyNumber;
  final String luckyTime;
  final Map<String, String> details;

  const FortunePattern({
    required this.id,
    required this.overall,
    required this.love,
    required this.money,
    required this.health,
    required this.work,
    required this.message,
    required this.luckyColor,
    required this.luckyNumber,
    required this.luckyTime,
    required this.details,
  });

  factory FortunePattern.fromJson(Map<String, dynamic> json) {
    return FortunePattern(
      id: json['id'] as String,
      overall: json['overall'] as int,
      love: json['love'] as int,
      money: json['money'] as int,
      health: json['health'] as int,
      work: json['work'] as int,
      message: json['message'] as String,
      luckyColor: json['luckyColor'] as String,
      luckyNumber: json['luckyNumber'] as int,
      luckyTime: json['luckyTime'] as String,
      details: (json['details'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value as String),
      ),
    );
  }
}

class FortuneContentService {
  static const String _assetPath = 'assets/data/saju_patterns.json';

  Future<List<FortunePattern>> loadPatterns() async {
    final jsonString = await rootBundle.loadString(_assetPath);
    final decoded = jsonDecode(jsonString) as List<dynamic>;

    return decoded
        .map((item) => FortunePattern.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<FortunePattern> pickTodayPattern() async {
    final patterns = await loadPatterns();
    if (patterns.isEmpty) {
      throw StateError('No fortune patterns available in $_assetPath');
    }

    final today = DateTime.now();
    final daySeed =
        DateTime(today.year, today.month, today.day)
            .difference(DateTime(today.year, 1, 1))
            .inDays;

    return patterns[daySeed % patterns.length];
  }
}
