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

/// 십성 (Ten Gods) 관계
class TenGod {
  final String name; // 비견, 겁재, 식신, 상관, 편재, 정재, 편관, 정관, 편인, 정인
  final String hanja; // 比肩, 劫財, ...
  final String category; // 비겁, 식상, 재성, 관성, 인성
  final String description; // 의미 설명

  const TenGod({
    required this.name,
    required this.hanja,
    required this.category,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'hanja': hanja,
    'category': category,
    'description': description,
  };

  factory TenGod.fromJson(Map<String, dynamic> json) => TenGod(
    name: json['name'] as String,
    hanja: json['hanja'] as String,
    category: json['category'] as String,
    description: json['description'] as String,
  );
}

/// 12운성 (Twelve Stages of Life)
class TwelveStage {
  final String name; // 장생, 목욕, 관대, 건록, 제왕, 쇠, 병, 사, 묘, 절, 태, 양
  final String hanja; // 長生, 沐浴, ...
  final int stageIndex; // 0-11
  final String description;

  const TwelveStage({
    required this.name,
    required this.hanja,
    required this.stageIndex,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'hanja': hanja,
    'stageIndex': stageIndex,
    'description': description,
  };

  factory TwelveStage.fromJson(Map<String, dynamic> json) => TwelveStage(
    name: json['name'] as String,
    hanja: json['hanja'] as String,
    stageIndex: json['stageIndex'] as int,
    description: json['description'] as String,
  );
}

/// 신살 (Spirit Stars)
class SpiritStar {
  final String name; // 천을귀인, 문창귀인, 역마살, ...
  final String hanja;
  final bool isAuspicious; // 길신 / 흉살
  final String description;

  const SpiritStar({
    required this.name,
    required this.hanja,
    required this.isAuspicious,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'hanja': hanja,
    'isAuspicious': isAuspicious,
    'description': description,
  };

  factory SpiritStar.fromJson(Map<String, dynamic> json) => SpiritStar(
    name: json['name'] as String,
    hanja: json['hanja'] as String,
    isAuspicious: json['isAuspicious'] as bool,
    description: json['description'] as String,
  );
}

/// 대운 (Major Life Cycle) - 10년 주기
class MajorCycle {
  final Pillar pillar;
  final int startAge; // 시작 나이
  final int endAge; // 종료 나이
  final String description;

  MajorCycle({
    required this.pillar,
    required this.startAge,
    required this.endAge,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'pillar': pillar.toJson(),
    'startAge': startAge,
    'endAge': endAge,
    'description': description,
  };

  factory MajorCycle.fromJson(Map<String, dynamic> json) => MajorCycle(
    pillar: Pillar.fromJson(json['pillar']),
    startAge: json['startAge'] as int,
    endAge: json['endAge'] as int,
    description: json['description'] as String,
  );
}

/// 사주 계산 결과
class SajuResult {
  final Pillar yearPillar; // 년주
  final Pillar monthPillar; // 월주
  final Pillar dayPillar; // 일주
  final Pillar? hourPillar; // 시주 (optional)
  final Map<String, int> elements; // 오행 분포 (장간 포함)
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

  // Phase 1 신규 필드
  final Map<String, TenGod> tenGods; // 각 기둥 천간별 십성
  final TwelveStage dayTwelveStage; // 일주 12운성
  final List<SpiritStar> spiritStars; // 해당 신살 목록
  final List<MajorCycle> majorCycles; // 대운 목록
  final Map<String, int> hiddenElements; // 장간 포함 오행 세부
  final String dayMasterStrength; // 일간 강약 (신강/신약)

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
    this.tenGods = const {},
    this.dayTwelveStage = const TwelveStage(
      name: '관대',
      hanja: '冠帶',
      stageIndex: 2,
      description: '',
    ),
    this.spiritStars = const [],
    this.majorCycles = const [],
    this.hiddenElements = const {},
    this.dayMasterStrength = '중화',
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
    'tenGods': tenGods.map((k, v) => MapEntry(k, v.toJson())),
    'dayTwelveStage': dayTwelveStage.toJson(),
    'spiritStars': spiritStars.map((s) => s.toJson()).toList(),
    'majorCycles': majorCycles.map((c) => c.toJson()).toList(),
    'hiddenElements': hiddenElements,
    'dayMasterStrength': dayMasterStrength,
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
    tenGods:
        (json['tenGods'] as Map<String, dynamic>?)?.map(
          (k, v) => MapEntry(k, TenGod.fromJson(v)),
        ) ??
        {},
    dayTwelveStage: json['dayTwelveStage'] != null
        ? TwelveStage.fromJson(json['dayTwelveStage'])
        : const TwelveStage(
            name: '관대',
            hanja: '冠帶',
            stageIndex: 2,
            description: '',
          ),
    spiritStars:
        (json['spiritStars'] as List<dynamic>?)
            ?.map((s) => SpiritStar.fromJson(s))
            .toList() ??
        [],
    majorCycles:
        (json['majorCycles'] as List<dynamic>?)
            ?.map((c) => MajorCycle.fromJson(c))
            .toList() ??
        [],
    hiddenElements: Map<String, int>.from(json['hiddenElements'] ?? {}),
    dayMasterStrength: json['dayMasterStrength'] ?? '중화',
  );
}
