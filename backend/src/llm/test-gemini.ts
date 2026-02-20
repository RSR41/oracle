import { NestFactory } from '@nestjs/core';
import { AppModule } from '../app.module';
import { LlmService } from './llm.service';

async function bootstrap() {
    const app = await NestFactory.createApplicationContext(AppModule);
    const llmService = app.get(LlmService);

    console.log('--- Gemini SDK Integration Test ---');
    try {
        const response = await llmService.generateText('Tell me a short joke about AI.');
        console.log('Response content:', response.content);
        console.log('Model used:', response.model);
        console.log('Usage:', response.usage);
    } catch (error) {
        console.error('Test failed:', error.message);
    } finally {
        await app.close();
    }
}

bootstrap();
