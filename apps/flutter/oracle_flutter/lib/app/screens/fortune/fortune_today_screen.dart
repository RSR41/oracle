import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_flutter/app/models/fortune_result.dart';
import 'package:oracle_flutter/app/services/fortune_daily_service.dart';
import 'package:oracle_flutter/app/services/fortune_service.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:oracle_flutter/app/database/history_repository.dart';
import 'package:oracle_flutter/app/models/fortune_result.dart';
import 'package:oracle_flutter/app/services/fortune_content_service.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'package:oracle_flutter/app/models/fortune_result.dart';
import 'package:oracle_flutter/app/services/fortune_service.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class FortuneTodayScreen extends StatefulWidget {
  const FortuneTodayScreen({super.key});

  @override
  State<FortuneTodayScreen> createState() => _FortuneTodayScreenState();
}

class _FortuneTodayScreenState extends State<FortuneTodayScreen> {
  final FortuneService _fortuneService = FortuneService();
  final FortuneDailyService _dailyService = FortuneDailyService();
  bool _isSaving = false;
  DailyFortuneData? _fortuneData;

  @override
  void initState() {
    super.initState();
    _loadDailyFortune();
  }

  Future<void> _loadDailyFortune() async {
    final data = await _dailyService.getFortune(DateTime.now());
    if (!mounted) return;
    setState(() => _fortuneData = data);
  }

  Future<void> _handleSave() async {
    if (_fortuneData == null) return;
  final HistoryRepository _historyRepo = HistoryRepository();
  final FortuneContentService _fortuneContentService = FortuneContentService();
  bool _isSaving = false;
  bool _isLoading = true;
  FortunePattern? _fortunePattern;

  @override
  void initState() {
    super.initState();
    _loadFortunePattern();
  }

  Future<void> _loadFortunePattern() async {
    try {
      final pattern = await _fortuneContentService.pickTodayPattern();
      if (!mounted) return;
      setState(() {
        _fortunePattern = pattern;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
  late _DailyFortuneData _fortuneData;

  @override
  void initState() {
    super.initState();
    _loadDailyFortune();
  }

  Future<void> _loadDailyFortune() async {
    final today = DateTime.now();
    final seed = (today.year * 10000) + (today.month * 100) + today.day;
    final random = Random(seed);

    try {
      final patterns = await _fortuneService.loadSajuPatterns();
      final selected = patterns.isEmpty
          ? null
          : patterns[random.nextInt(patterns.length)];

      final scoreBase = 60 + random.nextInt(31);
      _fortuneData = _DailyFortuneData(
        dateLabel: _formatDate(today),
        overall: scoreBase,
        love: _scoreFromBase(scoreBase, random, 10),
        money: _scoreFromBase(scoreBase, random, 12),
        health: _scoreFromBase(scoreBase, random, 8),
        work: _scoreFromBase(scoreBase, random, 10),
        message:
            (selected?['messageKo'] as String?) ??
            '작은 변화를 두려워하지 않으면 좋은 흐름을 만들 수 있는 날입니다.',
        loveMessage:
            (selected?['loveKo'] as String?) ?? '가까운 사람에게 진심을 표현해보세요.',
        moneyMessage:
            (selected?['moneyKo'] as String?) ?? '지출 점검이 재정 안정에 도움이 됩니다.',
        healthMessage:
            (selected?['healthKo'] as String?) ?? '규칙적인 수면이 컨디션을 지켜줍니다.',
        workMessage:
            (selected?['workKo'] as String?) ?? '우선순위를 세우면 효율이 올라갑니다.',
        luckyColor:
            (selected?['luckyColor'] as String?) ?? _luckyColors[random.nextInt(5)],
        luckyNumber: 1 + random.nextInt(9),
        luckyTime: _luckyTimes[random.nextInt(_luckyTimes.length)],
      );
    } catch (_) {
      _fortuneData = _DailyFortuneData.fallback(today);
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleSave() async {
    final pattern = _fortunePattern;
    if (pattern == null) return;
  int _scoreFromBase(int base, Random random, int range) {
    final delta = random.nextInt((range * 2) + 1) - range;
    return (base + delta).clamp(45, 99);
  }

  String _formatDate(DateTime date) {
    const weekdays = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    return '${DateFormat('yyyy년 M월 d일').format(date)} (${weekdays[date.weekday - 1]})';
  }

  Future<void> _handleSave() async {
    if (_isLoading) return;

    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();
      final dateStr = DateFormat('yyyy-MM-dd').format(now);
      final data = _fortuneData!;

      final result = FortuneResult(
        id: const Uuid().v4(),
        type: 'fortune',
        title: '오늘의 운세',
        date: dateStr,
        summary: data.overall.toString(),
        content: data.message,
        overallScore: data.overall,
        summary: pattern.overall.toString(),
        content: pattern.message,
        overallScore: pattern.overall,
        summary: _fortuneData.overall.toString(),
        content: _fortuneData.message,
        overallScore: _fortuneData.overall,
        createdAt: now.toIso8601String(),
      );

      await _historyRepo.saveWithPayload(
        result: result,
        payload: {
          'patternId': pattern.id,
          'overall': pattern.overall,
          'love': pattern.love,
          'money': pattern.money,
          'health': pattern.health,
          'work': pattern.work,
          'message': pattern.message,
          'luckyColor': pattern.luckyColor,
          'luckyNumber': pattern.luckyNumber,
          'luckyTime': pattern.luckyTime,
          'details': pattern.details,
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.read<AppState>().t('fortune.saveSuccess'))),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.read<AppState>().t('fortune.saveError'))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();
    final data = _fortuneData;

    if (data == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final pattern = _fortunePattern;
    if (pattern == null) {
      return Scaffold(
        appBar: AppBar(title: Text(appState.t('fortune.today'))),
        body: Center(
          child: Text(
            '운세 데이터를 불러오지 못했습니다.',
            style: theme.textTheme.bodyMedium,
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appState.t('fortune.today'),
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('yyyy년 M월 d일 (E요일)', 'ko').format(DateTime.now()),
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(DateFormat('yyyy년 M월 d일 (E)', 'ko_KR').format(DateTime.now()), style: theme.textTheme.bodySmall),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B6F47), Color(0xFFC4A574)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          appState.t('fortune.overall'),
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${data.overall}', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white, height: 1.0)),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text('/ 100', style: TextStyle(color: Colors.white.withValues(alpha: 0.9))),
                        Text(
                          '${pattern.overall}',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1,
                          ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60, left: 20, right: 20, bottom: 20),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => context.pop(),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appState.t('fortune.today'),
                              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(_fortuneData.dateLabel, style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF8B6F47), Color(0xFFC4A574)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(appState.t('screen.fortune.oneLiner'), style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12)),
                          const SizedBox(height: 8),
                          Text(data.message, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildDetailSection(appState.t('home.love'), data.love, AppColors.peach, Icons.favorite, data.loveText),
            _buildDetailSection(appState.t('home.wealth'), data.money, AppColors.caramel, Icons.attach_money, data.moneyText),
            _buildDetailSection(appState.t('home.health'), data.health, AppColors.sage, Icons.health_and_safety, data.healthText),
            _buildDetailSection('직장/학업운', data.work, AppColors.skyPastel, Icons.trending_up, data.workText),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                appState.t('fortune.overall'),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            pattern.message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildDetailSection(
              appState.t('home.love'),
              pattern.love,
              AppColors.peach,
              Icons.favorite,
              pattern.details['love'] ?? '',
            ),
            _buildDetailSection(
              appState.t('home.wealth'),
              pattern.money,
              AppColors.caramel,
              Icons.attach_money,
              pattern.details['money'] ?? '',
            ),
            _buildDetailSection(
              appState.t('home.health'),
              pattern.health,
              AppColors.sage,
              Icons.health_and_safety,
              pattern.details['health'] ?? '',
            ),
            _buildDetailSection(
              '직장/학업운',
              pattern.work,
              AppColors.skyPastel,
              Icons.trending_up,
              pattern.details['work'] ?? '',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appState.t('fortune.luckyItems'), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildLuckyItem(context, '🎨', appState.t('fortune.luckyColor'), data.luckyColor),
                      const SizedBox(width: 10),
                      _buildLuckyItem(context, '🔢', appState.t('fortune.luckyNumber'), data.luckyNumber.toString()),
                      const SizedBox(width: 10),
                      _buildLuckyItem(context, '⏰', appState.t('fortune.luckyTime'), data.luckyTime),
                      _buildLuckyItem(
                        context,
                        '🎨',
                        appState.t('fortune.luckyColor'),
                        pattern.luckyColor,
                      ),
                      const SizedBox(width: 10),
                      _buildLuckyItem(
                        context,
                        '🔢',
                        appState.t('fortune.luckyNumber'),
                        pattern.luckyNumber.toString(),
                      ),
                      const SizedBox(width: 10),
                      _buildLuckyItem(
                        context,
                        '⏰',
                        appState.t('fortune.luckyTime'),
                        pattern.luckyTime,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isSaving ? null : _handleSave,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isSaving
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : Text(appState.t('common.save')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {},
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: AppColors.primary,
                      ),
                      child: Text(appState.t('common.share')),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${_fortuneData.overall}',
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text('/ 100', style: TextStyle(color: Colors.white.withValues(alpha: 0.9))),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appState.t('screen.fortune.oneLiner'),
                                  style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 12),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  _fortuneData.message,
                                  style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildDetailSection(appState.t('home.love'), _fortuneData.love, AppColors.peach, Icons.favorite, _fortuneData.loveMessage),
                  _buildDetailSection(appState.t('home.wealth'), _fortuneData.money, AppColors.caramel, Icons.attach_money, _fortuneData.moneyMessage),
                  _buildDetailSection(appState.t('home.health'), _fortuneData.health, AppColors.sage, Icons.health_and_safety, _fortuneData.healthMessage),
                  _buildDetailSection('직장/학업운', _fortuneData.work, AppColors.skyPastel, Icons.trending_up, _fortuneData.workMessage),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appState.t('fortune.luckyItems'),
                          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildLuckyItem(context, '🎨', appState.t('fortune.luckyColor'), _fortuneData.luckyColor),
                            const SizedBox(width: 10),
                            _buildLuckyItem(context, '🔢', appState.t('fortune.luckyNumber'), _fortuneData.luckyNumber.toString()),
                            const SizedBox(width: 10),
                            _buildLuckyItem(context, '⏰', appState.t('fortune.luckyTime'), _fortuneData.luckyTime),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isSaving ? null : _handleSave,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _isSaving
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : Text(appState.t('common.save')),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: () {},
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              backgroundColor: AppColors.primary,
                            ),
                            child: Text(appState.t('common.share')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildDetailSection(String title, int score, Color color, IconData icon, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text('$score점', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                      Text(
                        '$score점',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(content, style: const TextStyle(fontSize: 13)),
            Text(content, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildLuckyItem(BuildContext context, String emoji, String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color)),
            Text(label, style: const TextStyle(fontSize: 10)),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: Theme.of(context).textTheme.bodySmall?.color),
            ),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _DailyFortuneData {
  final String dateLabel;
  final int overall;
  final int love;
  final int money;
  final int health;
  final int work;
  final String message;
  final String loveMessage;
  final String moneyMessage;
  final String healthMessage;
  final String workMessage;
  final String luckyColor;
  final int luckyNumber;
  final String luckyTime;

  const _DailyFortuneData({
    required this.dateLabel,
    required this.overall,
    required this.love,
    required this.money,
    required this.health,
    required this.work,
    required this.message,
    required this.loveMessage,
    required this.moneyMessage,
    required this.healthMessage,
    required this.workMessage,
    required this.luckyColor,
    required this.luckyNumber,
    required this.luckyTime,
  });

  factory _DailyFortuneData.fallback(DateTime now) => _DailyFortuneData(
    dateLabel: '${DateFormat('yyyy년 M월 d일').format(now)} (${['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'][now.weekday - 1]})',
    overall: 72,
    love: 70,
    money: 69,
    health: 74,
    work: 73,
    message: '오늘은 무리하지 않고 균형을 맞추면 좋은 흐름이 이어집니다.',
    loveMessage: '관계에서 작은 배려가 큰 신뢰로 이어질 수 있습니다.',
    moneyMessage: '필요한 곳에만 집중 소비하면 만족도가 높아집니다.',
    healthMessage: '가벼운 스트레칭으로 몸의 긴장을 풀어주세요.',
    workMessage: '중요한 일부터 차근차근 처리하면 성과가 납니다.',
    luckyColor: '골드',
    luckyNumber: 7,
    luckyTime: '오후 2-4시',
  );
}

const _luckyColors = ['골드', '네이비', '에메랄드', '라벤더', '화이트'];
const _luckyTimes = ['오전 7-9시', '오전 10-12시', '오후 1-3시', '오후 4-6시', '저녁 8-10시'];
