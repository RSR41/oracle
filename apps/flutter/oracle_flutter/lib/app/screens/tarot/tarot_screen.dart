import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:oracle_flutter/app/models/tarot_card.dart';
import 'package:oracle_flutter/app/services/fortune_service.dart';

class TarotScreen extends StatefulWidget {
  const TarotScreen({super.key});

  @override
  State<TarotScreen> createState() => _TarotScreenState();
}

class _TarotScreenState extends State<TarotScreen>
    with SingleTickerProviderStateMixin {
  final _random = Random();
  final FortuneService _fortuneService = FortuneService();

  List<TarotCard> _deck = [];
  List<TarotCard> _selectedCards = [];
  bool _isShuffling = false;
  bool _hasDrawn = false;
  late AnimationController _shuffleController;

  @override
  void initState() {
    super.initState();
    _shuffleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _initDeck();
  }

  @override
  void dispose() {
    _shuffleController.dispose();
    super.dispose();
  }

  Future<void> _initDeck() async {
    try {
      final cards = await _fortuneService.loadTarotCards();
      _deck = cards.isEmpty ? List.from(TarotDeck.majorArcana) : cards;
    } catch (_) {
      _deck = List.from(TarotDeck.majorArcana);
    }

    if (!mounted) return;
    setState(() {
      _selectedCards = [];
      _hasDrawn = false;
    _deck = List.from(TarotDeck.majorArcana);
    _selectedCards = [];
    _hasDrawn = false;

    final loadedDeck = await TarotDeckLoader.loadDeck();
    if (!mounted) return;

    setState(() {
      _deck = loadedDeck;
    });
  }

  Future<void> _shuffle() async {
    setState(() => _isShuffling = true);
    _shuffleController.repeat(reverse: true);

    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _deck.shuffle(_random);
      _isShuffling = false;
      _hasDrawn = false;
      _selectedCards = [];
    });
    _shuffleController.stop();
    _shuffleController.reset();
  }

  void _drawCards(int count) {
    if (_hasDrawn) return;

    final drawnCards = <TarotCard>[];
    for (int i = 0; i < count && i < _deck.length; i++) {
      final card = _deck[i];
      // 30% chance of reversed
      final isReversed = _random.nextDouble() < 0.3;
      drawnCards.add(card.copyWith(isReversed: isReversed));
    }

    setState(() {
      _selectedCards = drawnCards;
      _hasDrawn = true;
    });
  }

  void _viewResult() {
    if (_selectedCards.isEmpty) return;
    context.push('/tarot-result', extra: _selectedCards);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(appState.t('fortune.tarot')),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.caramel.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    size: 48,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    appState.t('screen.fortune.tarotTitle'),
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    appState.t('screen.fortune.tarotDesc'),
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Card Deck Display
            AnimatedBuilder(
              animation: _shuffleController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _isShuffling ? _shuffleController.value * 0.1 : 0,
                  child: child,
                );
              },
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.2),
                  ),
                ),
                child: _hasDrawn ? _buildSelectedCards() : _buildCardBack(),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            if (!_hasDrawn) ...[
              // Shuffle Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isShuffling ? null : _shuffle,
                  icon: const Icon(Icons.shuffle),
                  label: Text(appState.t('tarot.shuffle')),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Draw Options
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _isShuffling ? null : () => _drawCards(1),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(appState.t('tarot.draw1')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _isShuffling ? null : () => _drawCards(3),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.sage,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(appState.t('tarot.draw3')),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // View Result & Reset
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _initDeck();
                        });
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(appState.t('tarot.reset')),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _viewResult,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(appState.t('fortune.viewResult')),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(5, (index) {
          return Transform.translate(
            offset: Offset(index * 8.0 - 16, 0),
            child: Container(
              width: 100,
              height: 150,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B5B95), Color(0xFF9B8FC4)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: const Center(
                child: Icon(Icons.auto_awesome, color: Colors.white, size: 32),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSelectedCards() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _selectedCards.map((card) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Transform.rotate(
              angle: card.isReversed ? 3.14159 : 0,
              child: Container(
                width: 90,
                height: 135,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF5E6D3), Color(0xFFE8D5C4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${card.id}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        card.nameKo,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
