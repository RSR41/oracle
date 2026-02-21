import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_flutter/app/models/fortune_result.dart';
import 'package:oracle_flutter/app/services/fortune_daily_service.dart';
import 'package:oracle_flutter/app/database/history_repository.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class FortuneTodayScreen extends StatefulWidget {
  const FortuneTodayScreen({super.key});

  @override
  State<FortuneTodayScreen> createState() => _FortuneTodayScreenState();
}

class _FortuneTodayScreenState extends State<FortuneTodayScreen> {
  final HistoryRepository _historyRepository = HistoryRepository();
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
        createdAt: now.toIso8601String(),
      );

      await _historyRepository.save(result);

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



  Future<void> _handleShare() async {
    final data = _fortuneData;
    if (data == null) return;

    final dateText = DateFormat('yyyy년 M월 d일 (E)', 'ko_KR').format(DateTime.now());
    final shareText = [
      '[$dateText 오늘의 운세]',
      '종합점수: ${data.overall}/100',
      '한줄 메시지: ${data.message}',
      '',
      '행운 아이템',
      '- 색상: ${data.luckyColor}',
      '- 숫자: ${data.luckyNumber}',
      '- 시간: ${data.luckyTime}',
    ].join('\n');

    try {
      await Share.share(shareText, subject: '오늘의 운세');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.read<AppState>().t('fortune.saveError'))),
      );
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
                      onPressed: _handleShare,
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
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
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
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
