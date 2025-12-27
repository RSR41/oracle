import { STORAGE_KEYS } from './constants';

/**
 * localStorage ?좏떥由ы떚
 */

/**
 * ?꾨줈??ID ???
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
 * ?꾨줈??ID 議고쉶
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
 * ?꾨줈??ID ??젣
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
 * 留덉?留?泥댄겕???좎쭨 ???
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
 * 留덉?留?泥댄겕???좎쭨 議고쉶
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
 * ?ㅻ뒛 ?대? 泥댄겕?명뻽?붿? ?뺤씤
 */
export function hasCheckedInToday(): boolean {
  const lastCheckin = getLastCheckin();
  if (!lastCheckin) return false;
  
  const today = new Date().toISOString().split('T')[0];
  return lastCheckin === today;
}
