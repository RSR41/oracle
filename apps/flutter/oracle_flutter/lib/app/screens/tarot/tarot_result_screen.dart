import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:oracle_flutter/app/models/tarot_card.dart';
import 'package:oracle_flutter/app/models/fortune_result.dart';
import 'package:oracle_flutter/app/database/history_repository.dart';
import 'package:oracle_flutter/app/i18n/translations.dart';

class TarotResultScreen extends StatefulWidget {
  final List<TarotCard> cards;

  const TarotResultScreen({super.key, required this.cards});

  @override
  State<TarotResultScreen> createState() => _TarotResultScreenState();
}

class _TarotResultScreenState extends State<TarotResultScreen> {
  final _historyRepo = HistoryRepository();
  bool _isSaving = false;

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();
      final dateStr = DateFormat('yyyy-MM-dd').format(now);

      final cardNames = widget.cards.map((c) => c.nameKo).join(', ');
      final score =
          widget.cards.fold<int>(0, (sum, card) {
            return sum + (card.isReversed ? 50 : 80);
          }) ~/
          widget.cards.length;

      final fortuneResult = FortuneResult(
        id: const Uuid().v4(),
        type: 'tarot',
        title: '타로 리딩',
        date: dateStr,
        summary: cardNames,
        content: '${widget.cards.length}장 카드 리딩',
        overallScore: score,
        createdAt: now.toIso8601String(),
      );

      await _historyRepo.saveWithPayload(
        result: fortuneResult,
        payload: {'cards': widget.cards.map((c) => c.toJson()).toList()},
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

    return Scaffold(
      appBar: AppBar(
        title: Text(appState.t('tarot.result')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cards Display
            ...widget.cards.asMap().entries.map((entry) {
              final index = entry.key;
              final card = entry.value;
              final positionLabel = widget.cards.length == 3
                  ? ['과거', '현재', '미래'][index]
                  : '선택한 카드';

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: card.isReversed
                        ? Colors.red.withValues(alpha: 0.3)
                        : AppColors.primary.withValues(alpha: 0.3),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Position & Reversed Badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          positionLabel,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.textTheme.bodySmall?.color,
                          ),
                        ),
                        if (card.isReversed)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              appState.t('tarot.reversed'),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Card Name
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              '${card.id}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isKorean ? card.nameKo : card.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                isKorean ? card.name : card.nameKo,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.textTheme.bodySmall?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Meaning
                    Text(
                      appState.t('tarot.meaning'),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      card.isReversed
                          ? (isKorean ? card.reversedKo : card.reversed)
                          : (isKorean ? card.uprightKo : card.upright),
                      style: const TextStyle(fontSize: 14, height: 1.5),
                    ),
                    const SizedBox(height: 12),

                    // Description
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.sage.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lightbulb_outline,
                            size: 18,
                            color: AppColors.sage,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              isKorean ? card.descriptionKo : card.description,
                              style: const TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 24),

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
