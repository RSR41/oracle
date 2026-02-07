import 'package:flutter/foundation.dart';

/// FeatureFlags: 베타 기능 및 AI 기능 제어를 위한 중앙 관리 클래스
///
/// ## MVP 기능 (항상 노출)
/// - 사주 (/fortune-today, /saju-analysis)
/// - 만세력/캘린더 (/calendar)
/// - 타로 (/tarot, /tarot-result)
/// - 꿈해몽 (/dream, /dream-result)
/// - 관상 얼굴분석 (/face, /face-result)
///
/// ## 베타 기능 (showBetaFeatures=true일 때만 노출)
/// - 소개팅 전체 (/meeting, /meeting/*)
/// - 궁합 (/compatibility, /compat-*)
/// - 이상형 이미지 생성 (/ideal-type)
///
/// ## AI 온라인 기능 (aiOnline=true일 때만 활성화)
/// - 사주/타로/꿈해몽/관상 AI 상세 분석
/// - 백엔드 API 호출 (네트워크 연결 필요)
/// - ⚠️ 개인정보 처리 동의 필요
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

  /// 베타 기능 표시 여부
  /// - 릴리스 모드: false (기본값)
  /// - 디버그 모드: true (kDebugMode)
  /// - 명시적 설정: BETA_FEATURES=true/1
  static const bool showBetaFeatures = _betaEnv == ''
      ? kDebugMode
      : (_betaEnv == 'true' || _betaEnv == '1');

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
  /// - ⚠️ 활성화 시 개인정보 처리 동의 UX 필요
  static const bool aiOnline = _aiEnv == 'true' || _aiEnv == '1';

  // ========================================
  // 유틸리티 메서드
  // ========================================

  /// 현재 빌드 모드 이름 반환
  static String get buildModeName {
    if (aiOnline && showBetaFeatures) return 'FULL_DEV';
    if (aiOnline) return 'AI_ENABLED';
    if (showBetaFeatures) return 'BETA_TEST';
    return 'STORE_RELEASE';
  }

  /// 스토어 심사용 안전 모드인지 확인
  static bool get isStoreRelease => !showBetaFeatures && !aiOnline;

  /// AI 기능 사용 가능 여부 (온라인 + 동의 완료)
  /// 실제 동의 상태는 별도 저장소에서 확인해야 함
  static bool get canUseAi => aiOnline;
}
