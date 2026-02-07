/**
 * LLM Provider 인터페이스
 * 다양한 LLM 벤더(Gemini, OpenAI, Anthropic)를 추상화
 */
export interface LLMProvider {
  /**
   * 텍스트 생성 요청
   * @param prompt 시스템/사용자 프롬프트
   * @param options 추가 옵션 (temperature, maxTokens 등)
   */
  generateText(prompt: string, options?: LLMOptions): Promise<LLMResponse>;
}

export interface LLMOptions {
  temperature?: number;      // 0.0 ~ 2.0, 기본 0.7
  maxTokens?: number;        // 최대 토큰 수
  systemPrompt?: string;     // 시스템 역할 설정
}

export interface LLMResponse {
  content: string;           // 생성된 텍스트
  model: string;             // 사용된 모델명
  usage?: {
    promptTokens: number;
    completionTokens: number;
    totalTokens: number;
  };
}

/**
 * AI 분석 결과 표준 형식
 * Flutter에서 일관되게 렌더링할 수 있도록 통일
 */
export interface AiReadingResult {
  title: string;             // 결과 제목 (예: "오늘의 사주 운세")
  summary: string;           // 짧은 요약 (1-2문장)
  details: {
    category: string;        // 분야 (예: "재물운", "연애운")
    content: string;         // 상세 내용
    rating?: number;         // 1-5 점수 (선택)
  }[];
  caution?: string;          // 주의사항 (선택)
  disclaimer: string;        // 면책 고지 (필수)
}

/**
 * AI 요청 DTO 타입들
 */
export interface SajuSummaryRequest {
  birthYear: number;
  birthMonth: number;
  birthDay: number;
  birthHour?: number;
  gender?: 'male' | 'female';
  targetDate?: string;       // 조회 날짜 (기본: 오늘)
}

export interface TarotReadingRequest {
  cards: string[];           // 뽑은 카드 목록
  question?: string;         // 질문 (선택)
  spreadType?: string;       // 배열 유형 (예: "three-card")
}

export interface DreamMeaningRequest {
  dreamDescription: string;  // 꿈 내용 서술
  keywords?: string[];       // 핵심 키워드
}

export interface FaceReadingRequest {
  // 이미지 자체는 받지 않음! (개인정보 보호)
  // Flutter에서 로컬 분석 후 특징 수치만 전송
  features: {
    eyeDistance?: number;    // 눈 간격 비율
    noseLength?: number;     // 코 길이 비율
    mouthWidth?: number;     // 입 너비 비율
    faceShape?: string;      // 얼굴형 (예: "oval", "round")
    // ... 추가 특징
  };
}
