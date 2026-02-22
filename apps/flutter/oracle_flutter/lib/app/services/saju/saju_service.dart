/// Saju Calculation Service
/// Accurate implementation based on traditional Korean/Chinese astrology
/// Using Julian Day Number for day pillar, 年上起月法 for month,
/// 日上起時法 for hour, with ten gods, 12 stages, spirit stars, and major cycles
library;

import 'saju_models.dart';

class SajuService {
  // ═══════════════════════════════════════════════════
  // 기본 데이터 테이블
  // ═══════════════════════════════════════════════════

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

  // 천간 → 오행 매핑
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

  // 천간 → 음양
  static const Map<String, String> stemToYinYang = {
    '갑': '양',
    '을': '음',
    '병': '양',
    '정': '음',
    '무': '양',
    '기': '음',
    '경': '양',
    '신': '음',
    '임': '양',
    '계': '음',
  };

  // 지지 → 오행 (본기)
  static const Map<String, String> branchToElement = {
    '자': '수',
    '축': '토',
    '인': '목',
    '묘': '목',
    '진': '토',
    '사': '화',
    '오': '화',
    '미': '토',
    '신': '금',
    '유': '금',
    '술': '토',
    '해': '수',
  };

  // 지지 → 장간(藏干) 매핑: [본기, 중기, 여기]
  // 일부 지지는 본기만 가지고, 일부는 2~3개의 장간을 가짐
  static const Map<String, List<String>> branchHiddenStems = {
    '자': ['계'], // 水
    '축': ['기', '계', '신'], // 土, 水, 金
    '인': ['갑', '병', '무'], // 木, 火, 土
    '묘': ['을'], // 木
    '진': ['무', '을', '계'], // 土, 木, 水
    '사': ['병', '무', '경'], // 火, 土, 金
    '오': ['정', '기'], // 火, 土
    '미': ['기', '정', '을'], // 土, 火, 木
    '신': ['경', '임', '무'], // 金, 水, 土
    '유': ['신'], // 金
    '술': ['무', '신', '정'], // 土, 金, 火
    '해': ['임', '갑'], // 水, 木
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
    '목': ['#228B22', '#90EE90'],
    '화': ['#FF4500', '#FF6347'],
    '토': ['#D2691E', '#DEB887'],
    '금': ['#FFD700', '#C0C0C0'],
    '수': ['#000080', '#4169E1'],
  };

  // ═══════════════════════════════════════════════════
  // 십성(十星) 관계표
  // 일간의 오행과 타 천간 오행의 관계로 결정
  // [일간오행인덱스][대상오행인덱스] → 음양에 따라 세분화
  // 오행 순서: 목=0, 화=1, 토=2, 금=3, 수=4
  // ═══════════════════════════════════════════════════
  static const List<String> _elementOrder = ['목', '화', '토', '금', '수'];

  // 오행 상생상극 관계로 십성 분류
  // 같은 오행 → 비겁 (비견/겁재)
  // 내가 생 → 식상 (식신/상관)
  // 내가 극 → 재성 (편재/정재)
  // 나를 극 → 관성 (편관/정관)
  // 나를 생 → 인성 (편인/정인)
  static String _getTenGodCategory(String myElement, String otherElement) {
    final myIdx = _elementOrder.indexOf(myElement);
    final otherIdx = _elementOrder.indexOf(otherElement);
    if (myIdx == -1 || otherIdx == -1) return '비겁';

    if (myIdx == otherIdx) return '비겁';
    if ((myIdx + 1) % 5 == otherIdx) return '식상'; // 내가 생하는 것
    if ((myIdx + 2) % 5 == otherIdx) return '재성'; // 내가 극하는 것 (두 칸 앞)
    if ((myIdx + 3) % 5 == otherIdx) return '관성'; // 나를 극하는 것
    if ((myIdx + 4) % 5 == otherIdx) return '인성'; // 나를 생하는 것
    return '비겁';
  }

  // 음양이 같으면 편(偏), 다르면 정(正)
  static TenGod calculateTenGod(String dayStem, String targetStem) {
    final dayElement = stemToElement[dayStem] ?? '토';
    final targetElement = stemToElement[targetStem] ?? '토';
    final dayYy = stemToYinYang[dayStem] ?? '양';
    final targetYy = stemToYinYang[targetStem] ?? '양';
    final sameYinYang = dayYy == targetYy;
    final category = _getTenGodCategory(dayElement, targetElement);

    String name;
    String hanja;
    String description;

    switch (category) {
      case '비겁':
        if (sameYinYang) {
          name = '비견';
          hanja = '比肩';
          description = '나와 같은 기운. 독립심과 자존심이 강하며 경쟁 의식이 있습니다.';
        } else {
          name = '겁재';
          hanja = '劫財';
          description = '나와 비슷하나 다른 기운. 사교적이고 활동적이지만 재물 소비가 잦습니다.';
        }
      case '식상':
        if (sameYinYang) {
          name = '식신';
          hanja = '食神';
          description = '내가 낳은 기운. 식복이 있고 여유롭며 표현력과 예술적 감각이 뛰어납니다.';
        } else {
          name = '상관';
          hanja = '傷官';
          description = '내가 낳은 다른 기운. 재능이 출중하고 비판적 사고가 강하지만 반항심이 있을 수 있습니다.';
        }
      case '재성':
        if (sameYinYang) {
          name = '편재';
          hanja = '偏財';
          description = '사업운과 투자 감각이 있으며 큰 재물을 다루는 능력이 있습니다.';
        } else {
          name = '정재';
          hanja = '正財';
          description = '안정적 수입과 저축 능력이 뛰어나며 근면 성실합니다.';
        }
      case '관성':
        if (sameYinYang) {
          name = '편관';
          hanja = '偏官';
          description = '강한 추진력과 리더십이 있으며 권위와 도전 의식이 강합니다.';
        } else {
          name = '정관';
          hanja = '正官';
          description = '명예와 직위를 중시하며 책임감이 강하고 규칙을 잘 지킵니다.';
        }
      case '인성':
        if (sameYinYang) {
          name = '편인';
          hanja = '偏印';
          description = '독특한 학문적 재능이 있으며 직관력과 창의성이 뛰어납니다.';
        } else {
          name = '정인';
          hanja = '正印';
          description = '학업운이 좋고 지적 능력이 뛰어나며 어머니와 인연이 깊습니다.';
        }
      default:
        name = '비견';
        hanja = '比肩';
        description = '나와 같은 기운입니다.';
    }

    return TenGod(
      name: name,
      hanja: hanja,
      category: category,
      description: description,
    );
  }

  // ═══════════════════════════════════════════════════
  // 12운성(十二運星) 테이블
  // 천간별 지지에 따른 에너지 단계
  // 순서: 장생(0), 목욕(1), 관대(2), 건록(3), 제왕(4),
  //       쇠(5), 병(6), 사(7), 묘(8), 절(9), 태(10), 양(11)
  // ═══════════════════════════════════════════════════
  static const List<String> _twelveStageNames = [
    '장생',
    '목욕',
    '관대',
    '건록',
    '제왕',
    '쇠',
    '병',
    '사',
    '묘',
    '절',
    '태',
    '양',
  ];
  static const List<String> _twelveStageHanja = [
    '長生',
    '沐浴',
    '冠帶',
    '建祿',
    '帝旺',
    '衰',
    '病',
    '死',
    '墓',
    '絶',
    '胎',
    '養',
  ];
  static const List<String> _twelveStageDescriptions = [
    '새로운 시작의 에너지. 가능성이 피어나고 성장의 기회가 열립니다.',
    '성장과 변화의 시기. 배움과 적응의 과정을 거칩니다.',
    '자신감이 커지는 시기. 사회적 인정을 받기 시작합니다.',
    '실력이 무르익는 시기. 안정적인 성과와 직위를 얻습니다.',
    '에너지의 최절정. 최대의 성과와 영향력을 발휘합니다.',
    '하강의 시작. 안정을 추구하며 내면을 돌아보는 시기입니다.',
    '기운이 약해지는 시기. 건강 관리와 재충전이 필요합니다.',
    '전환의 시기. 과감한 결단과 새로운 방향 모색이 필요합니다.',
    '축적과 저장의 시기. 내실을 다지고 기반을 정리합니다.',
    '끝과 새로운 시작 사이. 과거를 정리하고 미래를 준비합니다.',
    '잉태의 에너지. 새로운 계획과 아이디어가 싹트기 시작합니다.',
    '준비와 양육의 시기. 천천히 힘을 기르며 때를 기다립니다.',
  ];

  // 천간별 12운성 시작 지지 인덱스 (장생 위치)
  // 갑→해(11), 을→오(6), 병→인(2), 정→유(9), 무→인(2),
  // 기→유(9), 경→사(5), 신→자(0), 임→신(8), 계→묘(3)
  static const List<int> _twelveStageStartBranch = [
    11,
    6,
    2,
    9,
    2,
    9,
    5,
    0,
    8,
    3,
  ];

  // 양간은 순행(+1), 음간은 역행(-1)
  static TwelveStage calculateTwelveStage(int stemIndex, int branchIndex) {
    final isYang = stemIndex % 2 == 0;
    final startBranch = _twelveStageStartBranch[stemIndex];
    int stage;
    if (isYang) {
      stage = (branchIndex - startBranch + 12) % 12;
    } else {
      stage = (startBranch - branchIndex + 12) % 12;
    }

    return TwelveStage(
      name: _twelveStageNames[stage],
      hanja: _twelveStageHanja[stage],
      stageIndex: stage,
      description: _twelveStageDescriptions[stage],
    );
  }

  // ═══════════════════════════════════════════════════
  // 신살(神殺) 계산
  // ═══════════════════════════════════════════════════

  // 천을귀인(天乙貴人): 일간 기준 → 해당 지지
  static const Map<String, List<String>> _cheonEulGuiin = {
    '갑': ['축', '미'],
    '을': ['자', '신'],
    '병': ['해', '유'],
    '정': ['해', '유'],
    '무': ['축', '미'],
    '기': ['자', '신'],
    '경': ['축', '미'],
    '신': ['인', '오'],
    '임': ['묘', '사'],
    '계': ['묘', '사'],
  };

  // 역마살(驛馬殺): 일지 기준
  static const Map<String, String> _yeokma = {
    '인': '신',
    '오': '신',
    '술': '신',
    '사': '해',
    '유': '해',
    '축': '해',
    '신': '인',
    '자': '인',
    '진': '인',
    '해': '사',
    '묘': '사',
    '미': '사',
  };

  // 도화살(桃花殺): 일지 기준
  static const Map<String, String> _dohwa = {
    '인': '묘',
    '오': '묘',
    '술': '묘',
    '사': '오',
    '유': '오',
    '축': '오',
    '신': '유',
    '자': '유',
    '진': '유',
    '해': '자',
    '묘': '자',
    '미': '자',
  };

  // 화개살(華蓋殺): 일지 기준
  static const Map<String, String> _hwagae = {
    '인': '술',
    '오': '술',
    '술': '술',
    '사': '축',
    '유': '축',
    '축': '축',
    '신': '진',
    '자': '진',
    '진': '진',
    '해': '미',
    '묘': '미',
    '미': '미',
  };

  // 문창귀인(文昌貴人): 일간 기준
  static const Map<String, String> _munChang = {
    '갑': '사',
    '을': '오',
    '병': '신',
    '정': '유',
    '무': '신',
    '기': '유',
    '경': '해',
    '신': '자',
    '임': '인',
    '계': '묘',
  };

  static List<SpiritStar> calculateSpiritStars({
    required String dayStem,
    required String dayBranch,
    required List<String> allBranches,
  }) {
    final stars = <SpiritStar>[];

    // 천을귀인
    final guiinBranches = _cheonEulGuiin[dayStem] ?? [];
    for (final branch in allBranches) {
      if (guiinBranches.contains(branch)) {
        stars.add(
          const SpiritStar(
            name: '천을귀인',
            hanja: '天乙貴人',
            isAuspicious: true,
            description:
                '가장 큰 길신. 위태로운 순간에도 귀인의 도움이 있어 위기를 넘기며, 사회적 인정과 존경을 받습니다.',
          ),
        );
        break;
      }
    }

    // 문창귀인
    final munChangBranch = _munChang[dayStem];
    if (munChangBranch != null && allBranches.contains(munChangBranch)) {
      stars.add(
        const SpiritStar(
          name: '문창귀인',
          hanja: '文昌貴人',
          isAuspicious: true,
          description: '학문과 시험에 유리한 길신. 지적 능력이 뛰어나고 문서 처리와 학업에서 좋은 결과를 얻습니다.',
        ),
      );
    }

    // 역마살
    final yeokmaBranch = _yeokma[dayBranch];
    if (yeokmaBranch != null && allBranches.contains(yeokmaBranch)) {
      stars.add(
        const SpiritStar(
          name: '역마살',
          hanja: '驛馬殺',
          isAuspicious: false,
          description:
              '이동과 변동의 기운. 해외 진출이나 이사, 출장이 잦으며 한 곳에 머무르기 어렵습니다. 활용하면 활동 반경이 넓어집니다.',
        ),
      );
    }

    // 도화살
    final dohwaBranch = _dohwa[dayBranch];
    if (dohwaBranch != null && allBranches.contains(dohwaBranch)) {
      stars.add(
        const SpiritStar(
          name: '도화살',
          hanja: '桃花殺',
          isAuspicious: false,
          description: '매력과 이성 인연의 기운. 외모나 말솜씨가 좋아 인기가 많지만, 이성 문제에 주의가 필요합니다.',
        ),
      );
    }

    // 화개살
    final hwagaeBranch = _hwagae[dayBranch];
    if (hwagaeBranch != null && allBranches.contains(hwagaeBranch)) {
      stars.add(
        const SpiritStar(
          name: '화개살',
          hanja: '華蓋殺',
          isAuspicious: true,
          description: '예술과 종교, 학문의 기운. 깊은 사색과 탐구심이 있으며 예술적 재능이 뛰어납니다.',
        ),
      );
    }

    // 양인살(羊刃殺): 일간 건록 다음 지지
    final stemIdx = heavenlyStems.indexOf(dayStem);
    if (stemIdx != -1 && stemIdx % 2 == 0) {
      // 양간만
      // 양인 = 건록 + 1 = 장생 + 4 (제왕과 같은 지지)
      final yangInBranch =
          earthlyBranches[(_twelveStageStartBranch[stemIdx] + 4) % 12];
      if (allBranches.contains(yangInBranch)) {
        stars.add(
          const SpiritStar(
            name: '양인살',
            hanja: '羊刃殺',
            isAuspicious: false,
            description: '강렬한 결단력과 추진력. 과감한 행동이 장점이지만 극단적 선택이나 부상에 주의가 필요합니다.',
          ),
        );
      }
    }

    return stars;
  }

  // ═══════════════════════════════════════════════════
  // 절기(節氣) 기반 월 경계
  // 양력 월별 절기 시작일 (근사값)
  // ═══════════════════════════════════════════════════
  static const List<int> _solarTermDays = [
    // 월 1~12의 절기 시작 근사일
    6, // 1월: 소한(小寒) ~1/6
    4, // 2월: 입춘(立春) ~2/4
    6, // 3월: 경칩(驚蟄) ~3/6
    5, // 4월: 청명(清明) ~4/5
    6, // 5월: 입하(立夏) ~5/6
    6, // 6월: 망종(芒種) ~6/6
    7, // 7월: 소서(小暑) ~7/7
    7, // 8월: 입추(立秋) ~8/7
    8, // 9월: 백로(白露) ~9/8
    8, // 10월: 한로(寒露) ~10/8
    7, // 11월: 입동(立冬) ~11/7
    7, // 12월: 대설(大雪) ~12/7
  ];

  // ═══════════════════════════════════════════════════
  // 만세력 절기 월건 매핑: 월의 지지는 고정
  // 1월건→인(寅), 2월건→묘(卯), ..., 12월건→축(丑)
  // ═══════════════════════════════════════════════════
  static int _getSajuMonth(int solarMonth, int solarDay) {
    // 절기 이전이면 이전 월로 판단
    if (solarDay < _solarTermDays[solarMonth - 1]) {
      return (solarMonth - 2 + 12) % 12; // 이전 월
    }
    return (solarMonth - 1) % 12; // 현재 월
  }

  // 월지 인덱스 (1월건=인(2), 2월건=묘(3), ..., 12월건=축(1))
  static int _monthBranchIndex(int sajuMonth) {
    return (sajuMonth + 2) % 12;
  }

  // ═══════════════════════════════════════════════════
  // 년상기월법(年上起月法): 년간에 따른 월간 결정
  // 갑/기년 → 병인월 시작, 을/경년 → 무인월 시작,
  // 병/신년 → 경인월 시작, 정/임년 → 임인월 시작,
  // 무/계년 → 갑인월 시작
  // ═══════════════════════════════════════════════════
  static int _monthStemStart(int yearStemIndex) {
    // 년간 인덱스 % 5 → 시작 월간 인덱스
    switch (yearStemIndex % 5) {
      case 0:
        return 2; // 갑/기 → 병(2)
      case 1:
        return 4; // 을/경 → 무(4)
      case 2:
        return 6; // 병/신 → 경(6)
      case 3:
        return 8; // 정/임 → 임(8)
      case 4:
        return 0; // 무/계 → 갑(0)
      default:
        return 2;
    }
  }

  // ═══════════════════════════════════════════════════
  // 일상기시법(日上起時法): 일간에 따른 시간 결정
  // 갑/기일 → 갑자시 시작, 을/경일 → 병자시 시작, ...
  // ═══════════════════════════════════════════════════
  static int _hourStemStart(int dayStemIndex) {
    switch (dayStemIndex % 5) {
      case 0:
        return 0; // 갑/기 → 갑(0)
      case 1:
        return 2; // 을/경 → 병(2)
      case 2:
        return 4; // 병/신 → 무(4)
      case 3:
        return 6; // 정/임 → 경(6)
      case 4:
        return 8; // 무/계 → 임(8)
      default:
        return 0;
    }
  }

  // 시간 → 시진 인덱스 (0=자시23~01, 1=축시01~03, ...)
  static int _hourToBranchIndex(int hour) {
    // 子시: 23:00~00:59 → 0
    // 丑시: 01:00~02:59 → 1
    // ...
    if (hour == 23) return 0;
    return ((hour + 1) ~/ 2) % 12;
  }

  // ═══════════════════════════════════════════════════
  // JDN (Julian Day Number) 기반 일주 계산
  // 그레고리력 → JDN → 60갑자 인덱스
  // ═══════════════════════════════════════════════════
  static int _toJulianDayNumber(int year, int month, int day) {
    // 그레고리력 → JDN 변환 (표준 공식)
    final a = (14 - month) ~/ 12;
    final y = year + 4800 - a;
    final m = month + 12 * a - 3;
    return day +
        (153 * m + 2) ~/ 5 +
        365 * y +
        y ~/ 4 -
        y ~/ 100 +
        y ~/ 400 -
        32045;
  }

  // JDN → 60갑자 인덱스
  // 기준일: 서기 2000년 1월 7일 = 甲子일 (JDN=2451551)
  static int _jdnToGanjiIndex(int jdn) {
    // 2000-01-07 = 甲子 = 갑자 = index 0, JDN = 2451551
    return ((jdn - 2451551) % 60 + 60) % 60;
  }

  // ═══════════════════════════════════════════════════
  // 대운(大運) 계산
  // ═══════════════════════════════════════════════════
  static List<MajorCycle> _calculateMajorCycles({
    required int yearStemIndex,
    required int monthStemIndex,
    required int monthBranchIndex,
    required String? gender,
    required DateTime birthDate,
  }) {
    // 양남음녀 순행, 음남양녀 역행
    final isYangYear = yearStemIndex % 2 == 0;
    final isMale = gender == '남' || gender == 'male' || gender == 'M';
    final forward = (isYangYear && isMale) || (!isYangYear && !isMale);

    final cycles = <MajorCycle>[];
    // 대운 시작 나이 근사 계산 (절기까지의 일수 / 3)
    // 간략화: 평균 4세 시작
    int startAge = 4;

    for (int i = 1; i <= 8; i++) {
      final stemIdx = forward
          ? (monthStemIndex + i) % 10
          : (monthStemIndex - i + 10) % 10;
      final branchIdx = forward
          ? (monthBranchIndex + i) % 12
          : (monthBranchIndex - i + 12) % 12;

      final pillar = Pillar(
        stem: heavenlyStems[stemIdx],
        stemHanja: heavenlyStemsHanja[stemIdx],
        branch: earthlyBranches[branchIdx],
        branchHanja: earthlyBranchesHanja[branchIdx],
      );

      final element = stemToElement[heavenlyStems[stemIdx]] ?? '토';
      final endAge = startAge + 9;

      cycles.add(
        MajorCycle(
          pillar: pillar,
          startAge: startAge,
          endAge: endAge,
          description: _getMajorCycleDescription(element, pillar.ganji),
        ),
      );

      startAge = endAge + 1;
    }

    return cycles;
  }

  static String _getMajorCycleDescription(String element, String ganji) {
    switch (element) {
      case '목':
        return '$ganji 대운: 성장과 발전의 시기. 새로운 도전과 학습에 유리하며 인간관계가 확장됩니다.';
      case '화':
        return '$ganji 대운: 활동과 표현의 시기. 열정적인 추진이 성과로 이어지며 명예 상승의 기회가 있습니다.';
      case '토':
        return '$ganji 대운: 안정과 축적의 시기. 기반을 다지고 실력을 쌓는 데 유리하며 부동산과 인연이 있습니다.';
      case '금':
        return '$ganji 대운: 결실과 수확의 시기. 그동안의 노력이 결실을 맺으며 결단력 있는 행동이 필요합니다.';
      case '수':
        return '$ganji 대운: 지혜와 유연의 시기. 통찰력이 높아지고 새로운 흐름을 읽는 능력이 강해집니다.';
      default:
        return '$ganji 대운: 변환의 시기입니다.';
    }
  }

  // ═══════════════════════════════════════════════════
  // 메인 계산 메서드
  // ═══════════════════════════════════════════════════

  /// 생년월일시로 사주 팔자 계산
  SajuResult calculate({
    required DateTime birthDate,
    String? birthTime,
    String? gender,
  }) {
    final year = birthDate.year;
    final month = birthDate.month;
    final day = birthDate.day;

    // ── 년주 계산 ──
    // 입춘(2/4) 이전이면 전년도 간지 사용
    final sajuYear = (month < 2 || (month == 2 && day < 4)) ? year - 1 : year;
    final yearStemIndex = ((sajuYear - 4) % 10 + 10) % 10;
    final yearBranchIndex = ((sajuYear - 4) % 12 + 12) % 12;
    final yearPillar = Pillar(
      stem: heavenlyStems[yearStemIndex],
      stemHanja: heavenlyStemsHanja[yearStemIndex],
      branch: earthlyBranches[yearBranchIndex],
      branchHanja: earthlyBranchesHanja[yearBranchIndex],
    );

    // ── 월주 계산 (年上起月法 + 절기) ──
    final sajuMonth = _getSajuMonth(month, day);
    final monthBranchIndex = _monthBranchIndex(sajuMonth);
    final monthStemStart = _monthStemStart(yearStemIndex);
    final monthStemIndex = (monthStemStart + sajuMonth) % 10;
    final monthPillar = Pillar(
      stem: heavenlyStems[monthStemIndex],
      stemHanja: heavenlyStemsHanja[monthStemIndex],
      branch: earthlyBranches[monthBranchIndex],
      branchHanja: earthlyBranchesHanja[monthBranchIndex],
    );

    // ── 일주 계산 (JDN 기반) ──
    final jdn = _toJulianDayNumber(year, month, day);
    final dayGanjiIndex = _jdnToGanjiIndex(jdn);
    final dayStemIndex = dayGanjiIndex % 10;
    final dayBranchIndex = dayGanjiIndex % 12;
    final dayPillar = Pillar(
      stem: heavenlyStems[dayStemIndex],
      stemHanja: heavenlyStemsHanja[dayStemIndex],
      branch: earthlyBranches[dayBranchIndex],
      branchHanja: earthlyBranchesHanja[dayBranchIndex],
    );

    // ── 시주 계산 (日上起時法) ──
    Pillar? hourPillar;
    int? hourBranchIndex;
    if (birthTime != null && birthTime.isNotEmpty) {
      final parts = birthTime.split(':');
      if (parts.length >= 2) {
        final hour = int.tryParse(parts[0]) ?? 0;
        hourBranchIndex = _hourToBranchIndex(hour);
        final hourStemStart = _hourStemStart(dayStemIndex);
        final hourStemIndex = (hourStemStart + hourBranchIndex) % 10;
        hourPillar = Pillar(
          stem: heavenlyStems[hourStemIndex],
          stemHanja: heavenlyStemsHanja[hourStemIndex],
          branch: earthlyBranches[hourBranchIndex],
          branchHanja: earthlyBranchesHanja[hourBranchIndex],
        );
      }
    }

    // ── 오행 계산 (장간 포함) ──
    final elements = _calculateElements(
      yearPillar,
      monthPillar,
      dayPillar,
      hourPillar,
    );
    final hiddenElements = _calculateHiddenElements(
      yearPillar,
      monthPillar,
      dayPillar,
      hourPillar,
    );

    // ── 일간 정보 ──
    final dayMaster = dayPillar.stem;
    final dayMasterElement = stemToElement[dayMaster] ?? '토';

    // ── 일간 강약 판단 ──
    final dayMasterStrength = _calculateDayMasterStrength(
      dayMasterElement,
      elements,
      hiddenElements,
      monthBranchIndex,
      dayBranchIndex,
    );

    // ── 지배/부족 오행 ──
    final totalElements = <String, int>{};
    elements.forEach((k, v) => totalElements[k] = v);
    hiddenElements.forEach(
      (k, v) => totalElements[k] = (totalElements[k] ?? 0) + v,
    );
    final dominantElement = totalElements.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    final weakestElement = totalElements.entries
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;

    // ── 띠 ──
    final zodiac = zodiacAnimals[yearBranchIndex];

    // ── 십성 계산 ──
    final tenGods = <String, TenGod>{};
    tenGods['년간'] = calculateTenGod(dayMaster, yearPillar.stem);
    tenGods['월간'] = calculateTenGod(dayMaster, monthPillar.stem);
    if (hourPillar != null) {
      tenGods['시간'] = calculateTenGod(dayMaster, hourPillar.stem);
    }

    // ── 12운성 ──
    final dayTwelveStage = calculateTwelveStage(dayStemIndex, dayBranchIndex);

    // ── 신살 ──
    final allBranches = [
      yearPillar.branch,
      monthPillar.branch,
      dayPillar.branch,
      if (hourPillar != null) hourPillar.branch,
    ];
    final spiritStars = calculateSpiritStars(
      dayStem: dayMaster,
      dayBranch: dayPillar.branch,
      allBranches: allBranches,
    );

    // ── 대운 ──
    final majorCycles = _calculateMajorCycles(
      yearStemIndex: yearStemIndex,
      monthStemIndex: monthStemIndex,
      monthBranchIndex: monthBranchIndex,
      gender: gender,
      birthDate: birthDate,
    );

    // ── 해석 생성 ──
    final interpretation = _generateInterpretation(
      dayMaster: dayMaster,
      dayMasterElement: dayMasterElement,
      dayMasterStrength: dayMasterStrength,
      elements: totalElements,
      dominantElement: dominantElement,
      weakestElement: weakestElement,
      tenGods: tenGods,
      dayTwelveStage: dayTwelveStage,
      spiritStars: spiritStars,
    );

    // ── 행운의 색상 (부족 오행 보강) ──
    final luckyColors = elementColors[weakestElement] ?? ['#D4A574', '#8B4513'];

    // ── 행운의 숫자 ──
    final luckyNumbers = <int>{
      dayStemIndex + 1,
      dayBranchIndex + 1,
      (dayStemIndex + dayBranchIndex) % 9 + 1,
    }.toList();

    // ── 점수 계산 ──
    final score = _calculateOverallScore(
      elements: totalElements,
      dayStemIndex: dayStemIndex,
      dayBranchIndex: dayBranchIndex,
      dayMasterStrength: dayMasterStrength,
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
      zodiacHanja: earthlyBranchesHanja[yearBranchIndex],
      dayMaster: dayMaster,
      dayMasterElement: dayMasterElement,
      interpretation: interpretation,
      luckyColors: luckyColors,
      luckyNumbers: luckyNumbers,
      overallScore: score,
      tenGods: tenGods,
      dayTwelveStage: dayTwelveStage,
      spiritStars: spiritStars,
      majorCycles: majorCycles,
      hiddenElements: hiddenElements,
      dayMasterStrength: dayMasterStrength,
    );
  }

  // ═══════════════════════════════════════════════════
  // 오행 계산 (천간)
  // ═══════════════════════════════════════════════════
  Map<String, int> _calculateElements(
    Pillar year,
    Pillar month,
    Pillar day,
    Pillar? hour,
  ) {
    final counts = {'목': 0, '화': 0, '토': 0, '금': 0, '수': 0};
    for (final pillar in [year, month, day, if (hour != null) hour]) {
      final stemEl = stemToElement[pillar.stem];
      if (stemEl != null) counts[stemEl] = (counts[stemEl] ?? 0) + 1;
      final branchEl = branchToElement[pillar.branch];
      if (branchEl != null) counts[branchEl] = (counts[branchEl] ?? 0) + 1;
    }
    return counts;
  }

  // 장간 기반 오행 세부 계산
  Map<String, int> _calculateHiddenElements(
    Pillar year,
    Pillar month,
    Pillar day,
    Pillar? hour,
  ) {
    final counts = {'목': 0, '화': 0, '토': 0, '금': 0, '수': 0};
    for (final pillar in [year, month, day, if (hour != null) hour]) {
      final hiddenStems = branchHiddenStems[pillar.branch] ?? [];
      for (final hs in hiddenStems) {
        final el = stemToElement[hs];
        if (el != null) counts[el] = (counts[el] ?? 0) + 1;
      }
    }
    return counts;
  }

  // 일간 강약 판단
  String _calculateDayMasterStrength(
    String dayMasterElement,
    Map<String, int> elements,
    Map<String, int> hiddenElements,
    int monthBranchIndex,
    int dayBranchIndex,
  ) {
    // 일간과 같은 오행 + 일간을 생하는 오행의 합
    final sameEl =
        (elements[dayMasterElement] ?? 0) +
        (hiddenElements[dayMasterElement] ?? 0);
    final myIdx = _elementOrder.indexOf(dayMasterElement);
    final parentElement = _elementOrder[(myIdx + 4) % 5]; // 나를 생하는 오행
    final parentEl =
        (elements[parentElement] ?? 0) + (hiddenElements[parentElement] ?? 0);
    final supportScore = sameEl + parentEl;

    // 월지가 일간을 돕는지 (왕상휴수사)
    final monthElement =
        branchToElement[earthlyBranches[monthBranchIndex]] ?? '토';
    final monthBonus =
        (monthElement == dayMasterElement || monthElement == parentElement)
        ? 2
        : 0;

    final totalSupport = supportScore + monthBonus;
    final totalAll =
        elements.values.fold(0, (a, b) => a + b) +
        hiddenElements.values.fold(0, (a, b) => a + b);

    if (totalAll == 0) return '중화';
    final ratio = totalSupport / totalAll;
    if (ratio > 0.55) return '신강';
    if (ratio < 0.35) return '신약';
    return '중화';
  }

  int _calculateOverallScore({
    required Map<String, int> elements,
    required int dayStemIndex,
    required int dayBranchIndex,
    required String dayMasterStrength,
  }) {
    final maxEl = elements.values.reduce((a, b) => a > b ? a : b);
    final minEl = elements.values.reduce((a, b) => a < b ? a : b);
    final balanceBonus = (6 - (maxEl - minEl)).clamp(0, 6) * 3;
    final cycleFactor =
        ((dayStemIndex + 1) * 3 + (dayBranchIndex + 1) * 2) % 21;
    final strengthBonus = dayMasterStrength == '중화' ? 10 : 0;
    return (50 + balanceBonus + cycleFactor + strengthBonus).clamp(50, 100);
  }

  // ═══════════════════════════════════════════════════
  // 해석 생성
  // ═══════════════════════════════════════════════════
  String _generateInterpretation({
    required String dayMaster,
    required String dayMasterElement,
    required String dayMasterStrength,
    required Map<String, int> elements,
    required String dominantElement,
    required String weakestElement,
    required Map<String, TenGod> tenGods,
    required TwelveStage dayTwelveStage,
    required List<SpiritStar> spiritStars,
  }) {
    final buf = StringBuffer();

    buf.writeln(
      '📊 일간(日干): $dayMaster (${elementHanja[dayMasterElement]}) — $dayMasterStrength',
    );
    buf.writeln();

    buf.writeln('🔮 오행 분석:');
    elements.forEach((el, count) {
      final bar = '●' * count + '○' * ((8 - count).clamp(0, 8));
      buf.writeln('  $el(${elementHanja[el]}): $bar ($count)');
    });
    buf.writeln();

    buf.writeln('💫 일간 성격:');
    buf.writeln(_getDayMasterPersonality(dayMaster, dayMasterStrength));
    buf.writeln();

    buf.writeln('🏛️ 12운성: ${dayTwelveStage.name}(${dayTwelveStage.hanja})');
    buf.writeln('  ${dayTwelveStage.description}');
    buf.writeln();

    if (tenGods.isNotEmpty) {
      buf.writeln('⭐ 십성 배치:');
      tenGods.forEach((pos, tg) {
        buf.writeln('  $pos: ${tg.name}(${tg.hanja}) — ${tg.description}');
      });
      buf.writeln();
    }

    if (spiritStars.isNotEmpty) {
      buf.writeln('🌟 신살:');
      for (final star in spiritStars) {
        final icon = star.isAuspicious ? '✨' : '⚡';
        buf.writeln('  $icon ${star.name}(${star.hanja}): ${star.description}');
      }
      buf.writeln();
    }

    buf.writeln(
      '💪 $dominantElement의 기운이 강합니다: ${_getElementStrength(dominantElement)}',
    );
    if ((elements[weakestElement] ?? 0) <= 1) {
      buf.writeln(
        '⚠️ $weakestElement의 기운 보강 필요: ${_getElementWeakness(weakestElement)}',
      );
    }

    return buf.toString();
  }

  // 일간별 성격 상세 해석
  String _getDayMasterPersonality(String dayStem, String strength) {
    final strengthText = strength == '신강'
        ? '에너지가 강하여 주체적이고 독립적입니다.'
        : strength == '신약'
        ? '섬세하고 유연하며 타인과의 조화를 중시합니다.'
        : '균형 잡힌 기운으로 상황에 맞게 대처합니다.';

    switch (dayStem) {
      case '갑':
        return '갑목(甲木) — 큰 나무의 기운. 곧고 바르며 리더십이 있습니다. 성장 지향적이고 정의감이 강합니다. $strengthText';
      case '을':
        return '을목(乙木) — 풀과 꽃의 기운. 유연하고 적응력이 뛰어나며 예술적 감각이 있습니다. 부드럽지만 강인합니다. $strengthText';
      case '병':
        return '병화(丙火) — 태양의 기운. 밝고 열정적이며 카리스마가 있습니다. 리더의 자질이 있고 남을 따뜻하게 감쌉니다. $strengthText';
      case '정':
        return '정화(丁火) — 촛불의 기운. 섬세하고 세심하며 문화예술에 재능이 있습니다. 내면의 열정이 깊습니다. $strengthText';
      case '무':
        return '무토(戊土) — 산과 대지의 기운. 듬직하고 신뢰감이 있으며 포용력이 큽니다. 중심을 잡는 역할에 적합합니다. $strengthText';
      case '기':
        return '기토(己土) — 밭과 논의 기운. 꼼꼼하고 실용적이며 타인을 돌보는 능력이 뛰어납니다. 속이 깊고 인내심이 있습니다. $strengthText';
      case '경':
        return '경금(庚金) — 원석과 광물의 기운. 결단력이 있고 원칙을 중시하며 정의감이 강합니다. 과감한 실행력이 특징입니다. $strengthText';
      case '신':
        return '신금(辛金) — 보석의 기운. 섬세하고 날카로운 감각을 가지며 미적 감각이 뛰어납니다. 완벽을 추구합니다. $strengthText';
      case '임':
        return '임수(壬水) — 큰 강과 바다의 기운. 포용력이 크고 지혜가 깊으며 대인관계가 넓습니다. 큰 그림을 그립니다. $strengthText';
      case '계':
        return '계수(癸水) — 이슬과 빗물의 기운. 지적이고 섬세하며 통찰력이 뛰어납니다. 조용하지만 깊은 영향력이 있습니다. $strengthText';
      default:
        return '다양한 가능성을 가지고 있습니다. $strengthText';
    }
  }

  String _getElementStrength(String element) {
    switch (element) {
      case '목':
        return '창의적이고 성장 지향적인 성향이 두드러집니다. 새로운 시작과 기획 능력이 강합니다.';
      case '화':
        return '열정적이고 표현력이 뛰어납니다. 사교성이 좋고 주목받는 능력이 있습니다.';
      case '토':
        return '안정적이고 신뢰를 주는 모습입니다. 중재 능력과 실무 능력이 탁월합니다.';
      case '금':
        return '원칙적이고 결단력이 강합니다. 분석력과 판단력이 뛰어나 전문 분야에서 두각을 나타냅니다.';
      case '수':
        return '지적이고 유연한 사고를 합니다. 통찰력이 깊고 창의적 문제 해결 능력이 있습니다.';
      default:
        return '균형 잡힌 모습을 보입니다.';
    }
  }

  String _getElementWeakness(String element) {
    switch (element) {
      case '목':
        return '녹색 계열의 옷이나 식물을 가까이 하고, 동쪽 방향이 유리합니다.';
      case '화':
        return '붉은 계열 색상을 활용하고, 활동적인 취미를 가지면 좋습니다.';
      case '토':
        return '노란/갈색 계열을 활용하고, 규칙적인 생활 리듬이 도움됩니다.';
      case '금':
        return '흰색/금속 액세서리를 활용하고, 서쪽 방향이 유리합니다.';
      case '수':
        return '검정/파랑 계열을 활용하고, 물가 활동이 도움이 됩니다.';
      default:
        return '전체적 균형을 맞추는 노력이 필요합니다.';
    }
  }

  // ═══════════════════════════════════════════════════
  // 만세력 관련 유틸리티
  // ═══════════════════════════════════════════════════

  /// 만세력: 특정 날짜의 간지 반환 (JDN 기반)
  Pillar getDayGanji(DateTime date) {
    final jdn = _toJulianDayNumber(date.year, date.month, date.day);
    final ganjiIndex = _jdnToGanjiIndex(jdn);
    final stemIndex = ganjiIndex % 10;
    final branchIndex = ganjiIndex % 12;
    return Pillar(
      stem: heavenlyStems[stemIndex],
      stemHanja: heavenlyStemsHanja[stemIndex],
      branch: earthlyBranches[branchIndex],
      branchHanja: earthlyBranchesHanja[branchIndex],
    );
  }

  /// 만세력: 특정 연도의 간지 반환
  Pillar getYearGanji(int year) {
    final yearStemIndex = ((year - 4) % 10 + 10) % 10;
    final yearBranchIndex = ((year - 4) % 12 + 12) % 12;
    return Pillar(
      stem: heavenlyStems[yearStemIndex],
      stemHanja: heavenlyStemsHanja[yearStemIndex],
      branch: earthlyBranches[yearBranchIndex],
      branchHanja: earthlyBranchesHanja[yearBranchIndex],
    );
  }

  /// 일진과 사주의 관계로 일일 운세 점수 계산
  int calculateDailyScore(SajuResult saju, DateTime date) {
    final dayGanji = getDayGanji(date);
    final dayElement = stemToElement[dayGanji.stem] ?? '토';
    final dayMasterElement = saju.dayMasterElement;

    // 일진 오행과 일간 오행의 관계로 기본 점수 산출
    final myIdx = _elementOrder.indexOf(dayMasterElement);
    final dayIdx = _elementOrder.indexOf(dayElement);
    int baseScore;

    if (myIdx == dayIdx) {
      baseScore = 70; // 비겁 - 보통
    } else if ((myIdx + 1) % 5 == dayIdx) {
      baseScore = 65; // 식상 - 에너지 소모
    } else if ((myIdx + 2) % 5 == dayIdx) {
      baseScore = 80; // 재성 - 재물운 좋음
    } else if ((myIdx + 3) % 5 == dayIdx) {
      baseScore = 55; // 관성 - 압박/도전
    } else {
      baseScore = 85; // 인성 - 도움/학습
    }

    // 지지 관계 보정
    final dayBranchEl = branchToElement[dayGanji.branch] ?? '토';
    if (dayBranchEl == dayMasterElement) baseScore += 5;

    // 날짜에 따른 미세 변동 (같은 사주+같은 날 = 항상 동일)
    final seed = date.year * 10000 + date.month * 100 + date.day;
    final variation = (seed * 17 + 13) % 11 - 5; // -5 ~ +5

    return (baseScore + variation).clamp(40, 100);
  }

  /// 오행 영문명 반환 (이미지 매핑용)
  static String getElementEnglish(String element) {
    switch (element) {
      case '목':
        return 'wood';
      case '화':
        return 'fire';
      case '토':
        return 'earth';
      case '금':
        return 'metal';
      case '수':
        return 'water';
      default:
        return 'fire';
    }
  }

  /// 띠 영문명 반환 (이미지 매핑용)
  static String getZodiacEnglish(String zodiac) {
    switch (zodiac) {
      case '쥐':
        return 'rat';
      case '소':
        return 'ox';
      case '호랑이':
        return 'tiger';
      case '토끼':
        return 'rabbit';
      case '용':
        return 'dragon';
      case '뱀':
        return 'snake';
      case '말':
        return 'horse';
      case '양':
        return 'sheep';
      case '원숭이':
        return 'monkey';
      case '닭':
        return 'Chicken';
      case '개':
        return 'dog';
      case '돼지':
        return 'pig';
      default:
        return 'rat';
    }
  }
}
