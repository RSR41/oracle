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
    // Supports both legacy flat schema and current nested `result` schema.
    final Map<String, dynamic> source = json.containsKey('result')
        ? Map<String, dynamic>.from(json['result'] as Map)
        : json;

    final detailsRaw = source['details'];
    final details = detailsRaw is Map<String, dynamic>
        ? detailsRaw.map((key, value) => MapEntry(key, value as String))
        : <String, String>{
            'love': source['personality'] as String? ?? '',
            'money': source['wealth'] as String? ?? '',
            'health': source['health'] as String? ?? '',
            'work': source['career'] as String? ?? '',
          };

    return FortunePattern(
      id: '${json['id']}',
      overall:
          (source['overall'] as int?) ?? (source['overallScore'] as int? ?? 0),
      love: (source['love'] as int?) ?? (source['loveScore'] as int? ?? 0),
      money: (source['money'] as int?) ?? (source['moneyScore'] as int? ?? 0),
      health:
          (source['health'] as int?) ?? (source['healthScore'] as int? ?? 0),
      work: (source['work'] as int?) ?? (source['workScore'] as int? ?? 0),
      message: source['message'] as String? ?? '',
      luckyColor: source['luckyColor'] is List
          ? (source['luckyColor'] as List).first as String
          : (source['luckyColor'] as String? ?? ''),
      luckyNumber: source['luckyNumber'] is List
          ? (source['luckyNumber'] as List).first as int
          : (source['luckyNumber'] as int? ?? 0),
      luckyTime: source['luckyTime'] as String? ?? '',
      details: details,
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
