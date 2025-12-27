# Oracle PWA Part 2 - ?ë™ ?Œì¼ ?ì„± ?¤í¬ë¦½íŠ¸
#
# ?ì„±/?˜ì •?˜ëŠ” ?Œì¼ ëª©ë¡:
# 1. pwa/src/lib/api.ts (? ê·œ)
# 2. pwa/src/lib/storage.ts (? ê·œ)
# 3. pwa/src/lib/mock-data.ts (? ê·œ)
# 4. pwa/src/lib/utils.ts (? ê·œ)
# 5. pwa/src/components/LoadingSpinner.tsx (? ê·œ)
# 6. pwa/src/components/ErrorMessage.tsx (? ê·œ)
# 7. pwa/src/components/FortuneScore.tsx (? ê·œ)
# 8. pwa/src/app/tag/[token]/page.tsx (? ê·œ)
# 9. pwa/src/app/profile/page.tsx (? ê·œ)
# 10. pwa/src/components/ProfileForm.tsx (? ê·œ)
# 11. PROJECT_STATE.md (?…ë°?´íŠ¸)
#
# ?¤í–‰ ë°©ë²•: ?ˆí¬ ë£¨íŠ¸?ì„œ .\tools\apply_pwa_part2.ps1

Write-Host "Oracle PWA Part 2 ?Œì¼ ?ì„± ?œì‘..." -ForegroundColor Green

# ?´ë” ?ì„±
$folders = @(
    "pwa/src/app/tag",
    "pwa/src/app/tag/[token]",
    "pwa/src/app/profile"
)

foreach ($folder in $folders) {
    if (-not (Test-Path -LiteralPath $folder)) {
        New-Item -ItemType Directory -LiteralPath $folder -Force | Out-Null
        Write-Host "?´ë” ?ì„±: $folder" -ForegroundColor Cyan
    }
}

# 1. pwa/src/lib/api.ts
@'
import {
  TagInfo,
  Profile,
  ProfileFormData,
  FortuneSnapshot,
  TodayReport,
  CheckinRequest,
  CheckinResponse,
  ApiResponse,
} from '@/types';
import { API_BASE_URL, MOCK_MODE, API_ENDPOINTS, ERROR_MESSAGES } from './constants';
import { getMockTagInfo, getMockFortuneSnapshot, getMockTodayReport, createMockProfile } from './mock-data';

/**
 * API ?¸ì¶œ ?˜í¼ ?¨ìˆ˜
 */
async function fetchAPI<T>(
  endpoint: string,
  options?: RequestInit
): Promise<ApiResponse<T>> {
  try {
    const url = `${API_BASE_URL}${endpoint}`;
    
    const response = await fetch(url, {
      ...options,
      headers: {
        'Content-Type': 'application/json',
        ...options?.headers,
      },
    });

    if (!response.ok) {
      const errorData = await response.json().catch(() => ({}));
      return {
        success: false,
        error: {
          code: errorData.code || 'HTTP_ERROR',
          message: errorData.message || `HTTP ${response.status}`,
        },
      };
    }

    const data = await response.json();
    return {
      success: true,
      data,
    };
  } catch (error) {
    console.error('API Error:', error);
    return {
      success: false,
      error: {
        code: 'NETWORK_ERROR',
        message: ERROR_MESSAGES.NETWORK_ERROR,
      },
    };
  }
}

/**
 * NFC ?œê·¸ ?•ë³´ ì¡°íšŒ
 */
export async function getTagInfo(token: string): Promise<ApiResponse<TagInfo>> {
  if (MOCK_MODE) {
    // Mock ëª¨ë“œ
    await new Promise(resolve => setTimeout(resolve, 500)); // ?¤íŠ¸?Œí¬ ì§€???œë??ˆì´??
    return {
      success: true,
      data: getMockTagInfo(token),
    };
  }

  const endpoint = API_ENDPOINTS.TAG_INFO.replace(':token', token);
  return fetchAPI<TagInfo>(endpoint);
}

/**
 * ?´ì„¸ ?¤ëƒ…ë·?ì¡°íšŒ (?„ë¡œ??IDë¡?
 */
export async function getFortuneSnapshot(
  profileId: string,
  token?: string
): Promise<ApiResponse<FortuneSnapshot>> {
  if (MOCK_MODE) {
    await new Promise(resolve => setTimeout(resolve, 800));
    return {
      success: true,
      data: getMockFortuneSnapshot(),
    };
  }

  const params = new URLSearchParams({ profileId });
  if (token) params.append('token', token);
  
  return fetchAPI<FortuneSnapshot>(`/public/snapshot?${params.toString()}`);
}

/**
 * ?„ë¡œ???ì„±
 */
export async function createProfile(
  formData: ProfileFormData
): Promise<ApiResponse<Profile>> {
  if (MOCK_MODE) {
    await new Promise(resolve => setTimeout(resolve, 600));
    return {
      success: true,
      data: createMockProfile(formData),
    };
  }

  return fetchAPI<Profile>(API_ENDPOINTS.CREATE_PROFILE, {
    method: 'POST',
    body: JSON.stringify({
      birthDate: formData.birthDate,
      birthTime: formData.birthTimeUnknown ? null : formData.birthTime,
      birthTimeUnknown: formData.birthTimeUnknown,
      isLunar: formData.isLunar,
      gender: formData.gender || null,
    }),
  });
}

/**
 * ì²´í¬??(?¤ë§ ?œê·¸)
 */
export async function checkin(
  request: CheckinRequest
): Promise<ApiResponse<CheckinResponse>> {
  if (MOCK_MODE) {
    await new Promise(resolve => setTimeout(resolve, 700));
    return {
      success: true,
      data: {
        success: true,
        todayReport: getMockTodayReport(true),
        message: 'ì²´í¬???„ë£Œ! ?¤ëŠ˜???„ì²´ ?´ì„¸ë¥??•ì¸?˜ì„¸??',
      },
    };
  }

  return fetchAPI<CheckinResponse>(API_ENDPOINTS.CHECKIN, {
    method: 'POST',
    body: JSON.stringify(request),
  });
}

/**
 * ?¤ëŠ˜???´ì„¸ ?„ì²´ ë¦¬í¬??ì¡°íšŒ
 */
export async function getTodayReport(
  profileId: string,
  token?: string
): Promise<ApiResponse<TodayReport>> {
  if (MOCK_MODE) {
    await new Promise(resolve => setTimeout(resolve, 900));
    // token???ˆìœ¼ë©?ì²´í¬?¸ëœ ê²ƒìœ¼ë¡?ê°„ì£¼
    return {
      success: true,
      data: getMockTodayReport(!!token),
    };
  }

  const params = new URLSearchParams({ profileId });
  if (token) params.append('token', token);
  
  return fetchAPI<TodayReport>(`${API_ENDPOINTS.TODAY_REPORT}?${params.toString()}`);
}
'@ | Out-File -LiteralPath "pwa/src/lib/api.ts" -Encoding UTF8
Write-Host "?ì„±: pwa/src/lib/api.ts" -ForegroundColor Yellow

# 2. pwa/src/lib/storage.ts
@'
import { STORAGE_KEYS } from './constants';

/**
 * localStorage ? í‹¸ë¦¬í‹°
 */

/**
 * ?„ë¡œ??ID ?€??
 */
export function saveProfileId(profileId: string): void {
  if (typeof window === 'undefined') return;
  try {
    localStorage.setItem(STORAGE_KEYS.PROFILE_ID, profileId);
  } catch (error) {
    console.error('Failed to save profile ID:', error);
  }
}

/**
 * ?„ë¡œ??ID ì¡°íšŒ
 */
export function getProfileId(): string | null {
  if (typeof window === 'undefined') return null;
  try {
    return localStorage.getItem(STORAGE_KEYS.PROFILE_ID);
  } catch (error) {
    console.error('Failed to get profile ID:', error);
    return null;
  }
}

/**
 * ?„ë¡œ??ID ?? œ
 */
export function removeProfileId(): void {
  if (typeof window === 'undefined') return;
  try {
    localStorage.removeItem(STORAGE_KEYS.PROFILE_ID);
  } catch (error) {
    console.error('Failed to remove profile ID:', error);
  }
}

/**
 * ë§ˆì?ë§?ì²´í¬??? ì§œ ?€??
 */
export function saveLastCheckin(date: string): void {
  if (typeof window === 'undefined') return;
  try {
    localStorage.setItem(STORAGE_KEYS.LAST_CHECKIN, date);
  } catch (error) {
    console.error('Failed to save last checkin:', error);
  }
}

/**
 * ë§ˆì?ë§?ì²´í¬??? ì§œ ì¡°íšŒ
 */
export function getLastCheckin(): string | null {
  if (typeof window === 'undefined') return null;
  try {
    return localStorage.getItem(STORAGE_KEYS.LAST_CHECKIN);
  } catch (error) {
    console.error('Failed to get last checkin:', error);
    return null;
  }
}

/**
 * ?¤ëŠ˜ ?´ë? ì²´í¬?¸í–ˆ?”ì? ?•ì¸
 */
export function hasCheckedInToday(): boolean {
  const lastCheckin = getLastCheckin();
  if (!lastCheckin) return false;
  
  const today = new Date().toISOString().split('T')[0];
  return lastCheckin === today;
}
'@ | Out-File -LiteralPath "pwa/src/lib/storage.ts" -Encoding UTF8
Write-Host "?ì„±: pwa/src/lib/storage.ts" -ForegroundColor Yellow

# 3. pwa/src/lib/mock-data.ts
@'
import {
  TagInfo,
  Profile,
  ProfileFormData,
  FortuneSnapshot,
  TodayReport,
  FortuneScore,
} from '@/types';

/**
 * Mock ?°ì´???ì„± ?¨ìˆ˜??
 */

export function getMockTagInfo(token: string): TagInfo {
  // demo-token-123?€ ??ƒ ?œì„±?? ?„ë¡œ???„ìš”
  if (token === 'demo-token-123') {
    return {
      token,
      isActive: true,
      requiresProfile: true,
    };
  }

  // inactiveë¡??œì‘?˜ë©´ ë¹„í™œ??
  if (token.startsWith('inactive')) {
    return {
      token,
      isActive: false,
      requiresProfile: false,
    };
  }

  // ê·??¸ëŠ” ?œì„±??
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
    keywords: ['?‰ìš´', 'ë§Œë‚¨', '?±ì¥'],
    oneLiner: '?¤ëŠ˜?€ ?ˆë¡œ??ê¸°íšŒë¥?ë§Œë‚  ???ˆëŠ” ì¢‹ì? ? ì…?ˆë‹¤.',
    preview: {
      love: 'ì¢‹ì? ?¸ì—°??ë§Œë‚  ???ˆëŠ” ??.. (?„ì²´ ë³´ê¸°)',
      money: '?¬ë¬¼?´ì´ ?ìŠ¹?˜ê³  ?ˆìŠµ?ˆë‹¤... (?„ì²´ ë³´ê¸°)',
      health: 'ì»¨ë””??ê´€ë¦¬ì— ? ê²½ ?°ì„¸??.. (?„ì²´ ë³´ê¸°)',
      work: '?…ë¬´?ì„œ ì¢‹ì? ?±ê³¼ë¥???????.. (?„ì²´ ë³´ê¸°)',
    },
  };
}

export function getMockTodayReport(isCheckedIn: boolean): TodayReport {
  const today = new Date().toISOString().split('T')[0];
  
  return {
    date: today,
    score: 'good' as FortuneScore,
    keywords: ['?‰ìš´', 'ë§Œë‚¨', '?±ì¥'],
    summary: '?¤ëŠ˜?€ ?„ë°˜?ìœ¼ë¡?ì¢‹ì? ê¸°ìš´???ë¥´??? ì…?ˆë‹¤. ?ˆë¡œ??ê¸°íšŒë¥??ê·¹?ìœ¼ë¡?ë°›ì•„?¤ì´ê³? ì£¼ë? ?¬ëŒ?¤ê³¼??ê´€ê³„ë? ?ˆë…???˜ì„¸??',
    details: {
      love: {
        score: 'excellent' as FortuneScore,
        content: '?¤ëŠ˜?€ ?¬ë‘?´ì´ ìµœê³ ì¡°ì— ?¬í•˜??? ì…?ˆë‹¤. ì¢‹ì? ?¸ì—°??ë§Œë‚  ê°€?¥ì„±???’ìœ¼ë©? ê¸°ì¡´??ê´€ê³„ë„ ?”ìš± ê¹Šì–´ì§????ˆìŠµ?ˆë‹¤.',
        advice: '?ê·¹?ìœ¼ë¡?ë§ˆìŒ???œí˜„?˜ì„¸?? ?”ì§???€?”ê? ê´€ê³„ë? ë°œì „?œí‚µ?ˆë‹¤.',
      },
      money: {
        score: 'good' as FortuneScore,
        content: '?¬ë¬¼?´ì´ ?ìŠ¹?˜ê³  ?ˆìŠµ?ˆë‹¤. ?ˆìƒì¹?ëª»í•œ ?˜ì…???ê¸¸ ???ˆìœ¼ë©? ?¬ì???€??ì¢‹ì? ?Œì‹???¤ì„ ???ˆìŠµ?ˆë‹¤.',
        advice: 'ì¶©ë™êµ¬ë§¤???ì œ?˜ê³ , ?¥ê¸°?ì¸ ?¬í…Œ??ê³„íš???¸ì›Œë³´ì„¸??',
      },
      health: {
        score: 'normal' as FortuneScore,
        content: '?„ë°˜?ìœ¼ë¡??ˆì •?ì´ì§€ë§?ê³¼ë¡œ???¼í•´???©ë‹ˆ?? ì¶©ë¶„???´ì‹ê³?ê·œì¹™?ì¸ ?í™œ ?¨í„´??ì¤‘ìš”?©ë‹ˆ??',
        advice: '?¤íŠ¸?ˆì¹­ê³?ê°€ë²¼ìš´ ?´ë™?¼ë¡œ ëª¸ì˜ ê¸´ì¥???€?´ì£¼?¸ìš”.',
      },
      work: {
        score: 'good' as FortuneScore,
        content: '?…ë¬´?ì„œ ì¢‹ì? ?±ê³¼ë¥??????ˆëŠ” ? ì…?ˆë‹¤. ì°½ì˜?ì¸ ?„ì´?”ì–´ê°€ ?¸ì •ë°›ì„ ???ˆìœ¼ë©? ?‘ì—…???œì¡°ë¡?²Œ ì§„í–‰?©ë‹ˆ??',
        advice: '?™ë£Œ?¤ê³¼???Œí†µ???œë°œ???˜ê³ , ?ˆë¡œ???„ë¡œ?íŠ¸???„ì „?´ë³´?¸ìš”.',
      },
    },
    luckyItems: ['?Œë????Œí’ˆ', 'ì»¤í”¼', '?¸íŠ¸'],
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
'@ | Out-File -LiteralPath "pwa/src/lib/mock-data.ts" -Encoding UTF8
Write-Host "?ì„±: pwa/src/lib/mock-data.ts" -ForegroundColor Yellow

# 4. pwa/src/lib/utils.ts
@'
import { FortuneScore } from '@/types';
import { FORTUNE_SCORE_LABELS } from './constants';

/**
 * ? í‹¸ë¦¬í‹° ?¨ìˆ˜??
 */

/**
 * ? ì§œë¥?YYYY-MM-DD ?•ì‹?¼ë¡œ ë³€??
 */
export function formatDateForAPI(date: Date): string {
  return date.toISOString().split('T')[0];
}

/**
 * ? ì§œë¥?"YYYY??MM??DD?? ?•ì‹?¼ë¡œ ë³€??
 */
export function formatDateForDisplay(dateString: string): string {
  const date = new Date(dateString);
  const year = date.getFullYear();
  const month = date.getMonth() + 1;
  const day = date.getDate();
  return `${year}??${month}??${day}??;
}

/**
 * ?´ì„¸ ?ìˆ˜ë¥??ˆì´ë¸”ë¡œ ë³€??
 */
export function getFortuneScoreLabel(score: FortuneScore): string {
  return FORTUNE_SCORE_LABELS[score];
}

/**
 * ?´ì„¸ ?ìˆ˜???°ë¥¸ ?´ëª¨ì§€ ë°˜í™˜
 */
export function getFortuneScoreEmoji(score: FortuneScore): string {
  const emojiMap: Record<FortuneScore, string> = {
    excellent: '?ŒŸ',
    good: '?˜Š',
    normal: '?˜',
    caution: '? ï¸',
  };
  return emojiMap[score];
}

/**
 * ?œê°„??HH:mm ?•ì‹?¼ë¡œ ë³€??
 */
export function formatTime(hour: number, minute: number): string {
  return `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}`;
}

/**
 * URL ì¿¼ë¦¬ ?Œë¼ë¯¸í„°?ì„œ ê°?ê°€?¸ì˜¤ê¸?
 */
export function getQueryParam(key: string): string | null {
  if (typeof window === 'undefined') return null;
  const params = new URLSearchParams(window.location.search);
  return params.get(key);
}
'@ | Out-File -LiteralPath "pwa/src/lib/utils.ts" -Encoding UTF8
Write-Host "?ì„±: pwa/src/lib/utils.ts" -ForegroundColor Yellow

# 5. pwa/src/components/LoadingSpinner.tsx
@'
interface LoadingSpinnerProps {
  message?: string;
  size?: 'sm' | 'md' | 'lg';
}

export default function LoadingSpinner({ 
  message = 'ë¡œë”© ì¤?..', 
  size = 'md' 
}: LoadingSpinnerProps) {
  const sizeClasses = {
    sm: 'w-8 h-8',
    md: 'w-16 h-16',
    lg: 'w-24 h-24',
  };

  return (
    <div className="flex flex-col items-center justify-center space-y-4">
      <div className={`${sizeClasses[size]} spinner`}></div>
      {message && <p className="text-gray-600 text-sm">{message}</p>}
    </div>
  );
}
'@ | Out-File -LiteralPath "pwa/src/components/LoadingSpinner.tsx" -Encoding UTF8
Write-Host "?ì„±: pwa/src/components/LoadingSpinner.tsx" -ForegroundColor Yellow

# 6. pwa/src/components/ErrorMessage.tsx
@'
interface ErrorMessageProps {
  message: string;
  onRetry?: () => void;
}

export default function ErrorMessage({ message, onRetry }: ErrorMessageProps) {
  return (
    <div className="card border-2 border-red-200 bg-red-50">
      <div className="flex items-start space-x-3">
        <span className="text-2xl">? ï¸</span>
        <div className="flex-1">
          <h3 className="font-semibold text-red-900 mb-2">?¤ë¥˜ê°€ ë°œìƒ?ˆìŠµ?ˆë‹¤</h3>
          <p className="text-sm text-red-700 mb-4">{message}</p>
          {onRetry && (
            <button onClick={onRetry} className="btn-secondary text-sm">
              ?¤ì‹œ ?œë„
            </button>
          )}
        </div>
      </div>
    </div>
  );
}
'@ | Out-File -LiteralPath "pwa/src/components/ErrorMessage.tsx" -Encoding UTF8
Write-Host "?ì„±: pwa/src/components/ErrorMessage.tsx" -ForegroundColor Yellow

# 7. pwa/src/components/FortuneScore.tsx
@'
import { FortuneScore as FortuneScoreType } from '@/types';
import { getFortuneScoreLabel, getFortuneScoreEmoji } from '@/lib/utils';
import { FORTUNE_SCORE_COLORS, FORTUNE_SCORE_BG_COLORS } from '@/lib/constants';

interface FortuneScoreProps {
  score: FortuneScoreType;
  size?: 'sm' | 'md' | 'lg';
  showLabel?: boolean;
}

export default function FortuneScore({ 
  score, 
  size = 'md',
  showLabel = true 
}: FortuneScoreProps) {
  const emoji = getFortuneScoreEmoji(score);
  const label = getFortuneScoreLabel(score);
  const colorClass = FORTUNE_SCORE_COLORS[score];
  const bgColorClass = FORTUNE_SCORE_BG_COLORS[score];

  const sizeClasses = {
    sm: 'text-sm px-3 py-1',
    md: 'text-base px-4 py-2',
    lg: 'text-lg px-6 py-3',
  };

  const emojiSizes = {
    sm: 'text-base',
    md: 'text-xl',
    lg: 'text-2xl',
  };

  return (
    <div className={`inline-flex items-center space-x-2 ${sizeClasses[size]} rounded-full ${bgColorClass} bg-opacity-10`}>
      <span className={emojiSizes[size]}>{emoji}</span>
      {showLabel && (
        <span className={`font-semibold ${colorClass}`}>
          {label}
        </span>
      )}
    </div>
  );
}
'@ | Out-File -LiteralPath "pwa/src/components/FortuneScore.tsx" -Encoding UTF8
Write-Host "?ì„±: pwa/src/components/FortuneScore.tsx" -ForegroundColor Yellow

# 8. pwa/src/app/tag/[token]/page.tsx
@'
'use client';

import { useEffect, useState } from 'react';
import { useRouter, useParams } from 'next/navigation';
import Link from 'next/link';
import { getTagInfo, getFortuneSnapshot } from '@/lib/api';
import { getProfileId } from '@/lib/storage';
import { TagInfo, FortuneSnapshot } from '@/types';
import LoadingSpinner from '@/components/LoadingSpinner';
import ErrorMessage from '@/components/ErrorMessage';
import FortuneScore from '@/components/FortuneScore';
import { formatDateForDisplay } from '@/lib/utils';

export default function TagPage() {
  const router = useRouter();
  const params = useParams();
  const token = params.token as string;

  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [tagInfo, setTagInfo] = useState<TagInfo | null>(null);
  const [snapshot, setSnapshot] = useState<FortuneSnapshot | null>(null);

  useEffect(() => {
    loadTagData();
  }, [token]);

  async function loadTagData() {
    setLoading(true);
    setError(null);

    // 1. ?œê·¸ ?•ë³´ ì¡°íšŒ
    const tagResponse = await getTagInfo(token);
    if (!tagResponse.success || !tagResponse.data) {
      setError(tagResponse.error?.message || '?œê·¸ ?•ë³´ë¥?ë¶ˆëŸ¬?????†ìŠµ?ˆë‹¤');
      setLoading(false);
      return;
    }

    const tagData = tagResponse.data;
    setTagInfo(tagData);

    // 2. ë¹„í™œ???œê·¸ ì²´í¬
    if (!tagData.isActive) {
      setError('ë¹„í™œ?±í™”???œê·¸?…ë‹ˆ?? ê³ ê°?¼í„°??ë¬¸ì˜?´ì£¼?¸ìš”.');
      setLoading(false);
      return;
    }

    // 3. ?„ë¡œ???•ì¸
    const profileId = getProfileId();
    if (!profileId && tagData.requiresProfile) {
      // ?„ë¡œ?„ì´ ?†ìœ¼ë©??„ë¡œ???…ë ¥ ?˜ì´ì§€ë¡??´ë™
      router.push(`/profile?token=${token}`);
      return;
    }

    // 4. ?´ì„¸ ?¤ëƒ…ë·?ì¡°íšŒ
    if (profileId) {
      const snapshotResponse = await getFortuneSnapshot(profileId, token);
      if (snapshotResponse.success && snapshotResponse.data) {
        setSnapshot(snapshotResponse.data);
      } else {
        setError(snapshotResponse.error?.message || '?´ì„¸ë¥?ë¶ˆëŸ¬?????†ìŠµ?ˆë‹¤');
      }
    }

    setLoading(false);
  }

  if (loading) {
    return (
      <main className="min-h-screen flex items-center justify-center p-6">
        <LoadingSpinner message="?´ì„¸ë¥?ë¶ˆëŸ¬?¤ëŠ” ì¤?.." size="lg" />
      </main>
    );
  }

  if (error) {
    return (
      <main className="min-h-screen flex items-center justify-center p-6">
        <div className="max-w-md w-full space-y-6">
          <ErrorMessage message={error} onRetry={loadTagData} />
          <Link href="/" className="block btn-secondary text-center">
            ?ˆìœ¼ë¡??Œì•„ê°€ê¸?
          </Link>
        </div>
      </main>
    );
  }

  if (!snapshot) {
    return null;
  }

  return (
    <main className="min-h-screen p-6 pb-24">
      <div className="max-w-md mx-auto space-y-6">
        {/* ?¤ë” */}
        <div className="text-center space-y-2">
          <p className="text-sm text-gray-600">
            {formatDateForDisplay(snapshot.date)}
          </p>
          <h1 className="text-2xl font-bold text-gray-900">
            ?¤ëŠ˜???´ì„¸
          </h1>
        </div>

        {/* ?´ì„¸ ?ìˆ˜ */}
        <div className="card text-center space-y-4">
          <FortuneScore score={snapshot.score} size="lg" />
          <p className="text-lg text-gray-900 font-medium">
            {snapshot.oneLiner}
          </p>
        </div>

        {/* ?¤ì›Œ??*/}
        <div className="card">
          <h2 className="text-sm font-semibold text-gray-700 mb-3">?¤ëŠ˜???¤ì›Œ??/h2>
          <div className="flex flex-wrap gap-2">
            {snapshot.keywords.map((keyword, index) => (
              <span
                key={index}
                className="px-4 py-2 bg-primary-100 text-primary-700 rounded-full text-sm font-medium"
              >
                #{keyword}
              </span>
            ))}
          </div>
        </div>

        {/* ë¯¸ë¦¬ë³´ê¸° */}
        <div className="space-y-3">
          <h2 className="text-lg font-bold text-gray-900">?¸ë? ?´ì„¸ ë¯¸ë¦¬ë³´ê¸°</h2>
          
          <div className="card space-y-4">
            <PreviewItem icon="?’•" title="? ì •?? content={snapshot.preview.love} />
            <PreviewItem icon="?’°" title="ê¸ˆì „?? content={snapshot.preview.money} />
            <PreviewItem icon="?’ª" title="ê±´ê°•?? content={snapshot.preview.health} />
            <PreviewItem icon="?’¼" title="ì§ì—…?? content={snapshot.preview.work} />
          </div>
        </div>

        {/* CTA - ?„ì²´ ë³´ê¸° */}
        <div className="card bg-gradient-to-br from-primary-500 to-primary-700 text-white text-center space-y-4">
          <div className="space-y-2">
            <p className="text-2xl">?</p>
            <h3 className="text-lg font-bold">?¤ë§ ?Œìœ ???„ìš© ?œíƒ</h3>
            <p className="text-sm opacity-90">
              ì²´í¬?¸í•˜ê³??¤ëŠ˜???„ì²´ ?´ì„¸ë¥??•ì¸?˜ì„¸??
            </p>
          </div>
          <Link
            href={`/result/today?token=${token}`}
            className="block w-full bg-white text-primary-600 px-6 py-3 rounded-lg font-semibold hover:bg-gray-50 transition-colors"
          >
            ?¤ëŠ˜ ?„ì²´ ë³´ê¸° (ì²´í¬??
          </Link>
        </div>

        {/* ?¤ë½/ì°¸ê³ ??ê³ ì? */}
        <p className="text-xs text-gray-500 text-center">
          ë³??œë¹„?¤ëŠ” ?¤ë½ ë°?ì°¸ê³ ?©ìœ¼ë¡??œê³µ?©ë‹ˆ??
        </p>
      </div>
    </main>
  );
}

function PreviewItem({ icon, title, content }: { icon: string; title: string; content: string }) {
  return (
    <div className="flex items-start space-x-3 pb-4 border-b border-gray-100 last:border-0 last:pb-0">
      <span className="text-2xl">{icon}</span>
      <div className="flex-1">
        <h4 className="font-semibold text-gray-900 mb-1">{title}</h4>
        <p className="text-sm text-gray-600">{content}</p>
      </div>
    </div>
  );
}
'@ | Out-File -LiteralPath "pwa/src/app/tag/[token]/page.tsx" -Encoding UTF8
Write-Host "?ì„±: pwa/src/app/tag/[token]/page.tsx" -ForegroundColor Yellow

# 9. pwa/src/app/profile/page.tsx
@'
'use client';

import { useState, useEffect } from 'react';
import { useRouter, useSearchParams } from 'next/navigation';
import ProfileForm from '@/components/ProfileForm';
import { getProfileId } from '@/lib/storage';

export default function ProfilePage() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const token = searchParams.get('token');
  
  const [hasExistingProfile, setHasExistingProfile] = useState(false);

  useEffect(() => {
    const existingProfileId = getProfileId();
    setHasExistingProfile(!!existingProfileId);
  }, []);

  function handleSuccess() {
    if (token) {
      // ?œê·¸?ì„œ ?”ìœ¼ë©??¤ì‹œ ?œê·¸ ?˜ì´ì§€ë¡?
      router.push(`/tag/${token}`);
    } else {
      // ì§ì ‘ ?‘ì†?ˆìœ¼ë©??ˆìœ¼ë¡?
      router.push('/');
    }
  }

  return (
    <main className="min-h-screen p-6 pb-24">
      <div className="max-w-md mx-auto space-y-6">
        {/* ?¤ë” */}
        <div className="text-center space-y-2">
          <div className="w-16 h-16 mx
          -auto bg-gradient-to-br from-primary-500 to-primary-700 rounded-full flex items-center justify-center">
<span className="text-2xl">?“</span>
</div>
<h1 className="text-2xl font-bold text-gray-900">
{hasExistingProfile ? '?„ë¡œ???˜ì •' : '?„ë¡œ???…ë ¥'}
</h1>
<p className="text-sm text-gray-600">
?•í™•???´ì„¸ ë¶„ì„???„í•´<br />
?ë…„?”ì¼ ?•ë³´ë¥??…ë ¥?´ì£¼?¸ìš”
</p>
</div>
    {/* ?„ë¡œ????*/}
    <ProfileForm onSuccess={handleSuccess} />

    {/* ê°œì¸?•ë³´ ë³´í˜¸ ?ˆë‚´ */}
    <div className="card-bordered bg-blue-50 border-blue-200">
      <div className="flex items-start space-x-3">
        <span className="text-xl">?”’</span>
        <div className="flex-1 space-y-2">
          <h3 className="font-semibold text-gray-900 text-sm">ê°œì¸?•ë³´ ë³´í˜¸</h3>
          <ul className="text-xs text-gray-600 space-y-1">
            <li>???…ë ¥?˜ì‹  ?•ë³´???´ì„¸ ë¶„ì„?ë§Œ ?¬ìš©?©ë‹ˆ??/li>
            <li>??NFC ?œê·¸?ëŠ” ê°œì¸?•ë³´ê°€ ?€?¥ë˜ì§€ ?ŠìŠµ?ˆë‹¤</li>
            <li>???¸ì œ? ì? ?„ë¡œ?„ì„ ?˜ì •/?? œ?????ˆìŠµ?ˆë‹¤</li>
          </ul>
        </div>
      </div>
    </div>

    {/* ?¤ë½/ì°¸ê³ ??ê³ ì? */}
    <p className="text-xs text-gray-500 text-center">
      ë³??œë¹„?¤ëŠ” ?¤ë½ ë°?ì°¸ê³ ?©ìœ¼ë¡??œê³µ?©ë‹ˆ??
    </p>
  </div>
</main>
);
}
'@ | Out-File -LiteralPath "pwa/src/app/profile/page.tsx" -Encoding UTF8
Write-Host "?ì„±: pwa/src/app/profile/page.tsx" -ForegroundColor Yellow

# 10. pwa/src/components/ProfileForm.tsx
@'
'use client';

import { useState } from 'react';
import { ProfileFormData } from '@/types';
import { createProfile } from '@/lib/api';
import { saveProfileId } from '@/lib/storage';
import LoadingSpinner from './LoadingSpinner';
import ErrorMessage from './ErrorMessage';
interface ProfileFormProps {
onSuccess: () => void;
}
export default function ProfileForm({ onSuccess }: ProfileFormProps) {
const [formData, setFormData] = useState<ProfileFormData>({
birthDate: '',
birthTime: '12:00',
birthTimeUnknown: false,
isLunar: false,
gender: '',
});
const [loading, setLoading] = useState(false);
const [error, setError] = useState<string | null>(null);
function handleChange(field: keyof ProfileFormData, value: any) {
setFormData(prev => ({
...prev,
[field]: value,
}));
}
async function handleSubmit(e: React.FormEvent) {
e.preventDefault();
// ? íš¨??ê²€??
if (!formData.birthDate) {
  setError('?ë…„?”ì¼???…ë ¥?´ì£¼?¸ìš”');
  return;
}

setLoading(true);
setError(null);

try {
  const response = await createProfile(formData);
  
  if (response.success && response.data) {
    // ?„ë¡œ??ID ?€??
    saveProfileId(response.data.id);
    
    // ?±ê³µ ì½œë°±
    onSuccess();
  } else {
    setError(response.error?.message || '?„ë¡œ???ì„±???¤íŒ¨?ˆìŠµ?ˆë‹¤');
  }
} catch (err) {
  setError('?????†ëŠ” ?¤ë¥˜ê°€ ë°œìƒ?ˆìŠµ?ˆë‹¤');
} finally {
  setLoading(false);
}
}
if (loading) {
return (
<div className="card">
<LoadingSpinner message="?„ë¡œ???€??ì¤?.." />
</div>
);
}
return (
<form onSubmit={handleSubmit} className="space-y-6">
{error && <ErrorMessage message={error} />}
  <div className="card space-y-5">
    {/* ?ë…„?”ì¼ */}
    <div>
      <label className="label">
        ?ë…„?”ì¼ <span className="text-red-500">*</span>
      </label>
      <input
        type="date"
        value={formData.birthDate}
        onChange={(e) => handleChange('birthDate', e.target.value)}
        className="input-field"
        max={new Date().toISOString().split('T')[0]}
        required
      />
    </div>

    {/* ?‘ë ¥/?Œë ¥ */}
    <div>
      <label className="label">?¬ë ¥ ì¢…ë¥˜</label>
      <div className="flex space-x-4">
        <label className="flex items-center space-x-2 cursor-pointer">
          <input
            type="radio"
            checked={!formData.isLunar}
            onChange={() => handleChange('isLunar', false)}
            className="w-4 h-4"
          />
          <span className="text-sm">?‘ë ¥</span>
        </label>
        <label className="flex items-center space-x-2 cursor-pointer">
          <input
            type="radio"
            checked={formData.isLunar}
            onChange={() => handleChange('isLunar', true)}
            className="w-4 h-4"
          />
          <span className="text-sm">?Œë ¥</span>
        </label>
      </div>
    </div>

    {/* ?œì–´???œê°„ */}
    <div>
      <label className="label">?œì–´???œê°„ (? íƒ)</label>
      <input
        type="time"
        value={formData.birthTime}
        onChange={(e) => handleChange('birthTime', e.target.value)}
        className="input-field"
        disabled={formData.birthTimeUnknown}
      />
      <label className="flex items-center space-x-2 mt-2 cursor-pointer">
        <input
          type="checkbox"
          checked={formData.birthTimeUnknown}
          onChange={(e) => handleChange('birthTimeUnknown', e.target.checked)}
          className="w-4 h-4"
        />
        <span className="text-sm text-gray-600">?œê°„??ëª¨ë¦…?ˆë‹¤</span>
      </label>
    </div>

    {/* ?±ë³„ */}
    <div>
      <label className="label">?±ë³„ (? íƒ)</label>
      <div className="flex space-x-4">
        <label className="flex items-center space-x-2 cursor-pointer">
          <input
            type="radio"
            checked={formData.gender === 'male'}
            onChange={() => handleChange('gender', 'male')}
            className="w-4 h-4"
          />
          <span className="text-sm">?¨ì„±</span>
        </label>
        <label className="flex items-center space-x-2 cursor-pointer">
          <input
            type="radio"
            checked={formData.gender === 'female'}
            onChange={() => handleChange('gender', 'female')}
            className="w-4 h-4"
          />
          <span className="text-sm">?¬ì„±</span>
        </label>
        <label className="flex items-center space-x-2 cursor-pointer">
          <input
            type="radio"
            checked={formData.gender === ''}
            onChange={() => handleChange('gender', '')}
            className="w-4 h-4"
          />
          <span className="text-sm">? íƒ ????/span>
        </label>
      </div>
    </div>
  </div>

  {/* ?œì¶œ ë²„íŠ¼ */}
  <button type="submit" className="w-full btn-primary" disabled={loading}>
    {loading ? '?€??ì¤?..' : '?€?¥í•˜ê³?ê³„ì†?˜ê¸°'}
  </button>
</form>
);
}
'@ | Out-File -LiteralPath "pwa/src/components/ProfileForm.tsx" -Encoding UTF8
Write-Host "?ì„±: pwa/src/components/ProfileForm.tsx" -ForegroundColor Yellow
