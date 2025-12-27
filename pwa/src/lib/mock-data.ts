import {
  TagInfo,
  Profile,
  ProfileFormData,
  FortuneSnapshot,
  TodayReport,
  FortuneScore,
} from '@/types';

/**
 * Mock ?곗씠???앹꽦 ?⑥닔??
 */

export function getMockTagInfo(token: string): TagInfo {
  // demo-token-123? ??긽 ?쒖꽦?? ?꾨줈???꾩슂
  if (token === 'demo-token-123') {
    return {
      token,
      isActive: true,
      requiresProfile: true,
    };
  }

  // inactive濡??쒖옉?섎㈃ 鍮꾪솢??
  if (token.startsWith('inactive')) {
    return {
      token,
      isActive: false,
      requiresProfile: false,
    };
  }

  // 洹??몃뒗 ?쒖꽦??
  return {
    token,
    isActive: true,
    requiresProfile: true,
  };
}

export function getMockFortuneSnapshot(): FortuneSnapshot {
  const today = new Date().toISOString().split('T')[0];
  
  return {
    date: today,
    score: 'good' as FortuneScore,
    keywords: ['?됱슫', '留뚮궓', '?깆옣'],
    oneLiner: '?ㅻ뒛? ?덈줈??湲고쉶瑜?留뚮궇 ???덈뒗 醫뗭? ?좎엯?덈떎.',
    preview: {
      love: '醫뗭? ?몄뿰??留뚮궇 ???덈뒗 ??.. (?꾩껜 蹂닿린)',
      money: '?щЪ?댁씠 ?곸듅?섍퀬 ?덉뒿?덈떎... (?꾩껜 蹂닿린)',
      health: '而⑤뵒??愿由ъ뿉 ?좉꼍 ?곗꽭??.. (?꾩껜 蹂닿린)',
      work: '?낅Т?먯꽌 醫뗭? ?깃낵瑜???????.. (?꾩껜 蹂닿린)',
    },
  };
}

export function getMockTodayReport(isCheckedIn: boolean): TodayReport {
  const today = new Date().toISOString().split('T')[0];
  
  return {
    date: today,
    score: 'good' as FortuneScore,
    keywords: ['?됱슫', '留뚮궓', '?깆옣'],
    summary: '?ㅻ뒛? ?꾨컲?곸쑝濡?醫뗭? 湲곗슫???먮Ⅴ???좎엯?덈떎. ?덈줈??湲고쉶瑜??곴레?곸쑝濡?諛쏆븘?ㅼ씠怨? 二쇰? ?щ엺?ㅺ낵??愿怨꾨? ?덈룆???섏꽭??',
    details: {
      love: {
        score: 'excellent' as FortuneScore,
        content: '?ㅻ뒛? ?щ옉?댁씠 理쒓퀬議곗뿉 ?ы븯???좎엯?덈떎. 醫뗭? ?몄뿰??留뚮궇 媛?μ꽦???믪쑝硫? 湲곗〈??愿怨꾨룄 ?붿슧 源딆뼱吏????덉뒿?덈떎.',
        advice: '?곴레?곸쑝濡?留덉쓬???쒗쁽?섏꽭?? ?붿쭅????붽? 愿怨꾨? 諛쒖쟾?쒗궢?덈떎.',
      },
      money: {
        score: 'good' as FortuneScore,
        content: '?щЪ?댁씠 ?곸듅?섍퀬 ?덉뒿?덈떎. ?덉긽移?紐삵븳 ?섏엯???앷만 ???덉쑝硫? ?ъ옄?????醫뗭? ?뚯떇???ㅼ쓣 ???덉뒿?덈떎.',
        advice: '異⑸룞援щℓ???먯젣?섍퀬, ?κ린?곸씤 ?ы뀒??怨꾪쉷???몄썙蹂댁꽭??',
      },
      health: {
        score: 'normal' as FortuneScore,
        content: '?꾨컲?곸쑝濡??덉젙?곸씠吏留?怨쇰줈???쇳빐???⑸땲?? 異⑸텇???댁떇怨?洹쒖튃?곸씤 ?앺솢 ?⑦꽩??以묒슂?⑸땲??',
        advice: '?ㅽ듃?덉묶怨?媛踰쇱슫 ?대룞?쇰줈 紐몄쓽 湲댁옣????댁＜?몄슂.',
      },
      work: {
        score: 'good' as FortuneScore,
        content: '?낅Т?먯꽌 醫뗭? ?깃낵瑜??????덈뒗 ?좎엯?덈떎. 李쎌쓽?곸씤 ?꾩씠?붿뼱媛 ?몄젙諛쏆쓣 ???덉쑝硫? ?묒뾽???쒖“濡?쾶 吏꾪뻾?⑸땲??',
        advice: '?숇즺?ㅺ낵???뚰넻???쒕컻???섍퀬, ?덈줈???꾨줈?앺듃???꾩쟾?대낫?몄슂.',
      },
    },
    luckyItems: ['?뚮????뚰뭹', '而ㅽ뵾', '?명듃'],
    luckyNumbers: [7, 14, 23],
    isCheckedIn,
  };
}

export function createMockProfile(formData: ProfileFormData): Profile {
  const profileId = `profile_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`;
  
  return {
    id: profileId,
    birthDate: formData.birthDate,
    birthTime: formData.birthTimeUnknown ? undefined : formData.birthTime,
    birthTimeUnknown: formData.birthTimeUnknown,
    isLunar: formData.isLunar,
    gender: formData.gender || undefined,
    createdAt: new Date().toISOString(),
  };
}
