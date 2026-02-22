import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';
import { json, urlencoded } from 'express';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.use(json({ limit: '12mb' }));
  app.use(urlencoded({ limit: '12mb', extended: true }));

  // Enable Validation
  app.useGlobalPipes(new ValidationPipe({
    whitelist: true,
    transform: true,
  }));

  // Enable CORS
  app.enableCors({
    origin: true, // Allow all origins for MPV/Development
    credentials: true,
  });

  await app.listen(process.env.PORT || 8080);
}
bootstrap();
