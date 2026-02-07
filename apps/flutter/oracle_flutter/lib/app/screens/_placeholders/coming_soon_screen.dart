import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../navigation/nav_state.dart';

/// Placeholder for "Coming Soon" or unimplemented feature screens.
class ComingSoonScreen extends StatelessWidget {
  final String screenName;
  final NavState navState;
  final Object? extra;

  const ComingSoonScreen({
    super.key,
    required this.screenName,
    required this.navState,
    this.extra,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('준비 중입니다'),
      ), // "Coming Soon" in Korean context
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('준비 중인 기능입니다', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text(
              'Screen: $screenName',
              style: const TextStyle(color: Colors.grey),
            ),
            if (extra != null)
              Text(
                'Extra: $extra',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                navState.back();
                if (context.canPop()) {
                  context.pop();
                }
              },
              child: const Text('돌아가기'), // "Back"
            ),
          ],
        ),
      ),
    );
  }
}
