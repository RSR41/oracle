import { FortuneScore } from '@/types';
import { FORTUNE_SCORE_LABELS } from './constants';

/**
 * ?좏떥由ы떚 ?⑥닔??
 */

/**
 * ?좎쭨瑜?YYYY-MM-DD ?뺤떇?쇰줈 蹂??
 */
export function formatDateForAPI(date: Date): string {
  return date.toISOString().split('T')[0];
}

/**
 * ?좎쭨瑜?"YYYY??MM??DD?? ?뺤떇?쇰줈 蹂??
 */
export function formatDateForDisplay(dateString: string): string {
  const date = new Date(dateString);
  const year = date.getFullYear();
  const month = date.getMonth() + 1;
  const day = date.getDate();
  return `${year}??${month}??${day}??;
}

/**
 * ?댁꽭 ?먯닔瑜??덉씠釉붾줈 蹂??
 */
export function getFortuneScoreLabel(score: FortuneScore): string {
  return FORTUNE_SCORE_LABELS[score];
}

/**
 * ?댁꽭 ?먯닔???곕Ⅸ ?대え吏 諛섑솚
 */
export function getFortuneScoreEmoji(score: FortuneScore): string {
  const emojiMap: Record<FortuneScore, string> = {
    excellent: '?뙚',
    good: '?삃',
    normal: '?삉',
    caution: '?좑툘',
  };
  return emojiMap[score];
}

/**
 * ?쒓컙??HH:mm ?뺤떇?쇰줈 蹂??
 */
export function formatTime(hour: number, minute: number): string {
  return `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}`;
}

/**
 * URL 荑쇰━ ?뚮씪誘명꽣?먯꽌 媛?媛?몄삤湲?
 */
export function getQueryParam(key: string): string | null {
  if (typeof window === 'undefined') return null;
  const params = new URLSearchParams(window.location.search);
  return params.get(key);
}
