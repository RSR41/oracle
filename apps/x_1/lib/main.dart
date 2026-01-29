import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:x_1/router/app_router.dart';
import 'package:x_1/core/theme/app_theme.dart';
import 'package:x_1/core/constants/app_constants.dart';
import 'package:x_1/features/settings/settings_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(
    const ProviderScope(
      child: EFApp(),
    ),
  );
}

class EFApp extends ConsumerWidget {
  const EFApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    // Default to system settings if loading or error
    final settings = settingsAsync.valueOrNull;
    final themeMode = settings?.themeMode ?? ThemeMode.system;
    final locale = settings?.locale;

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // Localization
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppConstants.supportedLocales,

      // Navigation
      routerConfig: appRouter,
    );
  }
}
