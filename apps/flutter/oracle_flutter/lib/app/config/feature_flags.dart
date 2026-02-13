/// FeatureFlags: 베타 기능 및 AI 기능 제어를 위한 중앙 관리 클래스

import 'package:flutter/foundation.dart';

enum SubmissionProfile { storeRelease, storePlus, fullDev }

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
/// ## Phase 2+ 기능
/// - 저위험(Local-only) 기능: 소개팅(/meeting), 궁합(/compatibility)
/// - 민감/확장 기능: 꿈해몽(/dream), 관상(/face), 이상형(/ideal-type),
///   신년운세(/yearly-fortune), 전문상담(/consultation)
///
/// ## 소개팅 전용 기능 (meetingEnabled=true일 때만 노출)
/// - 소개팅 전체 (/meeting, /meeting/*)
///
/// ## 빌드 모드
/// | 모드 | BETA_FEATURES | AI_ONLINE | 용도 |
/// |------|---------------|-----------|------|
/// | STORE_RELEASE | false | false | 스토어 심사 제출용 |
/// | PHASE2_PREVIEW(가칭) | true | false | 심사 대응용 제한적 Phase 2 노출 |
/// | BETA_TEST | true | false | 베타 기능 테스트 |
/// | AI_ENABLED | false | true | AI 기능 프로덕션 |
/// | FULL_DEV | true | true | 전체 개발/테스트 |
///
/// ## 제출 프로파일 고정 규칙
/// - STORE_RELEASE: 반드시 BETA_FEATURES=false, AI_ONLINE=false
/// - PHASE2_PREVIEW(가칭): AI는 비활성 유지(AI_ONLINE=false),
///   기능 노출은 라우팅/화면 단에서 제출 대상만 선별 오픈
/// ## 제출 프로파일 (심사/배포 기준)
/// | 프로파일 | BETA_FEATURES | AI_ONLINE | 용도 |
/// |----------|---------------|-----------|------|
/// | STORE_RELEASE | false | false | 스토어 심사 제출 기본 |
/// | STORE_PLUS | true | false | Phase 2 중 저위험 기능만 선택 공개 |
/// | FULL_DEV | true | true | 내부 개발/통합 테스트 |
class FeatureFlags {
  // ========================================
  // 원시 환경변수
  // ========================================
  static const String _phase2Env = String.fromEnvironment(
    'PHASE2_FEATURES',
    defaultValue: '',
  );

  // 레거시 빌드 파라미터 호환성 유지
  static const String _profileEnv = String.fromEnvironment(
    'SUBMISSION_PROFILE',
    defaultValue: '',
  );

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

  /// 베타 기능 표시 여부 (기존 호환)
  static const bool showBetaFeatures = _betaEnv == 'true' || _betaEnv == '1';

  /// AI 온라인 기능 활성화 여부
  static const bool aiOnline = _aiEnv == 'true' || _aiEnv == '1';

  static bool _didPrintDiagnostics = false;

  static SubmissionProfile get submissionProfile {
    switch (_profileEnv.toUpperCase()) {
      case 'FULL_DEV':
        return SubmissionProfile.fullDev;
      case 'STORE_PLUS':
        return SubmissionProfile.storePlus;
      case 'STORE_RELEASE':
        return SubmissionProfile.storeRelease;
      default:
        // 레거시 빌드 플래그 fallback
        if (aiOnline && showBetaFeatures) return SubmissionProfile.fullDev;
        if (showBetaFeatures) return SubmissionProfile.storePlus;
        return SubmissionProfile.storeRelease;
    }
  }

  /// 현재 프로파일명(대문자) 반환
  static String get buildModeName {
    if (aiOnline && phase2Features) return 'FULL_DEV';
    if (aiOnline) return 'AI_ENABLED';
    if (phase2Features) return 'BETA_TEST';
    return 'STORE_RELEASE';
  }

  /// 스토어 심사용 안전 모드인지 확인
  static bool get isStoreRelease => !phase2Features && !aiOnline;
    switch (submissionProfile) {
      case SubmissionProfile.storeRelease:
        return 'STORE_RELEASE';
      case SubmissionProfile.storePlus:
        return 'STORE_PLUS';
      case SubmissionProfile.fullDev:
        return 'FULL_DEV';
    }
  }

  /// 스토어 심사용 안전 모드인지 확인
  static bool get isStoreRelease => submissionProfile == SubmissionProfile.storeRelease;

  /// Phase 2 중 권한/정책 리스크가 낮은 기능 공개 가능 여부
  static bool get allowPhase2LowRisk => submissionProfile != SubmissionProfile.storeRelease;

  /// Phase 2 전체(민감/확장 포함) 기능 공개 가능 여부
  static bool get allowPhase2Sensitive => submissionProfile == SubmissionProfile.fullDev;

  /// AI 기능 사용 가능 여부
  static bool get canUseAi => aiOnline && submissionProfile == SubmissionProfile.fullDev;

  /// 심사용 제출 시 활성 기능 목록 확인을 위한 진단 로그
  static void printSubmissionDiagnostics() {
    if (_didPrintDiagnostics) return;
    _didPrintDiagnostics = true;

    final enabledFeatures = <String>[
      'PHASE1_CORE',
      if (allowPhase2LowRisk) 'PHASE2_LOW_RISK(meeting,compatibility)',
      if (allowPhase2Sensitive) 'PHASE2_SENSITIVE(dream,face,ideal-type,consultation,yearly-fortune)',
      if (canUseAi) 'AI_ONLINE',
    ];

    debugPrint(
      '[ReleaseProfile] profile=$buildModeName '
      '(SUBMISSION_PROFILE=${_profileEnv.isEmpty ? 'auto' : _profileEnv}, '
      'BETA_FEATURES=${showBetaFeatures ? 'true' : 'false'}, '
      'AI_ONLINE=${aiOnline ? 'true' : 'false'})',
    );
    debugPrint('[ReleaseProfile] enabled=${enabledFeatures.join(', ')}');
  }
}
