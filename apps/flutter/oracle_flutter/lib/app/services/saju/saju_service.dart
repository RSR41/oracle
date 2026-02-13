/// Saju Calculation Service
/// Ported from Android BasicFortuneEngine.kt for Phase 1 (local-only, no AI)
library;

import 'saju_models.dart';

class SajuService {
  // 천간 (10개) - Heavenly Stems
  static const List<String> heavenlyStems = [
    '갑',
    '을',
    '병',
    '정',
    '무',
    '기',
    '경',
    '신',
    '임',
    '계',
  ];

  // 천간 한자
  static const List<String> heavenlyStemsHanja = [
    '甲',
    '乙',
    '丙',
    '丁',
    '戊',
    '己',
    '庚',
    '辛',
    '壬',
    '癸',
  ];

  // 지지 (12개) - Earthly Branches
  static const List<String> earthlyBranches = [
    '자',
    '축',
    '인',
    '묘',
    '진',
    '사',
    '오',
    '미',
    '신',
    '유',
    '술',
    '해',
  ];

  // 지지 한자
  static const List<String> earthlyBranchesHanja = [
    '子',
    '丑',
    '寅',
    '卯',
    '辰',
    '巳',
    '午',
    '未',
    '申',
    '酉',
    '戌',
    '亥',
  ];

  // 지지 띠
  static const List<String> zodiacAnimals = [
    '쥐',
    '소',
    '호랑이',
    '토끼',
    '용',
    '뱀',
    '말',
    '양',
    '원숭이',
    '닭',
    '개',
    '돼지',
  ];

  // 오행 매핑
  static const Map<String, String> stemToElement = {
    '갑': '목',
    '을': '목',
    '병': '화',
    '정': '화',
    '무': '토',
    '기': '토',
    '경': '금',
    '신': '금',
    '임': '수',
    '계': '수',
  };

  // 오행 한자
  static const Map<String, String> elementHanja = {
    '목': '木',
    '화': '火',
    '토': '土',
    '금': '金',
    '수': '水',
  };

  // 오행 색상
  static const Map<String, List<String>> elementColors = {
    '목': ['#228B22', '#90EE90'], // 녹색
    '화': ['#FF4500', '#FF6347'], // 빨강
    '토': ['#D2691E', '#DEB887'], // 황토
    '금': ['#FFD700', '#C0C0C0'], // 금/은
    '수': ['#000080', '#4169E1'], // 파랑
  };

  /// 생년월일시로 사주 팔자 계산
  SajuResult calculate({
    required DateTime birthDate,
    String? birthTime,
    String? gender,
  }) {
    final year = birthDate.year;
    final month = birthDate.month;
    final day = birthDate.day;

    // 년주 계산
    final yearStemIndex = (year - 4) % 10;
    final yearBranchIndex = (year - 4) % 12;
    final yearPillar = Pillar(
      stem:
          heavenlyStems[yearStemIndex < 0 ? yearStemIndex + 10 : yearStemIndex],
      stemHanja:
          heavenlyStemsHanja[yearStemIndex < 0
              ? yearStemIndex + 10
              : yearStemIndex],
      branch:
          earthlyBranches[yearBranchIndex < 0
              ? yearBranchIndex + 12
              : yearBranchIndex],
      branchHanja:
          earthlyBranchesHanja[yearBranchIndex < 0
              ? yearBranchIndex + 12
              : yearBranchIndex],
    );

    // 월주 계산 (간략화)
    final monthStemIndex = ((year % 10) * 2 + month) % 10;
    final monthBranchIndex = (month + 1) % 12;
    final monthPillar = Pillar(
      stem: heavenlyStems[monthStemIndex],
      stemHanja: heavenlyStemsHanja[monthStemIndex],
      branch: earthlyBranches[monthBranchIndex],
      branchHanja: earthlyBranchesHanja[monthBranchIndex],
    );

    // 일주 계산 (간략화 - 실제로는 만세력 필요)
    final dayStemIndex = (year + month + day) % 10;
    final dayBranchIndex = (year + month + day) % 12;
    final dayPillar = Pillar(
      stem: heavenlyStems[dayStemIndex],
      stemHanja: heavenlyStemsHanja[dayStemIndex],
      branch: earthlyBranches[dayBranchIndex],
      branchHanja: earthlyBranchesHanja[dayBranchIndex],
    );

    // 시주 계산 (선택적)
    Pillar? hourPillar;
    if (birthTime != null && birthTime.isNotEmpty) {
      final parts = birthTime.split(':');
      if (parts.length >= 2) {
        final hour = int.tryParse(parts[0]) ?? 0;
        final hourIndex = hour ~/ 2;
        final hourStemIndex = (dayStemIndex * 2 + hourIndex) % 10;
        hourPillar = Pillar(
          stem: heavenlyStems[hourStemIndex],
          stemHanja: heavenlyStemsHanja[hourStemIndex],
          branch: earthlyBranches[hourIndex % 12],
          branchHanja: earthlyBranchesHanja[hourIndex % 12],
        );
      }
    }

    // 오행 계산
    final elements = _calculateElements(
      yearPillar,
      monthPillar,
      dayPillar,
      hourPillar,
    );

    // 일간 (일주 천간) 기준 해석
    final dayMaster = dayPillar.stem;
    final dayMasterElement = stemToElement[dayMaster] ?? '토';

    // 지배 오행 / 부족 오행
    final dominantElement = elements.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    final weakestElement = elements.entries
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;

    // 띠
    final zodiac =
        zodiacAnimals[yearBranchIndex < 0
            ? yearBranchIndex + 12
            : yearBranchIndex];

    // 해석 생성
    final interpretation = _generateInterpretation(
      dayMaster: dayMaster,
      dayMasterElement: dayMasterElement,
      elements: elements,
      dominantElement: dominantElement,
      weakestElement: weakestElement,
    );

    // 행운의 색상
    final luckyColors = elementColors[weakestElement] ?? ['#D4A574', '#8B4513'];

    // 행운의 숫자
    final stemIndex = heavenlyStems.indexOf(dayMaster);
    final branchIndex = earthlyBranches.indexOf(dayPillar.branch);
    final luckyNumbers = [
      stemIndex + 1,
      branchIndex + 1,
      (stemIndex + branchIndex) % 9 + 1,
    ].toSet().toList();

    // 점수 계산 (50-100): 랜덤 제거, 동일 입력에 동일 점수 보장
    final score = _calculateOverallScore(
      elements: elements,
      dayStemIndex: stemIndex,
      dayBranchIndex: branchIndex,
    );

    return SajuResult(
      yearPillar: yearPillar,
      monthPillar: monthPillar,
      dayPillar: dayPillar,
      hourPillar: hourPillar,
      elements: elements,
      dominantElement: dominantElement,
      weakestElement: weakestElement,
      zodiac: zodiac,
      zodiacHanja:
          earthlyBranchesHanja[yearBranchIndex < 0
              ? yearBranchIndex + 12
              : yearBranchIndex],
      dayMaster: dayMaster,
      dayMasterElement: dayMasterElement,
      interpretation: interpretation,
      luckyColors: luckyColors,
      luckyNumbers: luckyNumbers,
      overallScore: score,
    );
  }

  int _calculateOverallScore({
    required Map<String, int> elements,
    required int dayStemIndex,
    required int dayBranchIndex,
  }) {
    final maxElement = elements.values.reduce((a, b) => a > b ? a : b);
    final minElement = elements.values.reduce((a, b) => a < b ? a : b);
    final balanceBonus = (4 - (maxElement - minElement)).clamp(0, 4) * 5;
    final cycleFactor = ((dayStemIndex + 1) * 3 + (dayBranchIndex + 1) * 2) % 21;

    return (55 + balanceBonus + cycleFactor).clamp(50, 100);
  }

  Map<String, int> _calculateElements(
    Pillar year,
    Pillar month,
    Pillar day,
    Pillar? hour,
  ) {
    final counts = {'목': 0, '화': 0, '토': 0, '금': 0, '수': 0};

    for (final pillar in [year, month, day, if (hour != null) hour]) {
      final element = stemToElement[pillar.stem];
      if (element != null) {
        counts[element] = (counts[element] ?? 0) + 1;
      }
    }

    return counts;
  }

  String _generateInterpretation({
    required String dayMaster,
    required String dayMasterElement,
    required Map<String, int> elements,
    required String dominantElement,
    required String weakestElement,
  }) {
    final buffer = StringBuffer();

    buffer.writeln(
      '📊 일간(일주 천간): $dayMaster (${elementHanja[dayMasterElement] ?? dayMasterElement})',
    );
    buffer.writeln();
    buffer.writeln('🔮 오행 분석:');
    elements.forEach((element, count) {
      final bar = '●' * count + '○' * (4 - count);
      buffer.writeln('  $element(${elementHanja[element]}): $bar ($count)');
    });
    buffer.writeln();
    buffer.writeln('💫 총운:');
    buffer.writeln(
      '${dayMasterElement}의 기운을 타고난 당신은 ${_getElementDescription(dayMasterElement)}',
    );
    buffer.writeln();
    buffer.writeln(
      '${dominantElement}의 기운이 강하여 ${_getElementStrength(dominantElement)}',
    );
    if ((elements[weakestElement] ?? 0) == 0) {
      buffer.writeln(
        '${weakestElement}의 기운이 부족하니 ${_getElementWeakness(weakestElement)}',
      );
    }
    buffer.writeln();
    buffer.writeln('⚠️ 참고: 이 결과는 기본 계산 기반입니다. 정확한 분석은 전문가 상담을 권장합니다.');

    return buffer.toString();
  }

  String _getElementDescription(String element) {
    switch (element) {
      case '목':
        return '성장과 발전의 에너지가 있습니다. 새로운 시작에 유리하고 창의적인 면이 있습니다.';
      case '화':
        return '열정과 에너지가 넘칩니다. 표현력이 풍부하고 리더십이 있습니다.';
      case '토':
        return '안정과 신뢰의 기운입니다. 중심을 잘 잡고 균형감이 뛰어납니다.';
      case '금':
        return '결단력과 정의감이 강합니다. 원칙을 중시하고 책임감이 있습니다.';
      case '수':
        return '지혜와 유연함을 갖추었습니다. 적응력이 뛰어나고 통찰력이 있습니다.';
      default:
        return '다양한 가능성을 가지고 있습니다.';
    }
  }

  String _getElementStrength(String element) {
    switch (element) {
      case '목':
        return '창의적이고 성장 지향적인 성향이 두드러집니다.';
      case '화':
        return '열정적이고 표현력이 뛰어난 면이 강조됩니다.';
      case '토':
        return '안정적이고 신뢰할 수 있는 모습이 부각됩니다.';
      case '금':
        return '원칙적이고 정의로운 면이 강하게 나타납니다.';
      case '수':
        return '지적이고 유연한 사고가 돋보입니다.';
      default:
        return '균형 잡힌 모습을 보입니다.';
    }
  }

  String _getElementWeakness(String element) {
    switch (element) {
      case '목':
        return '창의성과 새로운 시작의 에너지를 보충하면 좋겠습니다.';
      case '화':
        return '열정과 표현력을 더 발휘해보세요.';
      case '토':
        return '안정감과 중심을 잡는 노력이 필요합니다.';
      case '금':
        return '결단력과 원칙을 더 세워보세요.';
      case '수':
        return '유연함과 지혜를 기르면 도움이 됩니다.';
      default:
        return '균형을 맞추는 노력이 필요합니다.';
    }
  }

  /// 만세력: 특정 날짜의 간지 반환
  Pillar getDayGanji(DateTime date) {
    final year = date.year;
    final month = date.month;
    final day = date.day;

    final dayStemIndex = (year + month + day) % 10;
    final dayBranchIndex = (year + month + day) % 12;

    return Pillar(
      stem: heavenlyStems[dayStemIndex],
      stemHanja: heavenlyStemsHanja[dayStemIndex],
      branch: earthlyBranches[dayBranchIndex],
      branchHanja: earthlyBranchesHanja[dayBranchIndex],
    );
  }

  /// 만세력: 특정 연도의 간지 반환
  Pillar getYearGanji(int year) {
    final yearStemIndex = (year - 4) % 10;
    final yearBranchIndex = (year - 4) % 12;

    return Pillar(
      stem:
          heavenlyStems[yearStemIndex < 0 ? yearStemIndex + 10 : yearStemIndex],
      stemHanja:
          heavenlyStemsHanja[yearStemIndex < 0
              ? yearStemIndex + 10
              : yearStemIndex],
      branch:
          earthlyBranches[yearBranchIndex < 0
              ? yearBranchIndex + 12
              : yearBranchIndex],
      branchHanja:
          earthlyBranchesHanja[yearBranchIndex < 0
              ? yearBranchIndex + 12
              : yearBranchIndex],
    );
  }
}
