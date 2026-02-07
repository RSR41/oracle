import 'dart:math';

/// Result of face reading analysis
class FaceReadingResult {
  final String overview;
  final String overviewKo;
  final Map<String, String> features;
  final Map<String, String> featuresKo;
  final String advice;
  final String adviceKo;
  final int compatibilityScore;

  FaceReadingResult({
    required this.overview,
    required this.overviewKo,
    required this.features,
    required this.featuresKo,
    required this.advice,
    required this.adviceKo,
    required this.compatibilityScore,
  });

  Map<String, dynamic> toJson() => {
    'overview': overview,
    'overviewKo': overviewKo,
    'features': features,
    'featuresKo': featuresKo,
    'advice': advice,
    'adviceKo': adviceKo,
    'compatibilityScore': compatibilityScore,
  };

  factory FaceReadingResult.fromJson(Map<String, dynamic> json) =>
      FaceReadingResult(
        overview: json['overview'] as String,
        overviewKo: json['overviewKo'] as String,
        features: Map<String, String>.from(json['features']),
        featuresKo: Map<String, String>.from(json['featuresKo']),
        advice: json['advice'] as String,
        adviceKo: json['adviceKo'] as String,
        compatibilityScore: json['compatibilityScore'] as int,
      );
}

/// Interface for face reading analysis services
abstract class FaceAnalyzer {
  Future<FaceReadingResult> analyze(String imagePath);
}

/// Mock implementation of FaceAnalyzer for MVP
class MockFaceAnalyzer implements FaceAnalyzer {
  final _random = Random();

  static const _overviews = [
    'Your facial features indicate strong leadership qualities and natural charisma.',
    'Your face shows signs of artistic sensitivity and emotional depth.',
    'Your features suggest a balanced personality with practical wisdom.',
    'Your face indicates high intelligence and analytical thinking.',
  ];

  static const _overviewsKo = [
    '관상으로 보아 강한 리더십과 타고난 카리스마가 있습니다.',
    '얼굴에서 예술적 감수성과 감정적 깊이가 느껴집니다.',
    '균형 잡힌 성격과 실용적인 지혜가 엿보입니다.',
    '높은 지능과 분석적 사고력이 드러납니다.',
  ];

  static const _featureLabels = ['이마', '눈', '코', '입', '턱'];
  static const _featureLabelsEn = ['Forehead', 'Eyes', 'Nose', 'Mouth', 'Chin'];

  static const _meanings = [
    ['지도력', '창의력', '분석력', '지혜'],
    ['통찰력', '감수성', '직관', '공감'],
    ['재물운', '건강운', '자존심', '결단력'],
    ['표현력', '인복', '사교성', '애정운'],
    ['의지력', '끈기', '안정성', '실행력'],
  ];

  static const _advices = [
    'Trust your instincts in important decisions.',
    'Focus on building meaningful relationships this year.',
    'Your creative energy is at its peak - use it wisely.',
    'Health and balance should be your priority.',
  ];

  static const _advicesKo = [
    '중요한 결정에서 직감을 믿으세요.',
    '올해는 의미 있는 관계를 구축하는 데 집중하세요.',
    '창의적 에너지가 최고조입니다 - 현명하게 활용하세요.',
    '건강과 균형이 우선시되어야 합니다.',
  ];

  @override
  Future<FaceReadingResult> analyze(String imagePath) async {
    // Simulate analysis delay
    await Future.delayed(const Duration(seconds: 2));

    final overviewIndex = _random.nextInt(_overviews.length);
    final adviceIndex = _random.nextInt(_advices.length);

    final features = <String, String>{};
    final featuresKo = <String, String>{};

    for (int i = 0; i < _featureLabels.length; i++) {
      final meaningIndex = _random.nextInt(_meanings[i].length);
      featuresKo[_featureLabels[i]] = _meanings[i][meaningIndex];
      features[_featureLabelsEn[i]] = _meanings[i][meaningIndex];
    }

    return FaceReadingResult(
      overview: _overviews[overviewIndex],
      overviewKo: _overviewsKo[overviewIndex],
      features: features,
      featuresKo: featuresKo,
      advice: _advices[adviceIndex],
      adviceKo: _advicesKo[adviceIndex],
      compatibilityScore: 60 + _random.nextInt(40),
    );
  }
}
