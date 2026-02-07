export type HistoryType = 'fortune' | 'compat' | 'tarot' | 'face' | 'dream';

export interface HistoryItem {
  id: string;
  type: HistoryType;
  title: string;
  dateLabel: string;
  score?: number;
  summary?: string;
  payload: any;
  createdAt: number;
}

export const createHistoryItem = (
  type: HistoryType,
  title: string,
  payload: any,
  score?: number,
  summary?: string
): HistoryItem => {
  const now = Date.now();
  const date = new Date(now);
  const dateLabel = `${date.getFullYear()}.${String(date.getMonth() + 1).padStart(2, '0')}.${String(date.getDate()).padStart(2, '0')}`;
  
  return {
    id: `${type}-${now}`,
    type,
    title,
    dateLabel,
    score,
    summary,
    payload,
    createdAt: now,
  };
};
