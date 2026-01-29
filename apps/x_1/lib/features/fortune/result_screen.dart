import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:x_1/features/fortune/fortune_provider.dart';
import 'package:x_1/core/theme/app_colors.dart';
import 'package:x_1/core/utils/mock_fortune_service.dart';
import 'package:x_1/router/app_router.dart';
import 'package:x_1/features/history/history_provider.dart';
import 'package:x_1/shared/domain/models/history.dart';
import 'package:uuid/uuid.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  void _saveResult(BuildContext context, WidgetRef ref,
      Map<String, dynamic> data, String summary) {
    final history = History(
      id: const Uuid().v4(),
      type: 'fortune',
      createdAt: DateTime.now().toString(),
      result: data,
      summary: summary,
    );
    ref.read(historyNotifierProvider.notifier).addHistory(history);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved to History')),
    );
  }

  void _shareResult(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to Clipboard')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fortuneState = ref.watch(fortuneProvider);
    final profile = fortuneState.currentProfile;

    if (profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Result')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('No result found. Please enter info first.'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go(AppRoute.input.path),
                child: const Text('Enter Profile'),
              ),
            ],
          ),
        ),
      );
    }

    final data = MockFortuneService.generateSaju(profile);
    final summary = data['summary'] as String;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Fortune'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _saveResult(context, ref, data, summary),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _shareResult(context, summary),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '${profile.name}\'s Destiny',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _PillarCard(label: 'Year', kanji: data['year'], korean: ''),
                _PillarCard(label: 'Month', kanji: data['month'], korean: ''),
                _PillarCard(label: 'Day', kanji: data['day'], korean: ''),
                _PillarCard(label: 'Time', kanji: data['time'], korean: ''),
              ],
            ),
            const SizedBox(height: 32),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Lucky Items',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.luckyGold,
                              radius: 24,
                              child: Text(data['luckyColor'][0],
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 10)),
                            ),
                            const SizedBox(height: 8),
                            Text(data['luckyColor'],
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              data['luckyNumber'].toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .displayMedium
                                  ?.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text('Number',
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  summary,
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PillarCard extends StatelessWidget {
  final String label;
  final String kanji;
  final String korean;

  const _PillarCard({
    required this.label,
    required this.kanji,
    required this.korean,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.labelSmall),
        const SizedBox(height: 4),
        Container(
          width: 60,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.1 * 255).round()),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                kanji,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                korean,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
