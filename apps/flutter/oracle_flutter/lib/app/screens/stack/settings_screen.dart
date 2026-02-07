import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oracle_flutter/app/state/app_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(title: Text(appState.t('settings.title'))),
      body: Center(child: Text(appState.t('settings.title'))),
    );
  }
}
