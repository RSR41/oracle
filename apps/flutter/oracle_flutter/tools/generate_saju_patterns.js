const fs = require('fs');
const path = require('path');

const gan = ['갑','을','병','정','무','기','경','신','임','계'];
const ji = ['자','축','인','묘','진','사','오','미','신','유','술','해'];

const elements = ['목', '화', '토', '금', '수'];
const careers = {
  '목': '기획, 교육, 브랜딩 업무',
  '화': '영업, 발표, 마케팅 업무',
  '토': '운영, 관리, 재무 업무',
  '금': '분석, 품질관리, 법무 업무',
  '수': '데이터, 연구, 개발 업무',
};
const wealth = {
  '목': '중장기 투자와 저축 병행 시 자산 안정성이 높아집니다.',
  '화': '성과형 수익 기회가 늘어나는 흐름입니다.',
  '토': '고정 지출 관리가 재정 안정의 핵심입니다.',
  '금': '리스크 관리 중심 전략이 유효합니다.',
  '수': '정보 기반 의사결정이 수익으로 연결됩니다.',
};
const health = {
  '목': '스트레칭과 수면 리듬 관리가 중요합니다.',
  '화': '체온 조절과 수분 보충에 신경 쓰세요.',
  '토': '소화기와 식사 리듬을 안정적으로 유지하세요.',
  '금': '호흡과 어깨 긴장 완화 루틴이 도움이 됩니다.',
  '수': '순환 관리와 충분한 휴식이 필요합니다.',
};
const messages = {
  '목': '작은 실행을 시작하면 흐름이 빠르게 살아납니다.',
  '화': '주도적으로 움직일수록 기회가 선명해집니다.',
  '토': '기본을 정리하면 성과가 안정적으로 따라옵니다.',
  '금': '디테일 점검이 리스크를 줄이고 성과를 높입니다.',
  '수': '유연한 대응이 예상 밖의 기회를 만듭니다.',
};
const colors = {
  '목': ['에메랄드', '아이보리'],
  '화': ['코랄', '골드'],
  '토': ['베이지', '브라운'],
  '금': ['실버', '네이비'],
  '수': ['블루', '블랙'],
};
const times = ['오전 7-9시','오전 9-11시','오후 1-3시','오후 2-4시','오후 6-8시','저녁 7-9시'];

function score(seed, min = 72, max = 94) {
  const span = max - min + 1;
  return min + (seed % span);
}

const patterns = [];
for (let i = 0; i < 100; i += 1) {
  const e = elements[i % elements.length];
  const base = i + 1;
  const overall = score(base * 13);
  const love = score(base * 17, 70, 95);
  const money = score(base * 19, 68, 96);
  const healthScore = score(base * 23, 69, 95);
  const work = score(base * 29, 70, 97);

  patterns.push({
    id: base,
    pattern: {
      year_gan: gan[base % gan.length],
      year_ji: ji[base % ji.length],
      month_gan: gan[(base + 2) % gan.length],
      month_ji: ji[(base + 2) % ji.length],
      day_gan: gan[(base + 4) % gan.length],
      day_ji: ji[(base + 4) % ji.length],
      hour_gan: gan[(base + 6) % gan.length],
      hour_ji: ji[(base + 6) % ji.length],
    },
    gender: '공통',
    result: {
      personality: `${e} 기운이 강해 균형 감각과 실행력이 돋보입니다.`,
      career: careers[e],
      wealth: wealth[e],
      health: health[e],
      message: messages[e],
      luckyColor: colors[e],
      luckyNumber: [((base % 9) + 1), (((base + 3) % 9) + 1), (((base + 6) % 9) + 1)],
      luckyTime: times[base % times.length],
      overallScore: overall,
      loveScore: love,
      moneyScore: money,
      healthScore,
      workScore: work,
    },
  });
}

const outPath = path.resolve(__dirname, '../assets/data/saju_patterns.json');
fs.writeFileSync(outPath, JSON.stringify(patterns, null, 2) + '\n', 'utf8');
console.log(`Generated ${patterns.length} patterns to ${outPath}`);
