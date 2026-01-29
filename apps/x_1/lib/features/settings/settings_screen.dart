import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:x_1/features/settings/settings_provider.dart';
import 'package:x_1/features/auth/auth_provider.dart';
import 'package:x_1/router/app_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: settingsAsync.when(
        data: (settings) {
          return ListView(
            children: [
              const _SectionHeader(title: 'Appearance'),
              ListTile(
                title: const Text('Theme'),
                subtitle: Text(settings.themeMode.name.toUpperCase()),
                leading: const Icon(Icons.brightness_6),
                onTap: () {
                  _showThemeDialog(context, ref, settings.themeMode);
                },
              ),
              const _SectionHeader(title: 'Preferences'),
              ListTile(
                title: const Text('Language'),
                subtitle: Text(settings.locale?.languageCode == 'ko'
                    ? 'Korean'
                    : 'English'),
                leading: const Icon(Icons.language),
                onTap: () {
                  _showLanguageDialog(context, ref, settings.locale);
                },
              ),
              SwitchListTile(
                title: const Text('Use Solar Calendar by Default'),
                secondary: const Icon(Icons.calendar_today),
                value: settings.isSolar,
                onChanged: (value) {
                  ref.read(settingsProvider.notifier).setCalendarType(value);
                },
              ),
              const _SectionHeader(title: 'Account'),
              ListTile(
                title: const Text('Logout'),
                leading: const Icon(Icons.logout, color: Colors.red),
                iconColor: Colors.red,
                textColor: Colors.red,
                onTap: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) {
                    context.go(AppRoute.login.path);
                  }
                },
              ),
              const SizedBox(height: 32),
              const Center(
                child: Text(
                  'EF v1.0.0',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  void _showThemeDialog(
      BuildContext context, WidgetRef ref, ThemeMode current) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Theme'),
        children: ThemeMode.values.map((mode) {
          return RadioListTile<ThemeMode>(
            title: Text(mode.name.toUpperCase()),
            value: mode,
            groupValue: current,
            onChanged: (value) {
              if (value != null) {
                ref.read(settingsProvider.notifier).setThemeMode(value);
                Navigator.pop(context);
              }
            },
          );
        }).toList(),
      ),
    );
  }

  void _showLanguageDialog(
      BuildContext context, WidgetRef ref, Locale? current) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Language'),
        children: [
          RadioListTile<String>(
            title: const Text('English'),
            value: 'en',
            groupValue: current?.languageCode ?? 'en',
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setLocale(const Locale('en'));
              Navigator.pop(context);
            },
          ),
          RadioListTile<String>(
            title: const Text('Korean'),
            value: 'ko',
            groupValue: current?.languageCode ?? 'en',
            onChanged: (value) {
              ref.read(settingsProvider.notifier).setLocale(const Locale('ko'));
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
