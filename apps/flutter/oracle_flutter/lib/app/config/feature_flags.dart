/// FeatureFlags: 베타 기능 및 AI 기능 제어를 위한 중앙 관리 클래스

/// FeatureFlags: 베타 기능 및 AI 기능 제어를 위한 중앙 관리 클래스
///
/// ## MVP (Phase 1) 기능 - 항상 노출
/// - 사주 입력/결과 (/profile)
/// - 만세력/캘린더 (/calendar)
/// - 타로 (/tarot, /tarot-result)
/// - 히스토리 (/history)
/// - 설정 (/settings)
///
/// ## Phase 2+ 기능 (phase2Features=true일 때만 노출)
/// - 꿈해몽 (/dream, /dream-result)
/// - 관상 얼굴분석 (/face, /face-result)
/// - 궁합 (/compatibility, /compat-*)
/// - 이상형 이미지 생성 (/ideal-type)
/// - 신년운세 (/yearly-fortune)
/// - 전문상담 (/consultation)
///
/// ## 소개팅 전용 기능 (meetingEnabled=true일 때만 노출)
/// - 소개팅 전체 (/meeting, /meeting/*)
///
/// ## 빌드 모드
/// | 모드 | BETA_FEATURES | AI_ONLINE | 용도 |
/// |------|---------------|-----------|------|
/// | STORE_RELEASE | false | false | 스토어 심사 제출용 |
/// | BETA_TEST | true | false | 베타 기능 테스트 |
/// | AI_ENABLED | false | true | AI 기능 프로덕션 |
/// | FULL_DEV | true | true | 전체 개발/테스트 |
class FeatureFlags {
  // ========================================
  // 베타 기능 플래그
  // ========================================
  static const String _phase2Env = String.fromEnvironment(
    'PHASE2_FEATURES',
    defaultValue: '',
  );

  // 레거시 빌드 파라미터 호환성 유지
  static const String _betaEnv = String.fromEnvironment(
    'BETA_FEATURES',
    defaultValue: '',
  );

  /// 베타 기능 표시 여부
  /// - Phase 1 스토어 제출을 위해 기본값을 false로 설정
  /// - 명시적으로 BETA_FEATURES=true로 설정해야만 베타 기능 노출
  static const bool phase2Features =
      _phase2Env == 'true' ||
      _phase2Env == '1' ||
      _betaEnv == 'true' ||
      _betaEnv == '1';

  /// 기존 코드 호환용 alias (deprecated)
  static const bool showBetaFeatures = phase2Features;

  static const String _meetingEnv = String.fromEnvironment(
    'MEETING_ENABLED',
    defaultValue: '',
  );

  /// 소개팅 기능 활성화 여부
  /// - 기본값: false
  /// - 활성화: MEETING_ENABLED=true/1
  static const bool meetingEnabled =
      _meetingEnv == 'true' || _meetingEnv == '1';

  /// 소개팅 기능 노출 여부 (phase2 + meeting 전용 플래그 모두 충족)
  static const bool canUseMeeting = phase2Features && meetingEnabled;

  // ========================================
  // AI 온라인 기능 플래그
  // ========================================
  static const String _aiEnv = String.fromEnvironment(
    'AI_ONLINE',
    defaultValue: '',
  );

  /// AI 온라인 기능 활성화 여부
  /// - 기본값: false (오프라인 전용)
  /// - 활성화: AI_ONLINE=true/1
  static const bool aiOnline = _aiEnv == 'true' || _aiEnv == '1';

  // ========================================
  // 유틸리티 메서드
  // ========================================

  /// 현재 빌드 모드 이름 반환
  static String get buildModeName {
    if (aiOnline && phase2Features) return 'FULL_DEV';
    if (aiOnline) return 'AI_ENABLED';
    if (phase2Features) return 'BETA_TEST';
    return 'STORE_RELEASE';
  }

  /// 스토어 심사용 안전 모드인지 확인
  static bool get isStoreRelease => !phase2Features && !aiOnline;

  /// AI 기능 사용 가능 여부
  static bool get canUseAi => aiOnline;
}
