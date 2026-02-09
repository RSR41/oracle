import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../navigation/nav_state.dart';
import '../../i18n/translations.dart';
import '../../database/history_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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

  /// 법적 고지 내용을 다이얼로그로 표시
  void _showLegalDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Text(
              content,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }

  // 임시 약관 텍스트 (명세서 v6 부재로 인한 대체)
  static const String _termsText = '''
제1조 (목적)
본 약관은 Oracle 서비스(이하 "서비스")를 이용함에 있어 회사의 권리, 의무 및 책임사항을 규정함을 목적으로 합니다.

제2조 (용어의 정의)
1. "회원"이란 서비스에 접속하여 본 약관에 따라 이용계약을 체결하고 이용하는 고객을 말합니다.
2. "운세 데이터"란 생년월일시를 기반으로 산출된 사주, 타로 등의 결과를 의미합니다.

제3조 (서비스의 제공)
회사는 다음과 같은 서비스를 제공합니다.
1. 사주/운세 분석 서비스
2. 타로 카드 리딩 서비스
3. 기타 회사가 개발하거나 제휴를 통해 제공하는 일체의 서비스

* 본 내용은 예시이며, 실제 배포 시 명세서 v6에 따른 내용으로 교체가 필요합니다.
''';

  static const String _privacyText = '''
1. 개인정보 처리방침의 의의
Oracle은 정보통신망법, 개인정보보호법 등 관련 법령을 준수합니다.

2. 수집하는 개인정보의 항목
회사는 회원가입, 원활한 고객상담, 각종 서비스 제공을 위해 아래와 같은 개인정보를 수집하고 있습니다.
- 필수항목: 생년월일, 태어난 시간, 성별, 닉네임
- 선택항목: 관심사

3. 개인정보의 보유 및 이용기간
회사는 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집 시에 동의받은 개인정보 보유·이용기간 내에서 개인정보를 처리·보유합니다.

* 본 내용은 예시이며, 실제 배포 시 명세서 v6에 따른 내용으로 교체가 필요합니다.
''';

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
              onTap: () => _showLegalDialog(context, '이용약관', _termsText),
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('개인정보처리방침'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showLegalDialog(context, '개인정보처리방침', _privacyText),
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
