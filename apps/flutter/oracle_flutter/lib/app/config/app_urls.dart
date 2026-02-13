/// 앱 전역 URL 관리
///
/// 법적 고지는 외부 URL 열기 방식으로 단일화한다.
class AppUrls {
  AppUrls._();

  /// 이용약관 URL
  static const String termsOfService = String.fromEnvironment(
    'TERMS_URL',
    defaultValue: 'https://oracle-saju.github.io/oracle/legal/terms_of_service',
  );

  /// 개인정보처리방침 URL
  static const String privacyPolicy = String.fromEnvironment(
    'PRIVACY_URL',
    defaultValue: 'https://oracle-saju.github.io/oracle/legal/privacy_policy',
  );

  /// URL 유효성 검증
  static bool isValidUrl(String url) {
    if (!url.startsWith('https://')) return false;
    if (url.contains('example.com')) return false;
    if (url.contains('YOUR_USERNAME')) return false;
    if (url.contains('oracle-user.github.io')) return false;
    return Uri.tryParse(url) != null;
  }
}
