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
/// ## Phase 2+ 기능 (기능별 플래그로 노출 제어)
/// - 꿈해몽 (/dream, /dream-result)
/// - 관상 얼굴분석 (/face, /face-result)
/// - 소개팅 전체 (/meeting, /meeting/*)
/// - 궁합 (/compatibility, /compat-*)
/// - 이상형 이미지 생성 (/ideal-type)
/// - 신년운세 (/yearly-fortune)
/// - 전문상담 (/consultation)
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
  static const String _betaEnv = String.fromEnvironment(
    'BETA_FEATURES',
    defaultValue: '',
  );

  /// 전체 베타 기본값
  /// - 기존 BETA_FEATURES 동작과의 하위 호환용
  static const bool _betaDefault = _betaEnv == 'true' || _betaEnv == '1';

  static const String _faceEnv = String.fromEnvironment(
    'ENABLE_FACE',
    defaultValue: _betaEnv,
  );

  static const String _dreamEnv = String.fromEnvironment(
    'ENABLE_DREAM',
    defaultValue: _betaEnv,
  );

  static const String _compatibilityEnv = String.fromEnvironment(
    'ENABLE_COMPATIBILITY',
    defaultValue: _betaEnv,
  );

  static const String _meetingEnv = String.fromEnvironment(
    'ENABLE_MEETING',
    defaultValue: '',
  );

  /// 관상 기능 노출 여부
  static const bool enableFace = _faceEnv == 'true' || _faceEnv == '1';

  /// 꿈해몽 기능 노출 여부
  static const bool enableDream = _dreamEnv == 'true' || _dreamEnv == '1';

  /// 궁합 기능 노출 여부
  static const bool enableCompatibility =
      _compatibilityEnv == 'true' || _compatibilityEnv == '1';

  /// 소개팅 기능 노출 여부 (기본 false)
  static const bool enableMeeting = _meetingEnv == 'true' || _meetingEnv == '1';

  /// Phase2+ 기능 표시 여부 (하위 호환)
  static const bool showBetaFeatures =
      enableFace || enableDream || enableCompatibility || enableMeeting;

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
    if (aiOnline && showBetaFeatures) return 'FULL_DEV';
    if (aiOnline) return 'AI_ENABLED';
    if (_betaDefault || showBetaFeatures) return 'BETA_TEST';
    return 'STORE_RELEASE';
  }

  /// 스토어 심사용 안전 모드인지 확인
  static bool get isStoreRelease => !showBetaFeatures && !aiOnline;

  /// AI 기능 사용 가능 여부
  static bool get canUseAi => aiOnline;
}
