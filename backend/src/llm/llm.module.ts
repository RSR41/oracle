import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { LlmService } from './llm.service';
import { LlmController } from './llm.controller';

/**
 * LLM 모듈
 * AI 기능(사주/타로/꿈/관상 해석)을 제공합니다.
 * 
 * 사용 방법:
 * 1. .env에 LLM_PROVIDER 및 API 키 설정
 * 2. AppModule에 LlmModule import
 * 3. /ai/* 엔드포인트로 접근
 */
@Module({
    imports: [ConfigModule],
    controllers: [LlmController],
    providers: [LlmService],
    exports: [LlmService],
})
export class LlmModule { }
