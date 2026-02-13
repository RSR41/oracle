import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../state/app_state.dart';
import '../../config/app_urls.dart';
import 'package:oracle_flutter/app/config/app_urls.dart';
import 'package:oracle_flutter/app/state/app_state.dart';
import 'package:oracle_flutter/app/theme/app_colors.dart';
import 'package:oracle_flutter/app/i18n/translations.dart';
import 'package:oracle_flutter/app/config/app_urls.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Section
          _buildSectionHeader(appState.t('settings.profile'), theme),
          const SizedBox(height: 16),

          _buildSettingCard(
            theme,
            icon: Icons.person_outline,
            title: appState.t('profile.name'),
            subtitle: appState.profile.name?.isNotEmpty == true
                ? appState.profile.name
                : appState.t('profile.notSet'),
          ),

          _buildSettingCard(
            theme,
            icon: Icons.cake_outlined,
            title: appState.t('profile.birthDate'),
            subtitle: appState.profile.birthDate?.isNotEmpty == true
                ? appState.profile.birthDate
                : appState.t('profile.notSet'),
          ),

          _buildSettingCard(
            theme,
            icon: Icons.access_time,
            title: appState.t('profile.birthTime'),
            subtitle: appState.profile.birthTime?.isNotEmpty == true
                ? appState.profile.birthTime
                : appState.t('profile.notSet'),
          ),

          _buildSettingCard(
            theme,
            icon: Icons.delete_outline,
            title: appState.t('settings.clearProfile'),
            trailing: const Icon(Icons.chevron_right, color: Colors.red),
            onTap: () => _showClearProfileDialog(context, appState),
          ),

          const SizedBox(height: 32),

          // App Settings
          _buildSectionHeader(appState.t('settings.appInfo'), theme),
          const SizedBox(height: 16),

          _buildSettingCard(
            theme,
            icon: Icons.info_outline,
            title: appState.t('settings.version'),
            subtitle: 'v1.1.0 (Phase 1)',
          ),

          _buildSettingCard(
            theme,
            icon: Icons.privacy_tip_outlined,
            title: appState.t('settings.privacy'),
            onTap: () => _openLegalUrl(context, AppUrls.privacyPolicy),
            onTap: () => _openUrl(
              context,
              'Privacy Policy',
              AppUrls.privacyPolicy,
              AppUrls.privacyPolicy,
              '개인정보처리방침 페이지를 열 수 없습니다. 네트워크 상태 또는 URL 설정을 확인해 주세요.',
            ),
            onTap: () => _launchExternalUrl(context, AppUrls.privacyPolicy),
            onTap: () => _openExternalLink(context, AppUrls.privacyPolicy),
          ),

          _buildSettingCard(
            theme,
            icon: Icons.article_outlined,
            title: appState.t('settings.terms'),
            onTap: () => _openLegalUrl(context, AppUrls.termsOfService),
            onTap: () => _openUrl(
              context,
              'Terms of Service',
              AppUrls.termsOfService,
              AppUrls.termsOfService,
              '이용약관 페이지를 열 수 없습니다. 네트워크 상태 또는 URL 설정을 확인해 주세요.',
            ),
            onTap: () => _launchExternalUrl(context, AppUrls.termsOfService),
            onTap: () => _openExternalLink(context, AppUrls.termsOfService),
          ),

          _buildSettingCard(
            theme,
            icon: Icons.mail_outline,
            title: appState.t('settings.contact'),
            subtitle: 'support@oracle-saju.com',
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

  Future<void> _openLegalUrl(BuildContext context, String url) async {
    if (!AppUrls.isValidUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('법적 문서 URL이 올바르지 않습니다.')),
      );
  Future<void> _showInfoDialog(
    BuildContext context,
    String title,
    String url,
  ) async {
    if (!AppUrls.isValidUrl(url)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$title URL is invalid.')),
  Future<void> _openUrl(
    BuildContext context,
    String url,
    String errorMessage,
  ) async {
    final uri = Uri.tryParse(url);

    if (uri == null || !AppUrls.isValidUrl(url)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
  Future<void> _launchExternalUrl(BuildContext context, String urlString) async {
    if (!AppUrls.isValidUrl(urlString)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('링크가 아직 설정되지 않았습니다. 배포 설정을 확인해주세요.'),
          ),
        );
      }
      return;
    }

    final uri = Uri.parse(url);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('문서를 열 수 없습니다. 잠시 후 다시 시도해주세요.')),
      );
    }
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open $title.')),
      );
    }
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
    final uri = Uri.parse(urlString);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('외부 링크를 열 수 없습니다. 잠시 후 다시 시도해주세요.')),
      );
    }
  Future<void> _openExternalLink(BuildContext context, String url) async {
    if (!AppUrls.isValidUrl(url)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('배포 URL 미설정')));
      return;
    }

    final uri = Uri.parse(url);
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
