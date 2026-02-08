/// Saju Calculation Models
library;

/// 기둥 (년/월/일/시)
class Pillar {
  final String stem; // 천간 (갑, 을, 병...)
  final String stemHanja; // 천간 한자 (甲, 乙, 丙...)
  final String branch; // 지지 (자, 축, 인...)
  final String branchHanja; // 지지 한자 (子, 丑, 寅...)

  Pillar({
    required this.stem,
    required this.stemHanja,
    required this.branch,
    required this.branchHanja,
  });

  /// 간지 조합 (갑자)
  String get ganji => '$stem$branch';

  /// 간지 한자 조합 (甲子)
  String get ganjiHanja => '$stemHanja$branchHanja';

  Map<String, dynamic> toJson() => {
    'stem': stem,
    'stemHanja': stemHanja,
    'branch': branch,
    'branchHanja': branchHanja,
  };

  factory Pillar.fromJson(Map<String, dynamic> json) => Pillar(
    stem: json['stem'] as String,
    stemHanja: json['stemHanja'] as String,
    branch: json['branch'] as String,
    branchHanja: json['branchHanja'] as String,
  );
}

/// 사주 계산 결과
class SajuResult {
  final Pillar yearPillar; // 년주
  final Pillar monthPillar; // 월주
  final Pillar dayPillar; // 일주
  final Pillar? hourPillar; // 시주 (optional)
  final Map<String, int> elements; // 오행 분포
  final String dominantElement; // 지배 오행
  final String weakestElement; // 부족 오행
  final String zodiac; // 띠 (쥐, 소...)
  final String zodiacHanja; // 띠 한자 (子, 丑...)
  final String dayMaster; // 일간 (일주 천간)
  final String dayMasterElement; // 일간 오행
  final String interpretation; // 해석
  final List<String> luckyColors; // 행운의 색상
  final List<int> luckyNumbers; // 행운의 숫자
  final int overallScore; // 총점 (0-100)

  SajuResult({
    required this.yearPillar,
    required this.monthPillar,
    required this.dayPillar,
    this.hourPillar,
    required this.elements,
    required this.dominantElement,
    required this.weakestElement,
    required this.zodiac,
    required this.zodiacHanja,
    required this.dayMaster,
    required this.dayMasterElement,
    required this.interpretation,
    required this.luckyColors,
    required this.luckyNumbers,
    required this.overallScore,
  });

  /// 사주 팔자 요약 문자열
  String get paljaDisplay {
    final pillars = [yearPillar, monthPillar, dayPillar];
    if (hourPillar != null) pillars.add(hourPillar!);
    return pillars.map((p) => p.ganjiHanja).join(' ');
  }

  Map<String, dynamic> toJson() => {
    'yearPillar': yearPillar.toJson(),
    'monthPillar': monthPillar.toJson(),
    'dayPillar': dayPillar.toJson(),
    'hourPillar': hourPillar?.toJson(),
    'elements': elements,
    'dominantElement': dominantElement,
    'weakestElement': weakestElement,
    'zodiac': zodiac,
    'zodiacHanja': zodiacHanja,
    'dayMaster': dayMaster,
    'dayMasterElement': dayMasterElement,
    'interpretation': interpretation,
    'luckyColors': luckyColors,
    'luckyNumbers': luckyNumbers,
    'overallScore': overallScore,
  };

  factory SajuResult.fromJson(Map<String, dynamic> json) => SajuResult(
    yearPillar: Pillar.fromJson(json['yearPillar']),
    monthPillar: Pillar.fromJson(json['monthPillar']),
    dayPillar: Pillar.fromJson(json['dayPillar']),
    hourPillar: json['hourPillar'] != null
        ? Pillar.fromJson(json['hourPillar'])
        : null,
    elements: Map<String, int>.from(json['elements']),
    dominantElement: json['dominantElement'],
    weakestElement: json['weakestElement'],
    zodiac: json['zodiac'],
    zodiacHanja: json['zodiacHanja'],
    dayMaster: json['dayMaster'],
    dayMasterElement: json['dayMasterElement'],
    interpretation: json['interpretation'],
    luckyColors: List<String>.from(json['luckyColors']),
    luckyNumbers: List<int>.from(json['luckyNumbers']),
    overallScore: json['overallScore'],
  );
}
