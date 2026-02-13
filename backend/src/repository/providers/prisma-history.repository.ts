import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma.service';
import { CreateHistoryInput, HistoryRepository } from '../interfaces/history.repository';

@Injectable()
export class PrismaHistoryRepository implements HistoryRepository {
  constructor(private readonly prisma: PrismaService) {}

  create(input: CreateHistoryInput) {
    return this.prisma.history.create({
      data: {
        userId: input.userId,
        type: input.type,
        title: input.title,
        summary: input.summary,
        metadata: input.metadata,
      },
    });
  }

  findAllByUserId(userId: string) {
    return this.prisma.history.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });
  }

  findById(id: string) {
    return this.prisma.history.findUnique({ where: { id } });
  }

  deleteById(id: string) {
    return this.prisma.history.delete({ where: { id } });
  }
}
