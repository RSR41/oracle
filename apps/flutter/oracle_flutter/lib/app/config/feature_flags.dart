import 'package:flutter/foundation.dart';

/// Centralized feature flags.
class FeatureFlags {
  static const String _betaEnv = String.fromEnvironment('BETA_FEATURES', defaultValue: 'false');
  static const String _aiEnv = String.fromEnvironment('AI_ONLINE', defaultValue: 'false');

  static const String _dreamEnv = String.fromEnvironment('ENABLE_DREAM', defaultValue: '');
  static const String _compatEnv = String.fromEnvironment('ENABLE_COMPATIBILITY', defaultValue: '');
  static const String _meetingEnv = String.fromEnvironment('ENABLE_MEETING', defaultValue: 'false');

  static const String _legacyDreamEnv = String.fromEnvironment('FEATURE_DREAM', defaultValue: '');
  static const String _legacyCompatEnv = String.fromEnvironment('FEATURE_COMPATIBILITY', defaultValue: '');

  static bool _asBool(String v, {bool fallback = false}) {
    if (v.isEmpty) return fallback;
    final normalized = v.toLowerCase();
    return normalized == '1' || normalized == 'true' || normalized == 'yes' || normalized == 'on';
  }

  static bool get phase2Features => _asBool(_betaEnv, fallback: false);
  static bool get showBetaFeatures => phase2Features;
  static bool get aiOnline => _asBool(_aiEnv, fallback: false);

  static bool get featureMeeting => false;

  static bool get featureDream {
    if (_legacyDreamEnv.isNotEmpty) return _asBool(_legacyDreamEnv);
    return phase2Features;
  }

  static bool get featureCompatibility {
    if (_legacyCompatEnv.isNotEmpty) return _asBool(_legacyCompatEnv);
    return phase2Features;
  }

  static bool get enableDream {
    if (_dreamEnv.isNotEmpty) return _asBool(_dreamEnv);
    return featureDream;
  }

  static bool get enableCompatibility {
    if (_compatEnv.isNotEmpty) return _asBool(_compatEnv);
    return featureCompatibility;
  }

  static bool get enableMeeting => _asBool(_meetingEnv, fallback: false);
  static bool get canUseMeeting => phase2Features && enableMeeting;

  static void printSubmissionDiagnostics() {
    debugPrint('[FeatureFlags] phase2=$phase2Features ai=$aiOnline dream=$enableDream compat=$enableCompatibility meeting=$enableMeeting');
  }
}
