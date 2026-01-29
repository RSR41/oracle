import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { TagsModule } from './tags/tags.module';
import { HistoryModule } from './history/history.module';
import { FaceModule } from './face/face.module';
import { PrismaModule } from './prisma.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env', 'backend/.env', '../.env', 'oracle/backend/.env'],
    }),
    PrismaModule,
    AuthModule,
    TagsModule,
    HistoryModule,
    FaceModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule { }
