import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../navigation/nav_state.dart';

/// Simple placeholder for Tabs and functional screens.
class SimpleScreen extends StatelessWidget {
  final String screenName;
  final NavState navState;

  const SimpleScreen({
    super.key,
    required this.screenName,
    required this.navState,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(screenName)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Screen: $screenName',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            // Test Buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () {
                    // Simulate React onNavigate('face')
                    navState.navigate('face');
                    context.push('/face');
                  },
                  child: const Text('Go to Face'),
                ),
                OutlinedButton(
                  onPressed: () {
                    navState.navigate('settings');
                    context.push('/settings');
                  },
                  child: const Text('Go to Settings'),
                ),
                OutlinedButton(
                  onPressed: () {
                    navState.navigate('fortune-today');
                    context.push('/fortune-today');
                  },
                  child: const Text('Go to Fortune Today (Placeholder)'),
                ),
                if (screenName == 'history')
                  OutlinedButton(
                    onPressed: () {
                      navState.navigate('fortune-detail', data: {'id': '123'});
                      context.push('/fortune-detail', extra: {'id': '123'});
                    },
                    child: const Text('Go to Detail (ID: 123)'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
