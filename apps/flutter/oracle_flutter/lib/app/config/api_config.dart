/// API 설정 관리
///
/// 백엔드 API URL 및 관련 설정을 중앙 관리합니다.
///
/// ## 빌드 프로파일
/// - STORE: 스토어 심사용 (기본: API 비활성)
/// - PHASE2: AI 온라인 기능 검증용
///
/// ## 사용 예시
/// ```bash
/// # STORE 릴리스 (API 비활성)
/// flutter build appbundle --release \
///   --dart-define=API_PROFILE=STORE
///
/// # PHASE2 릴리스 (무료 백엔드 연결)
/// flutter build appbundle --release \
///   --dart-define=API_PROFILE=PHASE2 \
///   --dart-define=API_BASE_URL=https://<your-free-postgres-backed-api>
/// ```
class ApiConfig {
  ApiConfig._();

  /// API 프로파일
  /// - STORE: 기본값 없음(오프라인)
  /// - PHASE2: API_BASE_URL을 반드시 dart-define으로 주입
  static const String profile = String.fromEnvironment(
    'API_PROFILE',
    defaultValue: 'STORE',
  );

  static const String _baseUrlOverride = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  /// API 기본 URL
  ///
  /// 우선순위:
  /// 1. dart-define으로 주입된 API_BASE_URL
  /// 2. API_PROFILE별 기본값
  static String get baseUrl {
    if (_baseUrlOverride.isNotEmpty) return _baseUrlOverride;

    switch (profile) {
      case 'PHASE2':
        return '';
      case 'STORE':
      default:
        return '';
    }
  }

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

  static String get sajuSummaryUrl => '$baseUrl/ai/saju-summary';
  static String get tarotReadingUrl => '$baseUrl/ai/tarot-reading';
  static String get dreamMeaningUrl => '$baseUrl/ai/dream-meaning';
  static String get faceReadingUrl => '$baseUrl/ai/face-reading';
}
