export interface TagInfo {
  token: string;
  isActive: boolean;
  requiresProfile: boolean;
  profileId?: string;
}

export interface Profile {
  id: string;
  birthDate: string;
  birthTime?: string;
  birthTimeUnknown: boolean;
  isLunar: boolean;
  gender?: 'male' | 'female';
  createdAt: string;
}

export interface ProfileFormData {
  birthDate: string;
  birthTime: string;
  birthTimeUnknown: boolean;
  isLunar: boolean;
  gender: 'male' | 'female' | '';
}

export type FortuneScore = 'excellent' | 'good' | 'normal' | 'caution';

export interface FortuneSnapshot {
  date: string;
  score: FortuneScore;
  keywords: string[];
  oneLiner: string;
  preview: {
    love: string;
    money: string;
    health: string;
    work: string;
  };
}

export interface TodayReport {
  date: string;
  score: FortuneScore;
  keywords: string[];
  summary: string;
  details: {
    love: {
      score: FortuneScore;
      content: string;
      advice: string;
    };
    money: {
      score: FortuneScore;
      content: string;
      advice: string;
    };
    health: {
      score: FortuneScore;
      content: string;
      advice: string;
    };
    work: {
      score: FortuneScore;
      content: string;
      advice: string;
    };
  };
  luckyItems?: string[];
  luckyNumbers?: number[];
  isCheckedIn: boolean;
}

export interface CheckinRequest {
  token: string;
  profileId: string;
}

export interface CheckinResponse {
  success: boolean;
  todayReport: TodayReport;
  message?: string;
}

export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: {
    code: string;
    message: string;
  };
}

export interface ShareCardData {
  date: string;
  score: FortuneScore;
  keywords: string[];
  oneLiner: string;
}
