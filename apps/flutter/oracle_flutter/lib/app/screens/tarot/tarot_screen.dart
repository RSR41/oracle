import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:oracle_flutter/app/models/tarot_card.dart';
import 'package:oracle_flutter/app/models/tarot_spread.dart';
import 'package:oracle_flutter/app/services/tarot/tarot_data_service.dart';

class TarotScreen extends StatefulWidget {
  const TarotScreen({super.key});

  @override
  State<TarotScreen> createState() => _TarotScreenState();
}

enum TarotPhase { selectCategory, ready, shuffling, interpreting, resultReady }

class _TarotScreenState extends State<TarotScreen>
    with TickerProviderStateMixin {
  final _random = Random();
  final TarotDataService _tarotDataService = TarotDataService();
  List<TarotCard> _deck = [];
  List<TarotCard> _selectedCards = [];
  bool _isLoadingDeck = true;
  bool _deckLoadFailed = false;

  TarotPhase _phase = TarotPhase.selectCategory;
  TarotSpread? _selectedSpread;

  // Riffle shuffle animation controllers
  late AnimationController _riffleController;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  // Number of cards in the riffle visual
  static const int _riffleCardCount = 10;

  @override
  void initState() {
    super.initState();
    _riffleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
    _loadDeck();
  }

  @override
  void dispose() {
    _riffleController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _loadDeck() async {
    setState(() {
      _isLoadingDeck = true;
      _deckLoadFailed = false;
    });

    try {
      final cards = await _tarotDataService.loadCards();
      if (!mounted) return;
      setState(() {
        _deck = List.from(cards);
        _isLoadingDeck = false;
        _deckLoadFailed = cards.isEmpty;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _deck = [];
        _isLoadingDeck = false;
        _deckLoadFailed = true;
      });
    }
  }

  void _selectSpread(TarotSpread spread) {
    setState(() {
      _selectedSpread = spread;
      _phase = TarotPhase.ready;
      _selectedCards = [];
    });
  }

  Future<void> _startReading() async {
    if (_selectedSpread == null || _deck.isEmpty) return;

    // Phase 1: Riffle shuffle
    setState(() => _phase = TarotPhase.shuffling);
    _riffleController.forward(from: 0.0);
    await Future.delayed(const Duration(milliseconds: 2800));

    // Phase 2: Interpreting
    if (!mounted) return;
    setState(() => _phase = TarotPhase.interpreting);
    _glowController.repeat(reverse: true);

    // Draw cards
    _deck.shuffle(_random);
    final count = _selectedSpread!.cardCount;
    final drawnCards = <TarotCard>[];
    for (int i = 0; i < count && i < _deck.length; i++) {
      final card = _deck[i];
      final isReversed = _random.nextDouble() < 0.3;
      drawnCards.add(card.copyWith(isReversed: isReversed));
    }
    _selectedCards = drawnCards;

    await Future.delayed(const Duration(milliseconds: 1800));
    _glowController.stop();

    if (!mounted) return;
    setState(() => _phase = TarotPhase.resultReady);
  }

  void _viewResult() {
    if (_selectedCards.isEmpty || _selectedSpread == null) return;
    context.push(
      '/tarot-result',
      extra: {'cards': _selectedCards, 'spread': _selectedSpread},
    );
  }

  void _reset() {
    _riffleController.reset();
    setState(() {
      _phase = TarotPhase.selectCategory;
      _selectedSpread = null;
      _selectedCards = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoadingDeck) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_deckLoadFailed) {
      return Scaffold(
        appBar: AppBar(title: const Text('타로'), centerTitle: true),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 48,
              ),
              const SizedBox(height: 12),
              const Text(
                '덱 로딩 실패',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              FilledButton(onPressed: _loadDeck, child: const Text('다시 시도')),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('타로'),
        centerTitle: true,
        leading: _phase != TarotPhase.selectCategory
            ? IconButton(icon: const Icon(Icons.arrow_back), onPressed: _reset)
            : null,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _buildPhaseContent(theme),
      ),
    );
  }

  Widget _buildPhaseContent(ThemeData theme) {
    switch (_phase) {
      case TarotPhase.selectCategory:
        return _buildCategorySelection(theme);
      case TarotPhase.ready:
        return _buildReadyScreen(theme);
      case TarotPhase.shuffling:
        return _buildRiffleShuffleScreen(theme);
      case TarotPhase.interpreting:
        return _buildInterpretingScreen(theme);
      case TarotPhase.resultReady:
        return _buildResultReadyScreen(theme);
    }
  }

  // ── Phase 0: 카테고리 선택 ──
  Widget _buildCategorySelection(ThemeData theme) {
    return SingleChildScrollView(
      key: const ValueKey('category'),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 헤더
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.15),
                  AppColors.caramel.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/tarot/back.png',
                    width: 60,
                    height: 90,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        const Text('🔮', style: TextStyle(fontSize: 36)),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '타로 카드 리딩',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '궁금한 주제를 선택하고 카드의 메시지를 받아보세요',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.textTheme.bodySmall?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '리딩 카테고리',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...TarotSpread.all.map((s) => _buildSpreadCard(theme, s)),
        ],
      ),
    );
  }

  Widget _buildSpreadCard(ThemeData theme, TarotSpread spread) {
    return GestureDetector(
      onTap: () => _selectSpread(spread),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.dividerColor.withValues(alpha: 0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(spread.icon, style: const TextStyle(fontSize: 24)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spread.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    spread.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.textTheme.bodySmall?.color,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.starGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${spread.cardCount}장',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.starGold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: theme.textTheme.bodySmall?.color,
            ),
          ],
        ),
      ),
    );
  }

  // ── Phase 1: 준비 화면 ──
  Widget _buildReadyScreen(ThemeData theme) {
    final spread = _selectedSpread!;
    return SingleChildScrollView(
      key: const ValueKey('ready'),
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(spread.icon, style: const TextStyle(fontSize: 64)),
          const SizedBox(height: 20),
          Text(
            spread.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            spread.description,
            style: theme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: spread.positionLabels.map((label) {
              return Chip(
                label: Text(label, style: const TextStyle(fontSize: 12)),
                backgroundColor: AppColors.primary.withValues(alpha: 0.08),
                side: BorderSide.none,
                padding: EdgeInsets.zero,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          if (spread.id == 'yesno')
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: AppColors.sage.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: AppColors.sage),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '예/아니오로 답할 수 있는 질문을 마음속으로 정하세요.\n정방향 = 예 ✅  |  역방향 = 아니오 ❌',
                      style: TextStyle(fontSize: 12, color: AppColors.sage),
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              onPressed: _startReading,
              icon: const Icon(Icons.auto_awesome, size: 20),
              label: const Text(
                '타로 시작',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ══════════════════════════════════════════════
  //  Phase 2: Casino Riffle Shuffle Animation
  // ══════════════════════════════════════════════
  Widget _buildRiffleShuffleScreen(ThemeData theme) {
    return Center(
      key: const ValueKey('shuffling'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 280,
            height: 220,
            child: AnimatedBuilder(
              animation: _riffleController,
              builder: (context, _) {
                return CustomPaint(
                  painter: _RifflePainter(progress: _riffleController.value),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: _buildRiffleCards(_riffleController.value),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 28),
          Text(
            '카드 섞는 중...',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '마음을 가다듬고 질문에 집중하세요',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              value: _riffleController.value,
              borderRadius: BorderRadius.circular(8),
              color: AppColors.primary,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildRiffleCards(double progress) {
    final cards = <Widget>[];
    const cardW = 80.0;
    const cardH = 120.0;

    for (int i = 0; i < _riffleCardCount; i++) {
      final isLeft = i < _riffleCardCount ~/ 2;
      final localIndex = isLeft ? i : i - _riffleCardCount ~/ 2;
      final maxCards = _riffleCardCount ~/ 2;

      // Phase timing: split(0-0.25), riffle(0.25-0.75), merge(0.75-1.0)
      double dx, dy, angle;

      if (progress < 0.25) {
        // Split: cards move from center to left/right piles
        final t = (progress / 0.25).clamp(0.0, 1.0);
        final splitX = isLeft ? -60.0 : 60.0;
        dx = splitX * t + (localIndex - maxCards / 2) * 2.0;
        dy = localIndex * 1.5;
        angle = 0.0;
      } else if (progress < 0.75) {
        // Riffle: cards interleave from alternating sides
        final t = ((progress - 0.25) / 0.5).clamp(0.0, 1.0);
        final cardProgress = (t * _riffleCardCount - i).clamp(0.0, 1.0);

        final splitX = isLeft ? -60.0 : 60.0;
        dx =
            splitX * (1 - cardProgress) +
            (i - _riffleCardCount / 2) * 3.0 * cardProgress;
        dy = localIndex * 1.5 * (1 - cardProgress) + i * 2.0 * cardProgress;

        // Card flicks up then down as it interleaves
        final flickCurve = sin(cardProgress * pi);
        dy -= flickCurve * 25.0;
        angle = (isLeft ? -0.08 : 0.08) * (1 - cardProgress);
      } else {
        // Merge: all cards come together into one neat pile
        final t = ((progress - 0.75) / 0.25).clamp(0.0, 1.0);
        final spreadX = (i - _riffleCardCount / 2) * 3.0;
        dx = spreadX * (1 - t);
        dy = i * 2.0 * (1 - t) + i * 0.5 * t;
        angle = 0.0;
      }

      cards.add(
        Positioned(
          left: 100 + dx,
          top: 40 + dy,
          child: Transform.rotate(
            angle: angle,
            child: Container(
              width: cardW,
              height: cardH,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: const Offset(1, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  'assets/images/tarot/back.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.caramel],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Center(
                      child: Text('🔮', style: TextStyle(fontSize: 22)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return cards;
  }

  // ── Phase 3: 결과 해석 중 ──
  Widget _buildInterpretingScreen(ThemeData theme) {
    return Center(
      key: const ValueKey('interpreting'),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.starGold.withValues(
                        alpha: _glowAnimation.value * 0.4,
                      ),
                      blurRadius: 30 * _glowAnimation.value,
                      spreadRadius: 5 * _glowAnimation.value,
                    ),
                  ],
                ),
                child: child,
              );
            },
            child: const Center(
              child: Text('✨', style: TextStyle(fontSize: 56)),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            '결과 해석 중...',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '카드의 메시지를 읽고 있습니다',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  // ── Phase 4: 결과 보기 준비 ──
  Widget _buildResultReadyScreen(ThemeData theme) {
    final spread = _selectedSpread!;
    return SingleChildScrollView(
      key: const ValueKey('resultReady'),
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text('🎴', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 20),
          Text(
            '리딩 완료!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${spread.name} • ${_selectedCards.length}장의 카드',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 20),
          // Card previews using real images
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: _selectedCards.asMap().entries.map((e) {
              final idx = e.key;
              final card = e.value;
              final label = spread.positionLabels[idx];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 70,
                    height: 105,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: card.isReversed
                              ? Colors.red.withValues(alpha: 0.3)
                              : AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: card.isReversed
                          ? Transform.rotate(
                              angle: pi,
                              child: _buildCardImage(card, 70, 105),
                            )
                          : _buildCardImage(card, 70, 105),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(label, style: const TextStyle(fontSize: 10)),
                  if (card.isReversed)
                    const Text(
                      '역방향',
                      style: TextStyle(fontSize: 9, color: Colors.red),
                    ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              onPressed: _viewResult,
              icon: const Icon(Icons.visibility, size: 20),
              label: const Text(
                '결과 보기',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: _reset, child: const Text('다른 카테고리 선택')),
        ],
      ),
    );
  }

  /// Builds a card face image with fallback
  Widget _buildCardImage(TarotCard card, double width, double height) {
    return Image.asset(
      'assets/images/tarot/card_${card.id}.png',
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) {
        // Fallback for cards without images (Minor Arcana 22-77)
        return Container(
          width: width,
          height: height,
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

/// Custom painter that draws subtle guide lines during the riffle
class _RifflePainter extends CustomPainter {
  final double progress;
  _RifflePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    // Subtle table surface effect
    final tablePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    final tableRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(20, size.height - 20, size.width - 40, 10),
      const Radius.circular(5),
    );
    canvas.drawRRect(tableRect, tablePaint);
  }

  @override
  bool shouldRepaint(_RifflePainter old) => old.progress != progress;
}
