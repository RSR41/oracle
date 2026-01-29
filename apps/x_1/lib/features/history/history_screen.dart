import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_1/features/history/history_provider.dart';
import 'package:x_1/core/theme/app_colors.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              // Confirm dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Clear All'),
                  content: const Text(
                      'Are you sure you want to delete all history?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(historyNotifierProvider.notifier).clearAll();
                        Navigator.pop(context);
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: historyAsync.when(
        data: (history) {
          if (history.isEmpty) {
            return const Center(child: Text('No history saved yet.'));
          }
          return ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final item = history[index];
              return Dismissible(
                key: Key(item.id),
                background: Container(color: AppColors.error),
                onDismissed: (_) {
                  ref
                      .read(historyNotifierProvider.notifier)
                      .deleteHistory(item.id);
                },
                child: ListTile(
                  title: Text(item.summary),
                  subtitle: Text(item.createdAt),
                  leading: Icon(_getIconForType(item.type)),
                  // TODO: onTap navigate to detail view re-using ResultScreen logic
                  // For MVP, just showing the list is P0. Detail view would require passing data.
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'fortune':
        return Icons.auto_awesome;
      case 'compatibility':
        return Icons.favorite;
      case 'tarot':
        return Icons.style;
      default:
        return Icons.history;
    }
  }
}
