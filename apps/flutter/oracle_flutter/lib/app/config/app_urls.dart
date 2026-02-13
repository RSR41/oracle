/// 앱 전역 URL 관리
///
/// 법적 고지는 외부 URL 열기 방식으로 단일화한다.
/// ## 법적 페이지 URL
/// - dart-define으로 빌드 시 주입 가능
/// - 주입 없으면 fallback 운영 URL 사용
/// - 주입이 없으면 기본 배포 URL 사용
///
/// ## 사용 예시
/// ```bash
/// flutter build appbundle --release \
///   --dart-define=TERMS_URL=https://destiny-saju.github.io/oracle/legal/terms_of_service \
///   --dart-define=PRIVACY_URL=https://destiny-saju.github.io/oracle/legal/privacy_policy
///   --dart-define=TERMS_URL=https://oracle-saju.web.app/terms \
///   --dart-define=PRIVACY_URL=https://oracle-saju.web.app/privacy
/// ```
///
/// 릴리즈 빌드에서는 위 `--dart-define` 값을 CI/CD 또는 빌드 스크립트에서
/// 주입해 운영 URL을 고정하세요.
class AppUrls {
  AppUrls._();

  /// 이용약관 URL
  static const String termsOfService = String.fromEnvironment(
    'TERMS_URL',
  ///
  /// 우선순위:
  /// 1. dart-define으로 주입된 값 (TERMS_URL)
  /// 2. fallback: 운영 GitHub Pages URL
  static const String termsOfService = String.fromEnvironment(
    'TERMS_URL',
    defaultValue: 'https://destiny-saju.github.io/oracle/legal/terms_of_service',
  /// 2. fallback: 운영 URL
  ///
  /// ⚠️ 스토어 제출 전:
  /// - 필요 시 dart-define으로 URL 주입
  static const String termsOfService = String.fromEnvironment(
    'TERMS_URL',
    defaultValue: 'https://oracle-saju.web.app/terms',
  /// 2. fallback: 기본 배포 URL
  static const String termsOfService = String.fromEnvironment(
    'TERMS_URL',
    defaultValue: 'https://oracle-saju.web.app/terms',
  /// 2. fallback: 확정된 GitHub Pages URL
  ///
  /// ⚠️ 스토어 제출 전 필수:
  /// - dart-define으로 실제 URL 주입, 또는
  /// - 아래 fallback URL의 destiny-saju를 실제 GitHub 사용자명으로 교체
  static const String termsOfService = String.fromEnvironment(
    'TERMS_URL',
    // TODO(DEPLOY): GitHub Pages 배포 후 destiny-saju를 실제 사용자명으로 교체
    defaultValue: 'https://destiny-saju.github.io/oracle/legal/terms_of_service',
  /// - 아래 fallback URL의 oracle-user를 실제 도메인으로 교체
  static const String termsOfService = String.fromEnvironment(
    'TERMS_URL',
    defaultValue:
        'https://destiny-saju.github.io/oracle/legal/terms_of_service',
    // 확정된 GitHub Pages URL
    defaultValue: 'https://oracle-saju.github.io/oracle/legal/terms_of_service',
  );

  /// 개인정보처리방침 URL
  static const String privacyPolicy = String.fromEnvironment(
    'PRIVACY_URL',
  ///
  /// 우선순위:
  /// 1. dart-define으로 주입된 값 (PRIVACY_URL)
  /// 2. fallback: 운영 GitHub Pages URL
  static const String privacyPolicy = String.fromEnvironment(
    'PRIVACY_URL',
    defaultValue: 'https://destiny-saju.github.io/oracle/legal/privacy_policy',
  /// 2. fallback: 운영 URL
  ///
  /// ⚠️ 스토어 제출 전:
  /// - 필요 시 dart-define으로 URL 주입
  static const String privacyPolicy = String.fromEnvironment(
    'PRIVACY_URL',
    defaultValue: 'https://oracle-saju.web.app/privacy',
  /// 2. fallback: 기본 배포 URL
  static const String privacyPolicy = String.fromEnvironment(
    'PRIVACY_URL',
    defaultValue: 'https://oracle-saju.web.app/privacy',
  /// 2. fallback: 확정된 GitHub Pages URL
  ///
  /// ⚠️ 스토어 제출 전 필수:
  /// - dart-define으로 실제 URL 주입, 또는
  /// - 아래 fallback URL의 destiny-saju를 실제 GitHub 사용자명으로 교체
  static const String privacyPolicy = String.fromEnvironment(
    'PRIVACY_URL',
    // TODO(DEPLOY): GitHub Pages 배포 후 destiny-saju를 실제 사용자명으로 교체
    defaultValue: 'https://destiny-saju.github.io/oracle/legal/privacy_policy',
  /// - 아래 fallback URL의 oracle-user를 실제 도메인으로 교체
  static const String privacyPolicy = String.fromEnvironment(
    'PRIVACY_URL',
    defaultValue:
        'https://destiny-saju.github.io/oracle/legal/privacy_policy',
    // 확정된 GitHub Pages URL
    defaultValue: 'https://oracle-saju.github.io/oracle/legal/privacy_policy',
  );

  /// URL 유효성 검증
  static bool isValidUrl(String url) {
    if (!url.startsWith('https://')) return false;
    if (url.contains('example.com')) return false;
    if (url.contains('YOUR_USERNAME')) return false;
    if (url.contains('oracle-user.github.io')) return false;
  ///
  /// placeholder 또는 유효하지 않은 URL 감지
  /// - example.com 포함 → 유효하지 않음
  /// - oracle-user 포함 → 유효하지 않음 (placeholder)
  /// - YOUR_USERNAME 포함 → 유효하지 않음 (fallback 미교체)
  /// - oracle-user.github.io 포함 → 유효하지 않음 (fallback 미교체)
  /// - https:// 미시작 → 유효하지 않음
  static bool isValidUrl(String url) {
    if (!url.startsWith('https://')) return false;
    if (url.contains('example.com')) return false;
    if (url.contains('oracle-user')) return false; // placeholder fallback 감지
    if (url.contains('oracle-user')) return false; // placeholder 감지
    if (url.contains('YOUR_USERNAME')) return false; // fallback 미교체 감지
    if (url.contains('oracle-user.github.io')) return false;
    if (url.contains('oracle-user.github.io')) return false; // fallback 미교체 감지
    return Uri.tryParse(url) != null;
  }
}
