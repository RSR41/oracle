import { Module } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { HistoryController } from './history.controller';
import { HistoryService } from './history.service';
import { HISTORY_REPOSITORY } from '../repository/repository.tokens';
import { PrismaHistoryRepository } from '../repository/providers/prisma-history.repository';
import { getHistoryRepository } from '../repository/repository.provider-factory';

@Module({
  controllers: [HistoryController],
  providers: [
    HistoryService,
    PrismaHistoryRepository,
    {
      provide: HISTORY_REPOSITORY,
      useFactory: getHistoryRepository,
      inject: [ConfigService, PrismaHistoryRepository],
    },
  ],
})
export class HistoryModule { }
