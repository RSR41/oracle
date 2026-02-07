import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../state/app_state.dart';
import '../../navigation/nav_state.dart';
import '../../i18n/translations.dart';
import '../../config/app_urls.dart';

/// 설정 화면
/// - 언어/테마 설정
/// - 법적 링크 (이용약관, 개인정보처리방침)
/// - 오픈소스 라이선스
class SettingsScreen extends StatelessWidget {
  final AppState appState;
  final NavState navState;

  const SettingsScreen({
    super.key,
    required this.appState,
    required this.navState,
  });

  /// 법적 URL을 외부 브라우저로 열기
  Future<void> _launchLegalUrl(
    BuildContext context,
    String url,
    String label,
  ) async {
    // URL 유효성 검증
    if (!AppUrls.isValidUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$label URL이 아직 설정되지 않았습니다.\n스토어 제출 전 실제 URL로 교체가 필요합니다.',
          ),
          duration: const Duration(seconds: 4),
        ),
      );
      return;
    }

    final uri = Uri.parse(url);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw Exception('launchUrl 실패');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label 페이지를 열 수 없습니다: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String t(String key) => appState.t(key);

    return Scaffold(
      appBar: AppBar(
        title: Text(t('settings.title')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            navState.back();
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============ 언어 설정 ============
            Text(
              '언어 (${appState.language.name}):',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SegmentedButton<AppLanguage>(
              segments: const [
                ButtonSegment(value: AppLanguage.ko, label: Text('한국어')),
                ButtonSegment(value: AppLanguage.en, label: Text('English')),
              ],
              selected: {appState.language},
              onSelectionChanged: (set) => appState.setLanguage(set.first),
            ),
            const SizedBox(height: 24),

            // ============ 테마 설정 ============
            Text(
              '테마 (${appState.theme.name}):',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SegmentedButton<AppThemePreference>(
              segments: const [
                ButtonSegment(
                  value: AppThemePreference.light,
                  label: Text('라이트'),
                ),
                ButtonSegment(
                  value: AppThemePreference.dark,
                  label: Text('다크'),
                ),
                ButtonSegment(
                  value: AppThemePreference.system,
                  label: Text('시스템'),
                ),
              ],
              selected: {appState.theme},
              onSelectionChanged: (set) => appState.setTheme(set.first),
            ),
            const SizedBox(height: 32),

            // ============ 법적 링크 섹션 ============
            Text('법적 고지', style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('이용약관'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () =>
                  _launchLegalUrl(context, AppUrls.termsOfService, '이용약관'),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('개인정보처리방침'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () =>
                  _launchLegalUrl(context, AppUrls.privacyPolicy, '개인정보처리방침'),
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('오픈소스 라이선스'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                showLicensePage(
                  context: context,
                  applicationName: 'Oracle',
                  applicationVersion: '1.1.0',
                );
              },
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
