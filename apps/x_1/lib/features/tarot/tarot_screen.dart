import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_1/core/theme/app_colors.dart';
import 'package:x_1/core/utils/mock_fortune_service.dart';
import 'package:x_1/features/history/history_provider.dart';
import 'package:x_1/shared/domain/models/history.dart';
import 'package:uuid/uuid.dart';

class TarotScreen extends ConsumerStatefulWidget {
  const TarotScreen({super.key});

  @override
  ConsumerState<TarotScreen> createState() => _TarotScreenState();
}

class _TarotScreenState extends ConsumerState<TarotScreen> {
  final Set<int> _selectedCards = {};
  bool _showResult = false;
  Map<String, dynamic>? _resultData;

  void _toggleCard(int index) {
    if (_showResult) return;

    setState(() {
      if (_selectedCards.contains(index)) {
        _selectedCards.remove(index);
      } else if (_selectedCards.length < 3) {
        _selectedCards.add(index);
      }
    });
  }

  void _reveal() {
    if (_selectedCards.length == 3) {
      setState(() {
        _showResult = true;
        _resultData = MockFortuneService.generateTarot();
      });
    }
  }

  void _reset() {
    setState(() {
      _selectedCards.clear();
      _showResult = false;
      _resultData = null;
    });
  }

  void _saveResult() {
    if (_resultData == null) return;

    final history = History(
      id: const Uuid().v4(),
      type: 'tarot',
      createdAt: DateTime.now().toString(),
      result: _resultData!,
      summary: _resultData!['summary'],
    );

    ref.read(historyNotifierProvider.notifier).addHistory(history);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved to History')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarot Reading'),
        actions: _showResult
            ? [
                IconButton(
                  icon: const Icon(Icons.save),
                  onPressed: _saveResult,
                )
              ]
            : null,
      ),
      body: Column(
        children: [
          // Instruction / Status
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _showResult
                  ? 'Your Past, Present, and Future'
                  : 'Focus on your question and pick 3 cards (${_selectedCards.length}/3)',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),

          if (_showResult && _resultData != null)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _ResultCard(
                            label: 'Past', cardName: _resultData!['past']),
                        _ResultCard(
                            label: 'Present',
                            cardName: _resultData!['present']),
                        _ResultCard(
                            label: 'Future', cardName: _resultData!['future']),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _resultData!['summary'],
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: _reset,
                      child: const Text('New Reading'),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6, // 6 columns for 36 cards
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: 36,
                itemBuilder: (context, index) {
                  final isSelected = _selectedCards.contains(index);
                  return GestureDetector(
                    onTap: () => _toggleCard(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            isSelected ? AppColors.primary : Colors.grey[300],
                        borderRadius: BorderRadius.circular(4),
                        border: isSelected
                            ? Border.all(color: AppColors.luckyGold, width: 2)
                            : null,
                      ),
                      child: Center(
                        child: isSelected
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 16)
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),

          if (!_showResult)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: _selectedCards.length == 3 ? _reveal : null,
                  child: const Text('View Result'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String label;
  final String cardName;

  const _ResultCard({required this.label, required this.cardName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: 120,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary),
          ),
          child: Center(
            child: Text(
              cardName,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
      ],
    );
  }
}
