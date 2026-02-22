import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:oracle_flutter/app/services/face/face_analyzer.dart';
import 'package:oracle_flutter/app/models/fortune_result.dart';
import 'package:oracle_flutter/app/database/history_repository.dart';
import 'package:oracle_flutter/app/history/history_payload.dart';
import 'package:oracle_flutter/app/i18n/translations.dart';
import 'package:oracle_flutter/app/services/saju/saju_service.dart';

class FaceResultScreen extends StatefulWidget {
  final String imagePath;
  final FaceReadingResult result;

  const FaceResultScreen({
    super.key,
    required this.imagePath,
    required this.result,
  });

  @override
  State<FaceResultScreen> createState() => _FaceResultScreenState();
}

class _FaceResultScreenState extends State<FaceResultScreen> {
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
        type: 'faceReading',
        title: '관상 분석',
        date: dateStr,
        summary: widget.result.overviewKo,
        content: widget.result.adviceKo,
        overallScore: widget.result.compatibilityScore,
        createdAt: now.toIso8601String(),
      );

      // Copy image to persistent storage
      final appDir = await getApplicationDocumentsDirectory();
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${p.basename(widget.imagePath)}';
      final targetPath = '${appDir.path}/$fileName';
      final sourceFile = File(widget.imagePath);
      final savedImage = await sourceFile.copy(targetPath);

      await _historyRepo
          .saveWithPayload(
        result: fortuneResult,
        payload: HistoryPayload.wrap(
          feature: 'faceReading',
          summary: {
            'title': fortuneResult.title,
            'compatibilityScore': widget.result.compatibilityScore,
            'date': fortuneResult.date,
          },
          data: widget.result.toJson(),
          extra: {'sourceImagePath': savedImage.path},
        ),
        mediaPaths: [savedImage.path],
      )
          .timeout(const Duration(seconds: 8));

      if (mounted) {
        final appState = context.read<AppState>();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appState.t('fortune.saveSuccess'))),
        );
      }
    } catch (e) {
      try {
        await _historyRepo.logSaveError(
          feature: 'faceReading',
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
    final isKorean = appState.language == AppLanguage.ko;
    final result = widget.result;
    final profile = appState.profile;

    String? sajuSummary;
    int sajuScore = 75;
    if (profile != null) {
      final birthDate = DateTime.tryParse(profile.birthDate);
      if (birthDate != null) {
        final saju = _sajuService.calculate(
          birthDate: birthDate,
          birthTime: profile.birthTime,
          gender: profile.gender,
        );
        sajuSummary =
            '일주 ${saju.dayPillar.ganji} · 오행 강점 ${saju.dominantElement} · '
            '보완 ${saju.weakestElement} · 종합 ${saju.overallScore}점';
        sajuScore = saju.overallScore;
      }
    }

    final todayGanji = _sajuService.getDayGanji(DateTime.now());
    final manseScore =
        ((SajuService.heavenlyStems.indexOf(todayGanji.stem) + 1) * 4 +
            (SajuService.earthlyBranches.indexOf(todayGanji.branch) + 1) * 3) %
            41 +
        60;
    final todayFaceScore =
        ((result.compatibilityScore + sajuScore + manseScore) / 3).round();

    return Scaffold(
      appBar: AppBar(
        title: Text(appState.t('face.result')),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              Share.shareXFiles([
                XFile(widget.imagePath),
              ], text: widget.result.overviewKo);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Score Card (Face + Saju + Manse)
            Container(
              width: double.infinity,
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
                  const Icon(Icons.face, color: Colors.white, size: 40),
                  const SizedBox(height: 12),
                  Text(
                    '$todayFaceScore',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '오늘의 관상 점수',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '관상 ${result.compatibilityScore} + 사주 $sajuScore + 만세력 $manseScore',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Combined Report (Saju + Face)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '관상 + 사주 결합 리포트',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sajuSummary ?? '프로필(사주) 정보가 없어 관상 중심으로 해석되었습니다.',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '관상 해석과 사주 흐름을 함께 참고해 오늘의 행동 우선순위를 정하세요.',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Overview
            Text(
              appState.t('face.overview'),
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
                isKorean ? result.overviewKo : result.overview,
                style: const TextStyle(fontSize: 15, height: 1.6),
              ),
            ),
            const SizedBox(height: 20),

            // Part Analysis (tap)
            Text(
              '부위별 분석 (터치)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (isKorean ? result.featuresKo : result.features)
                  .entries
                  .map((entry) {
                return ActionChip(
                  label: Text(entry.key),
                  avatar: const Icon(Icons.touch_app, size: 16),
                  onPressed: () => _showPartComment(
                    context,
                    entry.key,
                    entry.value,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Advice
            Text(
              appState.t('face.advice'),
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
                      isKorean ? result.adviceKo : result.advice,
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // LLM Long Review
            Text(
              '총평 (LLM)',
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
                isKorean ? result.overviewKo : result.overview,
                style: const TextStyle(fontSize: 14, height: 1.7),
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
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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

  void _showPartComment(BuildContext context, String part, String comment) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('$part 분석'),
        content: Text(comment, style: const TextStyle(height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('닫기'),
          ),
        ],
      ),
    );
  }
}
