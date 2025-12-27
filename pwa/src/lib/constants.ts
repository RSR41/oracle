export const API_BASE_URL = process.env.NEXT_PUBLIC_API_BASE_URL || 'http://localhost:3001';
export const MOCK_MODE = process.env.NEXT_PUBLIC_MOCK_MODE === 'true';
export const APP_DOMAIN = process.env.NEXT_PUBLIC_APP_DOMAIN || 'https://YOUR_DOMAIN';

export const STORAGE_KEYS = {
  PROFILE_ID: 'oracle_profile_id',
  LAST_CHECKIN: 'oracle_last_checkin',
} as const;

export const FORTUNE_SCORE_LABELS = {
  excellent: '理쒓퀬???섎（',
  good: '醫뗭? ?섎（',
  normal: '?됰쾾???섎（',
  caution: '議곗떖?ㅻ윭???섎（',
} as const;

export const FORTUNE_SCORE_COLORS = {
  excellent: 'text-fortune-excellent',
  good: 'text-fortune-good',
  normal: 'text-fortune-normal',
  caution: 'text-fortune-caution',
} as const;

export const FORTUNE_SCORE_BG_COLORS = {
  excellent: 'bg-fortune-excellent',
  good: 'bg-fortune-good',
  normal: 'bg-fortune-normal',
  caution: 'bg-fortune-caution',
} as const;

export const API_ENDPOINTS = {
  TAG_INFO: '/public/tag/:token',
  CREATE_PROFILE: '/public/profile',
  CHECKIN: '/public/checkin',
  TODAY_REPORT: '/public/today-report',
} as const;

export const ERROR_MESSAGES = {
  NETWORK_ERROR: '?ㅽ듃?뚰겕 ?곌껐???뺤씤?댁＜?몄슂',
  INVALID_TOKEN: '?좏슚?섏? ?딆? ?쒓렇?낅땲??,
  INACTIVE_TOKEN: '鍮꾪솢?깊솕???쒓렇?낅땲??,
  PROFILE_REQUIRED: '?꾨줈???뺣낫瑜?癒쇱? ?낅젰?댁＜?몄슂',
  CHECKIN_FAILED: '泥댄겕?몄뿉 ?ㅽ뙣?덉뒿?덈떎',
  UNKNOWN_ERROR: '?????녿뒗 ?ㅻ쪟媛 諛쒖깮?덉뒿?덈떎',
} as const;

export const DATE_FORMAT = {
  DISPLAY: 'YYYY??MM??DD??,
  API: 'YYYY-MM-DD',
} as const;
