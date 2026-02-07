// Basic Flutter widget test for OracleApp.

import 'package:flutter_test/flutter_test.dart';

import 'package:oracle_flutter/main.dart';

void main() {
  testWidgets('OracleApp smoke test', (WidgetTester tester) async {
    // Initialize AppState

    // Build our app and trigger a frame.
    await tester.pumpWidget(const OracleApp());

    // Verify that the ThemeTestScreen is displayed.
    // The title contains "System / Language Test" (based on default values)
    // We check for "Language" text which is present in the body.
    expect(find.textContaining('Language'), findsOneWidget);
    expect(find.textContaining('Theme'), findsOneWidget);
  });
}
