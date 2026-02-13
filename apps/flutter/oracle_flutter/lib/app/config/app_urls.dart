/// 앱 전역 URL 관리
///
/// ## 법적 페이지 URL
/// - dart-define으로 빌드 시 주입 가능
/// - 주입 없으면 fallback 운영 URL 사용
///
/// ## 사용 예시
/// ```bash
/// flutter build appbundle --release \
///   --dart-define=TERMS_URL=https://oracle-saju.web.app/terms \
///   --dart-define=PRIVACY_URL=https://oracle-saju.web.app/privacy
/// ```
class AppUrls {
  AppUrls._(); // private 생성자 (인스턴스 생성 방지)

  /// 이용약관 URL
  ///
  /// 우선순위:
  /// 1. dart-define으로 주입된 값 (TERMS_URL)
  /// 2. fallback: 운영 URL
  ///
  /// ⚠️ 스토어 제출 전:
  /// - 필요 시 dart-define으로 URL 주입
  static const String termsOfService = String.fromEnvironment(
    'TERMS_URL',
    defaultValue: 'https://oracle-saju.web.app/terms',
  );

  /// 개인정보처리방침 URL
  ///
  /// 우선순위:
  /// 1. dart-define으로 주입된 값 (PRIVACY_URL)
  /// 2. fallback: 운영 URL
  ///
  /// ⚠️ 스토어 제출 전:
  /// - 필요 시 dart-define으로 URL 주입
  static const String privacyPolicy = String.fromEnvironment(
    'PRIVACY_URL',
    defaultValue: 'https://oracle-saju.web.app/privacy',
  );

  /// URL 유효성 검증
  ///
  /// placeholder 또는 유효하지 않은 URL 감지
  /// - example.com 포함 → 유효하지 않음
  /// - oracle-user 포함 → 유효하지 않음 (placeholder)
  /// - https:// 미시작 → 유효하지 않음
  static bool isValidUrl(String url) {
    if (!url.startsWith('https://')) return false;
    if (url.contains('example.com')) return false;
    if (url.contains('oracle-user')) return false; // placeholder 감지
    return Uri.tryParse(url) != null;
  }
}
