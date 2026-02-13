import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:oracle_flutter/app/i18n/translations.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(appState.t('settings.title')),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // App Settings Section
          _buildSectionHeader(appState.t('settings.appSettings'), theme),
          const SizedBox(height: 12),

          // Theme Setting
          _buildSettingCard(
            theme,
            icon: Icons.color_lens,
            title: appState.t('settings.theme'),
            trailing: DropdownButton<AppThemePreference>(
              value: appState.theme,
              underline: const SizedBox(),
              onChanged: (value) {
                if (value != null) {
                  appState.setTheme(value);
                }
              },
              items: [
                DropdownMenuItem(
                  value: AppThemePreference.system,
                  child: Text(appState.t('settings.system')),
                ),
                DropdownMenuItem(
                  value: AppThemePreference.light,
                  child: Text(appState.t('settings.light')),
                ),
                DropdownMenuItem(
                  value: AppThemePreference.dark,
                  child: Text(appState.t('settings.dark')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Language Setting
          _buildSettingCard(
            theme,
            icon: Icons.language,
            title: appState.t('settings.language'),
            trailing: DropdownButton<AppLanguage>(
              value: appState.language,
              underline: const SizedBox(),
              onChanged: (value) {
                if (value != null) {
                  appState.setLanguage(value);
                }
              },
              items: const [
                DropdownMenuItem(value: AppLanguage.ko, child: Text('한국어')),
                DropdownMenuItem(value: AppLanguage.en, child: Text('English')),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Account Section
          _buildSectionHeader(appState.t('settings.account'), theme),
          const SizedBox(height: 12),

          // Clear Profile
          _buildSettingCard(
            theme,
            icon: Icons.person_off,
            title: appState.t('settings.clearProfile'),
            subtitle: appState.t('settings.clearProfileDesc'),
            onTap: () => _showClearProfileDialog(context, appState),
          ),

          const SizedBox(height: 32),

          // About Section
          _buildSectionHeader(appState.t('settings.about'), theme),
          const SizedBox(height: 12),
          _SettingsInfoSection(
            theme: theme,
            appState: appState,
            buildSettingCard: _buildSettingCard,
            onShowInfoDialog: _showInfoDialog,
          ),

          const SizedBox(height: 32),

          // Footer
          Center(
            child: Text(
              '© 2026 ORACLE. All rights reserved.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.mutedForeground,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildSettingCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.dividerColor.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing:
            trailing ??
            (onTap != null ? const Icon(Icons.chevron_right) : null),
        onTap: onTap,
      ),
    );
  }

  Future<void> _showClearProfileDialog(
    BuildContext context,
    AppState appState,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(appState.t('settings.clearProfile')),
        content: Text(appState.t('settings.clearProfileConfirm')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(appState.t('common.cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(appState.t('settings.clear')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await appState.clearProfile();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(appState.t('settings.profileCleared'))),
        );
      }
    }
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

class _SettingsInfoSection extends StatelessWidget {
  const _SettingsInfoSection({
    required this.theme,
    required this.appState,
    required this.buildSettingCard,
    required this.onShowInfoDialog,
  });

  final ThemeData theme;
  final AppState appState;
  final Widget Function(
    ThemeData theme, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) buildSettingCard;
  final void Function(BuildContext context, String title, String content)
  onShowInfoDialog;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSettingCard(
          theme,
          icon: Icons.info_outline,
          title: appState.t('settings.version'),
          subtitle: 'v1.1.0 (Phase 1)',
        ),
        buildSettingCard(
          theme,
          icon: Icons.privacy_tip_outlined,
          title: appState.t('settings.privacy'),
          onTap: () => onShowInfoDialog(
            context,
            'Privacy Policy',
            'Privacy policy will be available at oracle-saju.web.app/privacy',
          ),
        ),
        buildSettingCard(
          theme,
          icon: Icons.article_outlined,
          title: appState.t('settings.terms'),
          onTap: () => onShowInfoDialog(
            context,
            'Terms of Service',
            'Terms of service will be available at oracle-saju.web.app/terms',
          ),
        ),
        buildSettingCard(
          theme,
          icon: Icons.mail_outline,
          title: appState.t('settings.contact'),
          subtitle: 'support@oracle-saju.com',
        ),
      ],
    );
  }
}
