/// 설정 화면 구현은 stack/settings_screen.dart 를 단일 소스로 사용합니다.
///
/// 기존 import 경로 호환을 위해 tabs 경로에서는 동일 구현을 재-export 합니다.
export 'package:oracle_flutter/app/screens/stack/settings_screen.dart';
import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../navigation/nav_state.dart';
import '../../i18n/translations.dart';
import '../../database/history_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../config/app_urls.dart';
import 'package:url_launcher/url_launcher.dart';

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

  // Delete Account
  Future<void> _handleDeleteAccount(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('계정/데이터 삭제'),
        content: const Text(
          '모든 사주 데이터와 프로필 정보가 영구적으로 삭제됩니다.\n이 작업은 되돌릴 수 없습니다.\n정말 삭제하시겠습니까?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );

    if (confirm == true && context.mounted) {
      try {
        // Clear all history
        final historyRepo = HistoryRepository();
        await historyRepo.clearAll();

        // Clear AppState (Profile & Settings default)
        final appState = Provider.of<AppState>(context, listen: false);
        await appState.clearProfile();

        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('모든 데이터가 삭제되었습니다.')));
          // Navigate to Welcome
          context.go('/welcome');
        }
      } catch (e) {
        debugPrint('Error deleting account: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('오류가 발생했습니다. 다시 시도해주세요.')),
          );
        }
      }
    }
  }

  Future<void> _openLegalUrl(
    BuildContext context,
    String label,
    String url,
  ) async {
    if (!AppUrls.isValidUrl(url)) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label URL이 올바르지 않습니다.')),
        );
      }
      return;
    }

    final uri = Uri.parse(url);
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$label 페이지를 열 수 없습니다.')),
      );
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

            // ============ 계정 관리 ============
            const Text('계정 관리', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.person_off, color: Colors.redAccent),
              title: const Text(
                '회원 탈퇴 / 데이터 초기화',
                style: TextStyle(color: Colors.redAccent),
              ),
              subtitle: const Text('기기에 저장된 모든 정보를 삭제합니다'),
              onTap: () => _handleDeleteAccount(context),
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
              onTap: () => _openLegalUrl(context, '이용약관', AppUrls.termsOfService),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('개인정보처리방침'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () => _openLegalUrl(context, '개인정보처리방침', AppUrls.privacyPolicy),
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
/// 기존 탭 설정 화면은 스택 설정 화면으로 통합되었습니다.
/// import 호환성을 위해 스택 설정 화면을 re-export 합니다.
export '../stack/settings_screen.dart';
