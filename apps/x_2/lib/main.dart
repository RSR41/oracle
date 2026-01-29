import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:x_2/theme/app_theme.dart';
import 'package:x_2/navigation/app_routes.dart';

void main() {
  runApp(const ProviderScope(child: EfFigmaApp()));
}

class EfFigmaApp extends StatelessWidget {
  const EfFigmaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'EF Oracle',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}
