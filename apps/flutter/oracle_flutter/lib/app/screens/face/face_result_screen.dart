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
import 'package:oracle_flutter/app/i18n/translations.dart';

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
      final fileName = p.basename(widget.imagePath);
      final savedImage = await File(
        widget.imagePath,
      ).copy('${appDir.path}/$fileName');

      await _historyRepo.saveWithPayload(
        result: fortuneResult,
        payload: widget.result.toJson(),
        mediaPaths: [savedImage.path],
      );

      if (mounted) {
        final appState = context.read<AppState>();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appState.t('fortune.saveSuccess'))),
        );
      }
    } catch (e) {
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
            // Score Card
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
                    '${result.compatibilityScore}',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    appState.t('face.compatScore'),
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

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

            // Features
            Text(
              appState.t('face.features'),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...((isKorean ? result.featuresKo : result.features).entries.map((
              entry,
            ) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })),
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
}
