import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:oracle_flutter/app/models/tarot_card.dart';
import 'package:oracle_flutter/app/models/tarot_spread.dart';
import 'package:oracle_flutter/app/models/fortune_result.dart';
import 'package:oracle_flutter/app/database/history_repository.dart';
import 'package:oracle_flutter/app/history/history_payload.dart';
import 'package:share_plus/share_plus.dart';

class TarotResultScreen extends StatefulWidget {
  final List<TarotCard> cards;
  final TarotSpread? spread;
  final String? question;

  const TarotResultScreen({
    super.key,
    required this.cards,
    this.spread,
    this.question,
  });

  @override
  State<TarotResultScreen> createState() => _TarotResultScreenState();
}

class _TarotResultScreenState extends State<TarotResultScreen> {
  final _historyRepo = HistoryRepository();
  bool _isSaving = false;

  TarotSpread get _spread => widget.spread ?? TarotSpread.pastPresentFuture;

  Future<void> _handleSave() async {
    setState(() => _isSaving = true);

    try {
      final now = DateTime.now();
      final dateStr = DateFormat('yyyy-MM-dd').format(now);

      final cardNames = widget.cards.map((c) => c.nameKo).join(', ');
      final score =
          widget.cards
              .map((card) {
                final base = 68 + (card.id % 10) * 2;
                return card.isReversed ? base - 12 : base + 6;
              })
              .reduce((a, b) => a + b) ~/
          widget.cards.length;

      final fortuneResult = FortuneResult(
        id: const Uuid().v4(),
        type: 'tarot',
        title: '${_spread.name} 리딩',
        date: dateStr,
        summary: cardNames,
        content: '${_spread.name} • ${widget.cards.length}장 카드 리딩',
        overallScore: score,
        createdAt: now.toIso8601String(),
      );

      await _historyRepo
          .saveWithPayload(
            result: fortuneResult,
            payload: HistoryPayload.wrap(
              feature: 'tarot',
              summary: {
                'title': fortuneResult.title,
                'spreadId': _spread.id,
                'cardsCount': widget.cards.length,
                'overallScore': score,
                'date': fortuneResult.date,
              },
              data: {'cards': widget.cards.map((c) => c.toJson()).toList()},
            ),
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
          feature: 'tarot',
          action: 'save',
          message: e.toString(),
          debug: {'runtimeType': e.runtimeType.toString()},
        );
      } catch (_) {}
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('저장 중 오류가 발생했습니다. (${e.runtimeType})')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _handleShare() async {
    final cardLines = widget.cards
        .asMap()
        .entries
        .map((entry) {
          final idx = entry.key;
          final card = entry.value;
          final label = _spread.positionLabels[idx];
          final orientation = card.isReversed ? '역방향' : '정방향';
          final meaning = card.isReversed ? card.reversedKo : card.uprightKo;
          return '[$label] ${card.nameKo} ($orientation)\n  → $meaning';
        })
        .join('\n\n');

    final shareLines = <String>['🔮 ${_spread.name} 타로 리딩 결과', '', cardLines];

    try {
      await Share.share(
        shareLines.join('\n'),
        subject: '${_spread.name} 타로 리딩 결과',
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('공유 중 오류가 발생했습니다.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(_spread.name), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 스프레드 헤더
            _buildSpreadHeader(theme),
            const SizedBox(height: 20),

            // 예/아니오 특별 UI
            if (_spread.id == 'yesno') ...[
              _buildYesNoResult(theme),
              const SizedBox(height: 20),
            ],

            // 카드별 상세
            ...widget.cards.asMap().entries.map((entry) {
              final index = entry.key;
              final card = entry.value;
              return _buildCardDetail(theme, card, index);
            }),

            // 종합 메시지
            _buildSummarySection(theme),
            const SizedBox(height: 24),

            // 버튼
            _buildActionButtons(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildSpreadHeader(ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.12),
            AppColors.caramel.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(_spread.icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _spread.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${widget.cards.length}장의 카드 리딩',
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
    );
  }

  Widget _buildYesNoResult(ThemeData theme) {
    final card = widget.cards.first;
    final isYes = !card.isReversed;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isYes
            ? Colors.green.withValues(alpha: 0.1)
            : Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isYes
              ? Colors.green.withValues(alpha: 0.3)
              : Colors.red.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(isYes ? '✅' : '❌', style: const TextStyle(fontSize: 56)),
          const SizedBox(height: 12),
          Text(
            isYes ? '예 (Yes)' : '아니오 (No)',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: isYes ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isYes
                ? '카드가 정방향으로 나타났습니다. 긍정적인 기운이 함께합니다.'
                : '카드가 역방향으로 나타났습니다. 좀 더 신중한 접근이 필요합니다.',
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCardDetail(ThemeData theme, TarotCard card, int index) {
    final label = _spread.positionLabels[index];

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
          // 위치 라벨 + 역방향 뱃지
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
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
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.swap_vert, size: 12, color: Colors.red),
                      SizedBox(width: 4),
                      Text(
                        '역방향',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          // 카드 이미지 + 이름
          Row(
            children: [
              Container(
                width: 60,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: card.isReversed
                          ? Colors.red.withValues(alpha: 0.25)
                          : AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: card.isReversed
                      ? Transform.rotate(
                          angle: pi,
                          child: _buildCardImage(card),
                        )
                      : _buildCardImage(card),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.nameKo,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      card.name,
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

          // 키워드
          Text(
            card.isReversed ? '역방향 키워드' : '정방향 키워드',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            card.isReversed ? card.reversedKo : card.uprightKo,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 14),

          // 핵심 메시지
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.sage.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  size: 18,
                  color: AppColors.sage,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    card.descriptionKo,
                    style: const TextStyle(fontSize: 13, height: 1.5),
                  ),
                ),
              ],
            ),
          ),

          // 영역별 조언 (스프레드에 따라)
          if (_shouldShowAdvice()) ...[
            const SizedBox(height: 14),
            _buildAdviceSection(card),
          ],
        ],
      ),
    );
  }

  bool _shouldShowAdvice() {
    return _spread.adviceField != 'general' || _spread.cardCount >= 3;
  }

  Widget _buildAdviceSection(TarotCard card) {
    final adviceField = _spread.adviceField;

    // 연애/이별 카테고리 → loveAdvice
    if (adviceField == 'loveAdvice' && card.loveAdvice.isNotEmpty) {
      return _buildAdviceTile('💕 연애 조언', card.loveAdvice);
    }

    // 일반 스프레드 → 4가지 영역 모두 표시
    final advices = <Widget>[];
    if (card.loveAdvice.isNotEmpty) {
      advices.add(_buildAdviceTile('💕 연애', card.loveAdvice));
    }
    if (card.moneyAdvice.isNotEmpty) {
      advices.add(_buildAdviceTile('💰 재물', card.moneyAdvice));
    }
    if (card.healthAdvice.isNotEmpty) {
      advices.add(_buildAdviceTile('🏥 건강', card.healthAdvice));
    }
    if (card.workAdvice.isNotEmpty) {
      advices.add(_buildAdviceTile('💼 직업', card.workAdvice));
    }

    if (advices.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '영역별 조언',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        const SizedBox(height: 8),
        ...advices,
      ],
    );
  }

  Widget _buildAdviceTile(String label, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySection(ThemeData theme) {
    // 종합 메시지 생성
    final reversedCount = widget.cards.where((c) => c.isReversed).length;
    final uprightCount = widget.cards.length - reversedCount;
    final String overallMessage;

    if (widget.cards.length == 1) {
      final card = widget.cards.first;
      overallMessage = card.isReversed
          ? '카드가 역방향으로 나타나 현재 상황에서 주의가 필요한 부분이 있습니다. 내면의 목소리에 귀 기울이세요.'
          : '카드가 정방향으로 나타나 긍정적인 에너지가 함께합니다. 자신감을 가지고 나아가세요.';
    } else if (reversedCount == 0) {
      overallMessage =
          '모든 카드가 정방향으로 나타났습니다! 매우 긍정적인 에너지가 흐르고 있습니다. 지금의 방향이 올바릅니다.';
    } else if (uprightCount == 0) {
      overallMessage = '모든 카드가 역방향으로 나타났습니다. 지금은 멈추고 돌아볼 시기입니다. 내면의 성찰이 필요합니다.';
    } else {
      overallMessage =
          '정방향 ${uprightCount}장, 역방향 ${reversedCount}장이 나왔습니다. '
          '긍정적인 흐름 속에서도 주의할 부분이 있으니 균형 잡힌 시각으로 바라보세요.';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.starGold.withValues(alpha: 0.1),
            AppColors.caramel.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.starGold.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🌟', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                '종합 메시지',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            overallMessage,
            style: const TextStyle(fontSize: 14, height: 1.6),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _isSaving ? null : _handleSave,
            icon: _isSaving
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.bookmark_border, size: 18),
            label: const Text('저장'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _handleShare,
            icon: const Icon(Icons.share, size: 18),
            label: const Text('공유'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: FilledButton(
            onPressed: () => context.go('/home'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('확인'),
          ),
        ),
      ],
    );
  }

  Widget _buildCardImage(TarotCard card) {
    return Image.asset(
      'assets/images/tarot/card_${card.id}.png',
      width: 60,
      height: 90,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        return Container(
          width: 60,
          height: 90,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.caramel],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Text(
                card.nameKo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }
}
