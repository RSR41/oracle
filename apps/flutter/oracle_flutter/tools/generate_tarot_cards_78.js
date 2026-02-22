const fs = require('fs');
const path = require('path');

const major = [
  ['The Fool', '바보'],
  ['The Magician', '마법사'],
  ['The High Priestess', '여사제'],
  ['The Empress', '여황제'],
  ['The Emperor', '황제'],
  ['The Hierophant', '교황'],
  ['The Lovers', '연인'],
  ['The Chariot', '전차'],
  ['Strength', '힘'],
  ['The Hermit', '은둔자'],
  ['Wheel of Fortune', '운명의 수레바퀴'],
  ['Justice', '정의'],
  ['The Hanged Man', '매달린 남자'],
  ['Death', '죽음'],
  ['Temperance', '절제'],
  ['The Devil', '악마'],
  ['The Tower', '탑'],
  ['The Star', '별'],
  ['The Moon', '달'],
  ['The Sun', '태양'],
  ['Judgement', '심판'],
  ['The World', '세계'],
];

const suitKo = {
  Cups: '컵',
  Pentacles: '펜타클',
  Swords: '소드',
  Wands: '완드',
};

const suitMeanings = {
  Cups: {
    upright: '감정, 관계, 공감, 정서적 흐름',
    reversed: '감정 기복, 거리감, 오해, 공허함',
    desc: '감정과 관계의 균형을 점검할 시기입니다.',
    descKo: '감정과 관계의 균형을 점검할 시기입니다.',
  },
  Pentacles: {
    upright: '재정, 현실성, 성과, 안정',
    reversed: '지연, 손실, 비효율, 불안정',
    desc: '현실적인 계획이 결과를 만듭니다.',
    descKo: '현실적인 계획이 결과를 만듭니다.',
  },
  Swords: {
    upright: '판단, 명료성, 결단, 이성',
    reversed: '혼란, 과잉분석, 갈등, 피로',
    desc: '핵심을 분리하면 판단이 쉬워집니다.',
    descKo: '핵심을 분리하면 판단이 쉬워집니다.',
  },
  Wands: {
    upright: '열정, 추진력, 창의성, 도전',
    reversed: '소진, 조급함, 방향 상실, 주저',
    desc: '행동의 우선순위를 정하면 속도가 붙습니다.',
    descKo: '행동의 우선순위를 정하면 속도가 붙습니다.',
  },
};

const rankPairs = [
  ['Ace', '에이스'],
  ['Two', '투'],
  ['Three', '쓰리'],
  ['Four', '포'],
  ['Five', '파이브'],
  ['Six', '식스'],
  ['Seven', '세븐'],
  ['Eight', '에이트'],
  ['Nine', '나인'],
  ['Ten', '텐'],
  ['Page', '페이지'],
  ['Knight', '나이트'],
  ['Queen', '퀸'],
  ['King', '킹'],
];

const cards = [];

major.forEach((m, id) => {
  cards.push({
    id,
    name: m[0],
    nameKo: m[1],
    upright: '성장, 통찰, 전환의 기회',
    uprightKo: '성장, 통찰, 전환의 기회',
    reversed: '지연, 불균형, 재정비 필요',
    reversedKo: '지연, 불균형, 재정비 필요',
    description: '현재 흐름을 점검하고 핵심 선택에 집중하세요.',
    descriptionKo: '현재 흐름을 점검하고 핵심 선택에 집중하세요.',
  });
});

let id = 22;
['Cups', 'Pentacles', 'Swords', 'Wands'].forEach((suit) => {
  rankPairs.forEach(([en, ko]) => {
    const labelEn = `${en} of ${suit}`;
    const labelKo = `${suitKo[suit]} ${ko}`;
    cards.push({
      id,
      name: labelEn,
      nameKo: labelKo,
      upright: suitMeanings[suit].upright,
      uprightKo: suitMeanings[suit].upright,
      reversed: suitMeanings[suit].reversed,
      reversedKo: suitMeanings[suit].reversed,
      description: suitMeanings[suit].desc,
      descriptionKo: suitMeanings[suit].descKo,
    });
    id += 1;
  });
});

const outPath = path.resolve(__dirname, '../assets/data/tarot_cards.json');
fs.writeFileSync(outPath, JSON.stringify(cards, null, 2) + '\n', 'utf8');
console.log(`Generated ${cards.length} tarot cards at ${outPath}`);
