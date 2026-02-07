/// API 설정 관리
///
/// 백엔드 API URL 및 관련 설정을 중앙 관리합니다.
///
/// ## 사용법
/// ```bash
/// # 개발 서버
/// flutter run --dart-define=API_BASE_URL=http://localhost:8080
///
/// # 프로덕션 서버
/// flutter build appbundle --release \
///   --dart-define=API_BASE_URL=https://api.oracle-saju.com
/// ```
class ApiConfig {
  ApiConfig._();

  /// API 기본 URL
  ///
  /// 우선순위:
  /// 1. dart-define으로 주입된 값 (API_BASE_URL)
  /// 2. 기본값: 빈 문자열 (AI 기능 비활성화)
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '', // AI_ONLINE=false 시 사용되지 않음
  );

  /// API 타임아웃 (밀리초)
  static const int timeoutMs = int.fromEnvironment(
    'API_TIMEOUT_MS',
    defaultValue: 30000,
  );

  /// API 사용 가능 여부
  static bool get isConfigured => baseUrl.isNotEmpty;

  // ========================================
  // AI 엔드포인트
  // ========================================

  /// 사주 요약 API
  static String get sajuSummaryUrl => '$baseUrl/ai/saju-summary';

  /// 타로 해석 API
  static String get tarotReadingUrl => '$baseUrl/ai/tarot-reading';

  /// 꿈 해석 API
  static String get dreamMeaningUrl => '$baseUrl/ai/dream-meaning';

  /// 관상 분석 API
  static String get faceReadingUrl => '$baseUrl/ai/face-reading';
}
