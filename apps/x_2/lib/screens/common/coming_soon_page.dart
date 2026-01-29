import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ComingSoonPage extends StatelessWidget {
  final String title;
  final String description;

  const ComingSoonPage({
    super.key,
    this.title = 'ì¤€ë¹?ì¤‘ìž…?ˆë‹¤',
    this.description = '??ê¸°ëŠ¥?€ ê³?ì¶”ê????ˆì •?…ë‹ˆ??,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '?š§',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/');
                  }
                },
                child: const Text('?Œì•„ê°€ê¸?),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
