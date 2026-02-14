import 'dart:convert';

import 'package:flutter/services.dart';

class DailyFortuneData {
  const DailyFortuneData({
    required this.overall,
    required this.love,
    required this.money,
    required this.health,
    required this.work,
    required this.message,
    required this.luckyColor,
    required this.luckyNumber,
    required this.luckyTime,
    required this.loveText,
    required this.moneyText,
    required this.healthText,
    required this.workText,
  });

  final int overall;
  final int love;
  final int money;
  final int health;
  final int work;
  final String message;
  final String luckyColor;
  final int luckyNumber;
  final String luckyTime;
  final String loveText;
  final String moneyText;
  final String healthText;
  final String workText;
}

class FortuneDailyService {
  static List<Map<String, dynamic>>? _cache;

  Future<DailyFortuneData> getFortune(DateTime date) async {
    final patterns = await _loadPatterns();
    final daySeed = date.year * 10000 + date.month * 100 + date.day;
    final pattern = patterns[daySeed % patterns.length];
    final result = Map<String, dynamic>.from(pattern['result'] as Map);

    return DailyFortuneData(
      overall: _clamp(result['overallScore'] as int),
      love: _clamp(result['loveScore'] as int),
      money: _clamp(result['moneyScore'] as int),
      health: _clamp(result['healthScore'] as int),
      work: _clamp(result['workScore'] as int),
      message: result['message'] as String,
      luckyColor: (result['luckyColor'] as List).first as String,
      luckyNumber: (result['luckyNumber'] as List).first as int,
      luckyTime: result['luckyTime'] as String,
      loveText: '애정운: ${result['personality']}',
      moneyText: '재물운: ${result['wealth']}',
      healthText: '건강운: ${result['health']}',
      workText: '직장/학업운: ${result['career']}',
    );
  }

  Future<List<Map<String, dynamic>>> _loadPatterns() async {
    if (_cache != null) return _cache!;

    final raw = await rootBundle.loadString('assets/data/saju_patterns.json');
    final decoded = jsonDecode(raw) as List<dynamic>;
    _cache = decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    return _cache!;
  }

  int _clamp(int score) => score.clamp(0, 100);
}
