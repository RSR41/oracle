import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import {
    LLMProvider,
    LLMOptions,
    LLMResponse,
    AiReadingResult,
    SajuSummaryRequest,
    TarotReadingRequest,
    DreamMeaningRequest,
    FaceReadingRequest,
} from './llm.types';

/**
 * LLM 서비스
 * 다양한 LLM Provider를 추상화하여 일관된 인터페이스 제공
 */
@Injectable()
export class LlmService implements LLMProvider {
    private readonly logger = new Logger(LlmService.name);
    private readonly provider: string;
    private readonly timeout: number;
    private readonly maxTokens: number;

    constructor(private readonly configService: ConfigService) {
        this.provider = this.configService.get<string>('LLM_PROVIDER', 'gemini');
        this.timeout = this.configService.get<number>('LLM_TIMEOUT_MS', 30000);
        this.maxTokens = this.configService.get<number>('LLM_MAX_TOKENS', 1024);

        this.logger.log(`LLM Provider 초기화: ${this.provider}`);
    }

    /**
     * 텍스트 생성 (저수준 API)
     */
    async generateText(prompt: string, options?: LLMOptions): Promise<LLMResponse> {
        const startTime = Date.now();

        try {
            // Provider별 분기
            switch (this.provider) {
                case 'gemini':
                    return await this.callGemini(prompt, options);
                case 'openai':
                    return await this.callOpenAI(prompt, options);
                case 'anthropic':
                    return await this.callAnthropic(prompt, options);
                default:
                    throw new Error(`지원하지 않는 Provider: ${this.provider}`);
            }
        } catch (error) {
            this.logger.error(`LLM 호출 실패: ${error.message}`, error.stack);
            throw error;
        } finally {
            this.logger.debug(`LLM 응답 시간: ${Date.now() - startTime}ms`);
        }
    }

    // ========================================
    // 고수준 API: 도메인별 분석
    // ========================================

    /**
     * 사주 요약 생성
     */
    async generateSajuSummary(request: SajuSummaryRequest): Promise<AiReadingResult> {
        const prompt = this.buildSajuPrompt(request);
        const response = await this.generateText(prompt, {
            systemPrompt: '당신은 전통 동양 사주 전문가입니다. 사용자의 사주를 분석하여 친근하고 긍정적인 조언을 제공합니다.',
            temperature: 0.7,
        });

        return this.parseAiResult(response.content, '오늘의 사주 운세');
    }

    /**
     * 타로 해석 생성
     */
    async generateTarotReading(request: TarotReadingRequest): Promise<AiReadingResult> {
        const prompt = this.buildTarotPrompt(request);
        const response = await this.generateText(prompt, {
            systemPrompt: '당신은 타로 카드 전문가입니다. 뽑힌 카드를 바탕으로 통찰력 있는 해석을 제공합니다.',
            temperature: 0.8,
        });

        return this.parseAiResult(response.content, '타로 카드 해석');
    }

    /**
     * 꿈 해석 생성
     */
    async generateDreamMeaning(request: DreamMeaningRequest): Promise<AiReadingResult> {
        const prompt = this.buildDreamPrompt(request);
        const response = await this.generateText(prompt, {
            systemPrompt: '당신은 꿈 해석 전문가입니다. 꿈의 상징을 분석하여 의미 있는 해석을 제공합니다.',
            temperature: 0.7,
        });

        return this.parseAiResult(response.content, '꿈 해석');
    }

    /**
     * 관상 해석 생성 (이미지 없이 특징 수치만 사용)
     */
    async generateFaceReading(request: FaceReadingRequest): Promise<AiReadingResult> {
        const prompt = this.buildFacePrompt(request);
        const response = await this.generateText(prompt, {
            systemPrompt: '당신은 전통 관상학 전문가입니다. 얼굴 특징을 바탕으로 성격과 운세를 분석합니다.',
            temperature: 0.6,
        });

        return this.parseAiResult(response.content, '관상 분석');
    }

    // ========================================
    // Provider별 구현 (TODO: 실제 API 연동)
    // ========================================

    private async callGemini(prompt: string, options?: LLMOptions): Promise<LLMResponse> {
        const apiKey = this.configService.get<string>('GEMINI_API_KEY');
        const model = this.configService.get<string>('GEMINI_MODEL', 'gemini-1.5-flash');

        if (!apiKey) {
            throw new Error('GEMINI_API_KEY가 설정되지 않았습니다');
        }

        // TODO: 실제 Gemini API 호출 구현
        // const response = await fetch(`https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent`, {
        //   method: 'POST',
        //   headers: { 'Content-Type': 'application/json', 'x-goog-api-key': apiKey },
        //   body: JSON.stringify({ contents: [{ parts: [{ text: prompt }] }] }),
        // });

        // 개발용 더미 응답
        this.logger.warn('Gemini API 더미 응답 반환 (실제 연동 필요)');
        return {
            content: this.getDummyResponse(),
            model,
            usage: { promptTokens: 100, completionTokens: 200, totalTokens: 300 },
        };
    }

    private async callOpenAI(prompt: string, options?: LLMOptions): Promise<LLMResponse> {
        const apiKey = this.configService.get<string>('OPENAI_API_KEY');
        const model = this.configService.get<string>('OPENAI_MODEL', 'gpt-4o-mini');

        if (!apiKey) {
            throw new Error('OPENAI_API_KEY가 설정되지 않았습니다');
        }

        // TODO: 실제 OpenAI API 호출 구현
        this.logger.warn('OpenAI API 더미 응답 반환 (실제 연동 필요)');
        return {
            content: this.getDummyResponse(),
            model,
        };
    }

    private async callAnthropic(prompt: string, options?: LLMOptions): Promise<LLMResponse> {
        const apiKey = this.configService.get<string>('ANTHROPIC_API_KEY');
        const model = this.configService.get<string>('ANTHROPIC_MODEL', 'claude-3-haiku-20240307');

        if (!apiKey) {
            throw new Error('ANTHROPIC_API_KEY가 설정되지 않았습니다');
        }

        // TODO: 실제 Anthropic API 호출 구현
        this.logger.warn('Anthropic API 더미 응답 반환 (실제 연동 필요)');
        return {
            content: this.getDummyResponse(),
            model,
        };
    }

    // ========================================
    // 유틸리티
    // ========================================

    private buildSajuPrompt(req: SajuSummaryRequest): string {
        return `다음 생년월일시 정보를 바탕으로 오늘의 운세를 분석해주세요.
생년: ${req.birthYear}년
생월: ${req.birthMonth}월
생일: ${req.birthDay}일
${req.birthHour ? `생시: ${req.birthHour}시` : ''}
${req.gender ? `성별: ${req.gender === 'male' ? '남성' : '여성'}` : ''}

JSON 형식으로 응답해주세요:
{ "summary": "...", "details": [{"category": "재물운", "content": "..."}], "caution": "..." }`;
    }

    private buildTarotPrompt(req: TarotReadingRequest): string {
        return `다음 타로 카드를 해석해주세요.
뽑은 카드: ${req.cards.join(', ')}
${req.question ? `질문: ${req.question}` : ''}

JSON 형식으로 응답해주세요.`;
    }

    private buildDreamPrompt(req: DreamMeaningRequest): string {
        return `다음 꿈을 해석해주세요.
꿈 내용: ${req.dreamDescription}
${req.keywords?.length ? `키워드: ${req.keywords.join(', ')}` : ''}

JSON 형식으로 응답해주세요.`;
    }

    private buildFacePrompt(req: FaceReadingRequest): string {
        return `다음 얼굴 특징을 바탕으로 관상을 분석해주세요.
${JSON.stringify(req.features, null, 2)}

JSON 형식으로 응답해주세요.`;
    }

    private parseAiResult(content: string, defaultTitle: string): AiReadingResult {
        try {
            // JSON 파싱 시도
            const parsed = JSON.parse(content);
            return {
                title: parsed.title || defaultTitle,
                summary: parsed.summary || '',
                details: parsed.details || [],
                caution: parsed.caution,
                disclaimer: '본 분석은 오락 목적의 참고 정보이며, 전문적인 조언을 대체하지 않습니다.',
            };
        } catch {
            // JSON 파싱 실패 시 전체를 summary로
            return {
                title: defaultTitle,
                summary: content,
                details: [],
                disclaimer: '본 분석은 오락 목적의 참고 정보이며, 전문적인 조언을 대체하지 않습니다.',
            };
        }
    }

    private getDummyResponse(): string {
        return JSON.stringify({
            summary: '오늘은 새로운 시작에 좋은 기운이 감도는 날입니다.',
            details: [
                { category: '재물운', content: '예상치 못한 소득이 있을 수 있습니다.', rating: 4 },
                { category: '연애운', content: '소통이 원활해지는 시기입니다.', rating: 3 },
                { category: '건강운', content: '충분한 휴식이 필요합니다.', rating: 3 },
            ],
            caution: '중요한 결정은 신중하게 내리세요.',
        });
    }
}
