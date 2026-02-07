import {
    Controller,
    Post,
    Body,
    HttpCode,
    HttpStatus,
    UseGuards,
    Logger,
} from '@nestjs/common';
import { LlmService } from './llm.service';
import {
    AiReadingResult,
    SajuSummaryRequest,
    TarotReadingRequest,
    DreamMeaningRequest,
    FaceReadingRequest,
} from './llm.types';
import { IsString, IsNumber, IsOptional, IsArray, ValidateNested, Min, Max } from 'class-validator';
import { Type } from 'class-transformer';

// ========================================
// Request DTOs (유효성 검증)
// ========================================

export class SajuSummaryDto implements SajuSummaryRequest {
    @IsNumber()
    @Min(1900)
    @Max(2100)
    birthYear: number;

    @IsNumber()
    @Min(1)
    @Max(12)
    birthMonth: number;

    @IsNumber()
    @Min(1)
    @Max(31)
    birthDay: number;

    @IsOptional()
    @IsNumber()
    @Min(0)
    @Max(23)
    birthHour?: number;

    @IsOptional()
    @IsString()
    gender?: 'male' | 'female';

    @IsOptional()
    @IsString()
    targetDate?: string;
}

export class TarotReadingDto implements TarotReadingRequest {
    @IsArray()
    @IsString({ each: true })
    cards: string[];

    @IsOptional()
    @IsString()
    question?: string;

    @IsOptional()
    @IsString()
    spreadType?: string;
}

export class DreamMeaningDto implements DreamMeaningRequest {
    @IsString()
    dreamDescription: string;

    @IsOptional()
    @IsArray()
    @IsString({ each: true })
    keywords?: string[];
}

class FaceFeatures {
    @IsOptional()
    @IsNumber()
    eyeDistance?: number;

    @IsOptional()
    @IsNumber()
    noseLength?: number;

    @IsOptional()
    @IsNumber()
    mouthWidth?: number;

    @IsOptional()
    @IsString()
    faceShape?: string;
}

export class FaceReadingDto implements FaceReadingRequest {
    @ValidateNested()
    @Type(() => FaceFeatures)
    features: FaceFeatures;
}

// ========================================
// Controller
// ========================================

@Controller('ai')
export class LlmController {
    private readonly logger = new Logger(LlmController.name);

    constructor(private readonly llmService: LlmService) { }

    /**
     * POST /ai/saju-summary
     * 사주 기반 운세 요약 생성
     */
    @Post('saju-summary')
    @HttpCode(HttpStatus.OK)
    async getSajuSummary(@Body() dto: SajuSummaryDto): Promise<AiReadingResult> {
        this.logger.log(`사주 요약 요청: ${dto.birthYear}-${dto.birthMonth}-${dto.birthDay}`);
        return this.llmService.generateSajuSummary(dto);
    }

    /**
     * POST /ai/tarot-reading
     * 타로 카드 해석 생성
     */
    @Post('tarot-reading')
    @HttpCode(HttpStatus.OK)
    async getTarotReading(@Body() dto: TarotReadingDto): Promise<AiReadingResult> {
        this.logger.log(`타로 해석 요청: ${dto.cards.join(', ')}`);
        return this.llmService.generateTarotReading(dto);
    }

    /**
     * POST /ai/dream-meaning
     * 꿈 해석 생성
     */
    @Post('dream-meaning')
    @HttpCode(HttpStatus.OK)
    async getDreamMeaning(@Body() dto: DreamMeaningDto): Promise<AiReadingResult> {
        this.logger.log(`꿈 해석 요청: ${dto.dreamDescription.substring(0, 50)}...`);
        return this.llmService.generateDreamMeaning(dto);
    }

    /**
     * POST /ai/face-reading
     * 관상 분석 생성 (이미지 없이 특징 수치만)
     */
    @Post('face-reading')
    @HttpCode(HttpStatus.OK)
    async getFaceReading(@Body() dto: FaceReadingDto): Promise<AiReadingResult> {
        this.logger.log(`관상 분석 요청: ${JSON.stringify(dto.features)}`);
        return this.llmService.generateFaceReading(dto);
    }
}
