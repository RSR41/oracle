/// FeatureFlags: 기능별 플래그 및 AI 기능 제어를 위한 중앙 관리 클래스
class FeatureFlags {
  // ========================================
  // 기능별 플래그
  // ========================================

  /// 미팅 기능은 현재 항상 비활성화합니다.
  static const bool featureMeeting = false;

  static const String _faceEnv = String.fromEnvironment(
    'FEATURE_FACE',
    defaultValue: 'true',
  );
  static const bool featureFace = _faceEnv == 'true' || _faceEnv == '1';

  static const String _dreamEnv = String.fromEnvironment(
    'FEATURE_DREAM',
    defaultValue: 'true',
  );
  static const bool featureDream = _dreamEnv == 'true' || _dreamEnv == '1';

  static const String _compatibilityEnv = String.fromEnvironment(
    'FEATURE_COMPATIBILITY',
    defaultValue: 'true',
  );
  static const bool featureCompatibility =
      _compatibilityEnv == 'true' || _compatibilityEnv == '1';

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

  /// 하위 호환용 베타 플래그 (기능별 플래그 사용 권장)
  static bool get showBetaFeatures =>
      featureMeeting || featureFace || featureDream || featureCompatibility;

  /// 현재 빌드 모드 이름 반환
  static String get buildModeName {
    if (aiOnline && showBetaFeatures) return 'FULL_DEV';
    if (aiOnline) return 'AI_ENABLED';
    if (showBetaFeatures) return 'FEATURE_TEST';
    return 'STORE_RELEASE';
  }

  /// 스토어 심사용 안전 모드인지 확인
  static bool get isStoreRelease => !showBetaFeatures && !aiOnline;

  /// AI 기능 사용 가능 여부
  static bool get canUseAi => aiOnline;
}
