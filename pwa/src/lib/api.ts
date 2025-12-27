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
 * API ?몄텧 ?섑띁 ?⑥닔
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
 * NFC ?쒓렇 ?뺣낫 議고쉶
 */
export async function getTagInfo(token: string): Promise<ApiResponse<TagInfo>> {
  if (MOCK_MODE) {
    // Mock 紐⑤뱶
    await new Promise(resolve => setTimeout(resolve, 500)); // ?ㅽ듃?뚰겕 吏???쒕??덉씠??
    return {
      success: true,
      data: getMockTagInfo(token),
    };
  }

  const endpoint = API_ENDPOINTS.TAG_INFO.replace(':token', token);
  return fetchAPI<TagInfo>(endpoint);
}

/**
 * ?댁꽭 ?ㅻ깄酉?議고쉶 (?꾨줈??ID濡?
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
 * ?꾨줈???앹꽦
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
 * 泥댄겕??(?ㅻ쭅 ?쒓렇)
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
        message: '泥댄겕???꾨즺! ?ㅻ뒛???꾩껜 ?댁꽭瑜??뺤씤?섏꽭??',
      },
    };
  }

  return fetchAPI<CheckinResponse>(API_ENDPOINTS.CHECKIN, {
    method: 'POST',
    body: JSON.stringify(request),
  });
}

/**
 * ?ㅻ뒛???댁꽭 ?꾩껜 由ы룷??議고쉶
 */
export async function getTodayReport(
  profileId: string,
  token?: string
): Promise<ApiResponse<TodayReport>> {
  if (MOCK_MODE) {
    await new Promise(resolve => setTimeout(resolve, 900));
    // token???덉쑝硫?泥댄겕?몃맂 寃껋쑝濡?媛꾩＜
    return {
      success: true,
      data: getMockTodayReport(!!token),
    };
  }

  const params = new URLSearchParams({ profileId });
  if (token) params.append('token', token);
  
  return fetchAPI<TodayReport>(`${API_ENDPOINTS.TODAY_REPORT}?${params.toString()}`);
}
