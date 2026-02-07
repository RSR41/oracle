import React, { createContext, useContext, useState, useEffect } from 'react';
import { HistoryItem } from '@/app/models/history';

type Language = 'ko' | 'en';
type Theme = 'light' | 'dark' | 'system';

interface AppContextType {
  language: Language;
  setLanguage: (lang: Language) => void;
  theme: Theme;
  setTheme: (theme: Theme) => void;
  t: (key: string) => string;
  historyItems: HistoryItem[];
  addHistoryItem: (item: HistoryItem) => void;
  removeHistoryItem: (id: string) => void;
  clearHistory: () => void;
}

const translations = {
  ko: {
    // Navigation
    'nav.home': '홈',
    'nav.fortune': '운세',
    'nav.compatibility': '궁합',
    'nav.history': '히스토리',
    'nav.profile': '내정보',
    
    // Home
    'home.title': 'Oracle',
    'home.todayFortune': '오늘의 운세',
    'home.todayScore': '오늘의 운',
    'home.viewDetail': '자세히 보기',
    'home.recommended': '추천',
    'home.todayConnection': '오늘의 인연',
    'home.connectionDesc': '당신과 잘 맞는 분들을 소개해드려요',
    'home.startConnection': '인연 보기',
    'home.consultation': '전문 상담',
    'home.consultationDesc': '전문가와 1:1 상담을 받아보세요',
    'home.viewConsultants': '상담사 보기',
    'home.loveCompatibility': '연애궁합',
    'home.compatibility': '궁합',
    'home.tarot': '타로',
    'home.dream': '꿈해몽',
    'home.face': '관상',
    
    // Fortune
    'fortune.today': '오늘의 운세',
    'fortune.calendar': '만세력',
    'fortune.analysis': '사주분석',
    'fortune.tarot': '타로',
    'fortune.dream': '꿈해몽',
    'fortune.viewResult': '결과 보기',
    'fortune.checkFortune': '운세 보기',
    'fortune.checkTarot': '타로 보기',
    'fortune.interpretDream': '꿈해몽하기',
    
    // Compatibility
    'compat.title': '궁합',
    'compat.check': '궁합 보기',
    'compat.partner': '상대방 정보',
    'compat.enterPartner': '상대방 입력',
    'compat.score': '궁합 점수',
    'compat.love': '연애 궁합',
    'compat.friend': '친구 궁합',
    'compat.business': '비즈니스 궁합',
    'compat.viewMore': '더보기',
    'compat.findSimilar': '비슷한 성향의 사람 보기',
    
    // Face Reading
    'face.title': '관상',
    'face.upload': '사진 업로드',
    'face.analyze': '분석하기',
    'face.result': '분석 결과',
    'face.generateIdeal': '이상형 생성',
    'face.idealType': '이상형 생성',
    
    // Ideal Type
    'ideal.title': '이상형 생성',
    'ideal.generating': '이상형 생성 중...',
    'ideal.result': '생성 결과',
    'ideal.regenerate': '재생성',
    'ideal.save': '저장',
    'ideal.share': '공유',
    'ideal.purpose': '관계 목적',
    'ideal.friend': '친구',
    'ideal.lover': '연인',
    'ideal.style': '이미지 스타일',
    'ideal.realistic': '실사',
    'ideal.illustration': '일러스트',
    'ideal.mood': '분위기',
    'ideal.warm': '따뜻한',
    'ideal.chic': '시크한',
    
    // Connection (Hidden Social)
    'connection.title': '인연',
    'connection.beta': '베타',
    'connection.recommendations': '추천',
    'connection.likes': '좋아요',
    'connection.matches': '매칭',
    'connection.chat': '채팅',
    'connection.like': '좋아요',
    'connection.pass': '패스',
    'connection.compatScore': '궁합',
    
    // Settings
    'settings.title': '설정',
    'settings.appearance': '테마',
    'settings.language': '언어',
    'settings.notifications': '알림',
    'settings.privacy': '개인정보',
    'settings.theme.light': '라이트',
    'settings.theme.dark': '다크',
    'settings.theme.system': '시스템',
    'settings.deleteData': '데이터 삭제',
    'settings.connectionFeature': '인연 기능',
    
    // Common
    'common.save': '저장',
    'common.share': '공유',
    'common.cancel': '취소',
    'common.confirm': '확인',
    'common.delete': '삭제',
    'common.edit': '수정',
    'common.close': '닫기',
    'common.back': '뒤로',
    'common.next': '다음',
    'common.loading': '로딩 중...',
    'common.error': '오류가 발생했습니다',
    'common.retry': '다시 시도',
    'common.new': '새로운',
    'common.recommended': '추천',
    'common.entertainment': '* 오락 및 참고용입니다',
  },
  en: {
    // Navigation
    'nav.home': 'Home',
    'nav.fortune': 'Fortune',
    'nav.compatibility': 'Compatibility',
    'nav.history': 'History',
    'nav.profile': 'Profile',
    
    // Home
    'home.title': 'Oracle',
    'home.todayFortune': "Today's Fortune",
    'home.todayScore': "Today's Luck",
    'home.viewDetail': 'View Details',
    'home.recommended': 'Recommended',
    'home.todayConnection': "Today's Connection",
    'home.connectionDesc': 'Meet people who match with you',
    'home.startConnection': 'View Connections',
    'home.consultation': 'Expert Consultation',
    'home.consultationDesc': 'Get 1:1 consultation with experts',
    'home.viewConsultants': 'View Consultants',
    'home.loveCompatibility': 'Love Match',
    'home.compatibility': 'Compatibility',
    'home.tarot': 'Tarot',
    'home.dream': 'Dream',
    'home.face': 'Face',
    
    // Fortune
    'fortune.today': "Today's Fortune",
    'fortune.calendar': 'Calendar',
    'fortune.analysis': 'Saju Analysis',
    'fortune.tarot': 'Tarot',
    'fortune.dream': 'Dream',
    'fortune.viewResult': 'View Result',
    'fortune.checkFortune': 'Check Fortune',
    'fortune.checkTarot': 'Read Tarot',
    'fortune.interpretDream': 'Interpret Dream',
    
    // Compatibility
    'compat.title': 'Compatibility',
    'compat.check': 'Check Compatibility',
    'compat.partner': 'Partner Info',
    'compat.enterPartner': 'Enter Partner',
    'compat.score': 'Compatibility Score',
    'compat.love': 'Love',
    'compat.friend': 'Friend',
    'compat.business': 'Business',
    'compat.viewMore': 'View More',
    'compat.findSimilar': 'Find Similar People',
    
    // Face Reading
    'face.title': 'Face Reading',
    'face.upload': 'Upload Photo',
    'face.analyze': 'Analyze',
    'face.result': 'Analysis Result',
    'face.generateIdeal': 'Generate Ideal Type',
    'face.idealType': 'Ideal Type',
    
    // Ideal Type
    'ideal.title': 'Ideal Type Generator',
    'ideal.generating': 'Generating...',
    'ideal.result': 'Result',
    'ideal.regenerate': 'Regenerate',
    'ideal.save': 'Save',
    'ideal.share': 'Share',
    'ideal.purpose': 'Purpose',
    'ideal.friend': 'Friend',
    'ideal.lover': 'Lover',
    'ideal.style': 'Style',
    'ideal.realistic': 'Realistic',
    'ideal.illustration': 'Illustration',
    'ideal.mood': 'Mood',
    'ideal.warm': 'Warm',
    'ideal.chic': 'Chic',
    
    // Connection (Hidden Social)
    'connection.title': 'Connections',
    'connection.beta': 'Beta',
    'connection.recommendations': 'For You',
    'connection.likes': 'Likes',
    'connection.matches': 'Matches',
    'connection.chat': 'Chat',
    'connection.like': 'Like',
    'connection.pass': 'Pass',
    'connection.compatScore': 'Match',
    
    // Settings
    'settings.title': 'Settings',
    'settings.appearance': 'Appearance',
    'settings.language': 'Language',
    'settings.notifications': 'Notifications',
    'settings.privacy': 'Privacy',
    'settings.theme.light': 'Light',
    'settings.theme.dark': 'Dark',
    'settings.theme.system': 'System',
    'settings.deleteData': 'Delete Data',
    'settings.connectionFeature': 'Connection Feature',
    
    // Common
    'common.save': 'Save',
    'common.share': 'Share',
    'common.cancel': 'Cancel',
    'common.confirm': 'Confirm',
    'common.delete': 'Delete',
    'common.edit': 'Edit',
    'common.close': 'Close',
    'common.back': 'Back',
    'common.next': 'Next',
    'common.loading': 'Loading...',
    'common.error': 'An error occurred',
    'common.retry': 'Retry',
    'common.new': 'New',
    'common.recommended': 'Recommended',
    'common.entertainment': '* For entertainment purposes only',
  },
};

const AppContext = createContext<AppContextType | undefined>(undefined);

export const AppProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [language, setLanguage] = useState<Language>('ko');
  const [theme, setTheme] = useState<Theme>('system');
  const [historyItems, setHistoryItems] = useState<HistoryItem[]>([]);

  const t = (key: string): string => {
    return translations[language][key] || key;
  };

  // Load history from localStorage on mount
  useEffect(() => {
    try {
      const saved = localStorage.getItem('oracle_history');
      if (saved) {
        setHistoryItems(JSON.parse(saved));
      }
    } catch (error) {
      console.error('Failed to load history:', error);
    }
  }, []);

  // Save history to localStorage whenever it changes
  useEffect(() => {
    try {
      localStorage.setItem('oracle_history', JSON.stringify(historyItems));
    } catch (error) {
      console.error('Failed to save history:', error);
    }
  }, [historyItems]);

  // Apply theme to document
  useEffect(() => {
    const root = document.documentElement;
    root.classList.remove('light', 'dark');
    
    if (theme === 'system') {
      const systemTheme = window.matchMedia('(prefers-color-scheme: dark)').matches ? 'dark' : 'light';
      root.classList.add(systemTheme);
    } else {
      root.classList.add(theme);
    }
  }, [theme]);

  const addHistoryItem = (item: HistoryItem) => {
    setHistoryItems([item, ...historyItems]); // Add to beginning
  };

  const removeHistoryItem = (id: string) => {
    setHistoryItems(historyItems.filter(item => item.id !== id));
  };

  const clearHistory = () => {
    setHistoryItems([]);
  };

  return (
    <AppContext.Provider value={{ language, setLanguage, theme, setTheme, t, historyItems, addHistoryItem, removeHistoryItem, clearHistory }}>
      {children}
    </AppContext.Provider>
  );
};

export const useApp = () => {
  const context = useContext(AppContext);
  if (context === undefined) {
    throw new Error('useApp must be used within an AppProvider');
  }
  return context;
};