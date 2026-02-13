/// 앱 전역 URL 관리
///
/// ## 법적 페이지 URL
/// - dart-define으로 빌드 시 주입 가능
/// - 주입 없으면 fallback URL 사용 (GitHub Pages 기준)
///
/// ## 사용 예시
/// ```bash
/// flutter build appbundle --release \
///   --dart-define=TERMS_URL=https://username.github.io/oracle/legal/terms_of_service \
///   --dart-define=PRIVACY_URL=https://username.github.io/oracle/legal/privacy_policy
/// ```
class AppUrls {
  AppUrls._(); // private 생성자 (인스턴스 생성 방지)

  /// 이용약관 URL
  ///
  /// 우선순위:
  /// 1. dart-define으로 주입된 값 (TERMS_URL)
  /// 2. fallback: GitHub Pages URL (USERNAME 교체 필요)
  ///
  /// ⚠️ 스토어 제출 전:
  /// - dart-define으로 실제 URL 주입, 또는
  /// - 아래 fallback URL의 oracle-user를 실제 GitHub 사용자명으로 교체
  static const String termsOfService = String.fromEnvironment(
    'TERMS_URL',
    defaultValue:
        'https://destiny-saju.github.io/oracle/legal/terms_of_service',
  );

  /// 개인정보처리방침 URL
  ///
  /// 우선순위:
  /// 1. dart-define으로 주입된 값 (PRIVACY_URL)
  /// 2. fallback: GitHub Pages URL (USERNAME 교체 필요)
  ///
  /// ⚠️ 스토어 제출 전:
  /// - dart-define으로 실제 URL 주입, 또는
  /// - 아래 fallback URL의 oracle-user를 실제 GitHub 사용자명으로 교체
  static const String privacyPolicy = String.fromEnvironment(
    'PRIVACY_URL',
    defaultValue:
        'https://destiny-saju.github.io/oracle/legal/privacy_policy',
  );

  /// URL 유효성 검증
  ///
  /// placeholder 또는 유효하지 않은 URL 감지
  /// - example.com 포함 → 유효하지 않음
  /// - YOUR_USERNAME 포함 → 유효하지 않음 (fallback 미교체)
  /// - https:// 미시작 → 유효하지 않음
  static bool isValidUrl(String url) {
    if (!url.startsWith('https://')) return false;
    if (url.contains('example.com')) return false;
    if (url.contains('YOUR_USERNAME')) return false; // fallback 미교체 감지
    if (url.contains('oracle-user.github.io')) return false;
    return Uri.tryParse(url) != null;
  }
}
