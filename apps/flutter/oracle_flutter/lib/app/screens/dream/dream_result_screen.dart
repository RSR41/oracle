import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:oracle_flutter/app/services/dream/dream_interpreter.dart';
import 'package:oracle_flutter/app/models/fortune_result.dart';
import 'package:oracle_flutter/app/database/history_repository.dart';
import 'package:oracle_flutter/app/history/history_payload.dart';
import 'package:share_plus/share_plus.dart';
import 'package:oracle_flutter/app/services/saju/saju_service.dart';

class DreamResultScreen extends StatefulWidget {
  final String dreamContent;
  final DreamResult result;

  const DreamResultScreen({
    super.key,
    required this.dreamContent,
    required this.result,
  });

  @override
  State<DreamResultScreen> createState() => _DreamResultScreenState();
}

class _DreamResultScreenState extends State<DreamResultScreen> {
  final _historyRepo = HistoryRepository();
  final _sajuService = SajuService();
  bool _isSaving = false;

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();
      final dateStr = DateFormat('yyyy-MM-dd').format(now);

      final fortuneResult = FortuneResult(
        id: const Uuid().v4(),
        type: 'dream',
        title: '꿈해몽',
        date: dateStr,
        summary: widget.result.summary,
        content: widget.result.details,
        overallScore: widget.result.luckScore,
        createdAt: now.toIso8601String(),
      );

      await _historyRepo.saveWithPayload(
        result: fortuneResult,
        payload: HistoryPayload.wrap(
          feature: 'dream',
          summary: {
            'title': fortuneResult.title,
            'luckScore': widget.result.luckScore,
            'date': fortuneResult.date,
          },
          data: {
            'dreamContent': widget.dreamContent,
            ...widget.result.toJson(),
          },
        ),
      ).timeout(const Duration(seconds: 8));

      if (mounted) {
        final appState = context.read<AppState>();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appState.t('fortune.saveSuccess'))),
        );
      }
    } catch (e) {
      try {
        await _historyRepo.logSaveError(
          feature: 'dream',
          action: 'save',
          message: e.toString(),
          debug: {'runtimeType': e.runtimeType.toString()},
        );
      } catch (_) {}
      if (mounted) {
        final appState = context.read<AppState>();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appState.t('fortune.saveError'))),
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
    final result = widget.result;
    final profile = appState.profile;

    String? sajuImpact;
    if (profile != null) {
      final birthDate = DateTime.tryParse(profile.birthDate);
      if (birthDate != null) {
        final saju = _sajuService.calculate(
          birthDate: birthDate,
          birthTime: profile.birthTime,
          gender: profile.gender,
        );
        sajuImpact =
            '오늘의 사주 흐름은 ${saju.dominantElement} 기운이 강하고 '
            '${saju.weakestElement} 기운 보완이 필요한 상태입니다. '
            '꿈 해석을 현실 행동으로 옮길 때 이 균형을 고려하세요.';
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appState.t('dream.result.title')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.share('${result.summary}\n\n${result.advice}');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Score Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B5B95), Color(0xFF9B8FC4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Icon(Icons.bedtime, color: Colors.white, size: 40),
                  const SizedBox(height: 12),
                  Text(
                    '${result.luckScore}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    appState.t('dream.result.luckScore'),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Summary
            Text(
              appState.t('dream.result.summary'),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.1),
                ),
              ),
              child: Text(
                result.summary,
                style: const TextStyle(fontSize: 15, height: 1.6),
              ),
            ),
            const SizedBox(height: 20),

            // Keywords
            Text(
              appState.t('dream.result.keywords'),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: result.keywords.map((keyword) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '#$keyword',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Saju Impact
            Text(
              '오늘 사주 영향 요약',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.caramel.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.caramel.withValues(alpha: 0.25),
                ),
              ),
              child: Text(
                sajuImpact ?? '프로필(사주) 정보가 없어 꿈 상징 중심으로 해석되었습니다.',
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ),
            const SizedBox(height: 20),

            // Details
            Text(
              appState.t('dream.result.details'),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.1),
                ),
              ),
              child: Text(
                result.details,
                style: const TextStyle(fontSize: 14, height: 1.6),
              ),
            ),
            const SizedBox(height: 20),

            // Advice
            Text(
              appState.t('dream.result.advice'),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.sage.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: AppColors.sage),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      result.advice,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSaving ? null : _handleSave,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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
                    onPressed: () => context.go('/home'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text(appState.t('common.confirm')),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
