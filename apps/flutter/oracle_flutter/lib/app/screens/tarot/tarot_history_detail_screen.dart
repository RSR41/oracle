import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_flutter/app/database/history_repository.dart';
import 'package:oracle_flutter/app/models/fortune_result.dart';
import 'package:oracle_flutter/app/models/tarot_card.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:oracle_flutter/app/i18n/translations.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class TarotHistoryDetailScreen extends StatefulWidget {
  final FortuneResult result;

  const TarotHistoryDetailScreen({super.key, required this.result});

  @override
  State<TarotHistoryDetailScreen> createState() => _TarotHistoryDetailScreenState();
}

class _TarotHistoryDetailScreenState extends State<TarotHistoryDetailScreen> {
  final HistoryRepository _historyRepository = HistoryRepository();

  bool _isLoading = true;
  bool _isDeleting = false;
  List<TarotCard> _cards = [];
  String? _question;

  @override
  void initState() {
    super.initState();
    _loadPayload();
  }

  Future<void> _loadPayload() async {
    try {
      final payload = await _historyRepository.getPayload(widget.result.id);
      final rawCards = payload?['cards'];
      final restoredCards = <TarotCard>[];

      if (rawCards is List) {
        for (final rawCard in rawCards) {
          if (rawCard is Map) {
            restoredCards.add(
              TarotCard.fromJson(Map<String, dynamic>.from(rawCard)),
            );
          }
        }
      }

      if (!mounted) return;
      setState(() {
        _cards = restoredCards;
        _question = payload?['question'] as String?;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.read<AppState>().t('fortune.saveError'))),
      );
    }
  }

  Future<void> _handleShare() async {
    final appState = context.read<AppState>();
    final isKorean = appState.language == AppLanguage.ko;

    final cardLines = _cards.map((card) {
      final name = isKorean ? card.nameKo : card.name;
      final orientation = card.isReversed ? appState.t('tarot.reversed') : '정방향';
      final meaning = card.isReversed
          ? (isKorean ? card.reversedKo : card.reversed)
          : (isKorean ? card.uprightKo : card.upright);
      return '- $name ($orientation): $meaning';
    }).join('\n');

    final shareText = [
      '타로 기록 상세',
      if (_question != null && _question!.trim().isNotEmpty) '질문: ${_question!.trim()}',
      '',
      '선택 카드',
      if (cardLines.isEmpty) '(카드 정보 없음)' else cardLines,
    ].join('\n');

    try {
      await Share.share(shareText, subject: '타로 기록 상세');
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.read<AppState>().t('fortune.saveError'))),
      );
    }
  }

  Future<void> _handleDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('삭제'),
        content: const Text('이 기록을 삭제하시겠습니까?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('취소')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('삭제')),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isDeleting = true);
    try {
      await _historyRepository.delete(widget.result.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('삭제되었습니다.')));
      context.pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _isDeleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.read<AppState>().t('fortune.saveError'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();
    final isKorean = appState.language == AppLanguage.ko;

    return Scaffold(
      appBar: AppBar(
        title: const Text('타로 기록 상세'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_question != null && _question!.trim().isNotEmpty) ...[
                    Text('질문', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(_question!),
                    const SizedBox(height: 20),
                  ],
                  if (_cards.isEmpty)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('저장된 카드 데이터가 없습니다.'),
                      ),
                    )
                  else
                    ..._cards.map((card) {
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
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  isKorean ? card.nameKo : card.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (card.isReversed)
                                  Text(
                                    appState.t('tarot.reversed'),
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              card.isReversed
                                  ? (isKorean ? card.reversedKo : card.reversed)
                                  : (isKorean ? card.uprightKo : card.upright),
                            ),
                          ],
                        ),
                      );
                    }),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _handleShare,
                          child: Text(appState.t('common.share')),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: _isDeleting ? null : _handleDelete,
                          style: FilledButton.styleFrom(backgroundColor: Colors.redAccent),
                          child: _isDeleting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text('삭제'),
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
