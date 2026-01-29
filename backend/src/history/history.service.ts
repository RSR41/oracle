import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { PrismaService } from '../prisma.service';
import { CreateHistoryDto } from './dto/create-history.dto';

@Injectable()
export class HistoryService {
    constructor(private prisma: PrismaService) { }

    async create(userId: string, dto: CreateHistoryDto) {
        return this.prisma.history.create({
            data: {
                userId,
                type: dto.type,
                title: dto.title,
                summary: dto.summary,
                metadata: dto.metadata || {},
            },
        });
    }

    async findAll(userId: string) {
        return this.prisma.history.findMany({
            where: { userId },
            orderBy: { createdAt: 'desc' },
        });
    }

    async remove(userId: string, id: string) {
        const history = await this.prisma.history.findUnique({ where: { id } });

        if (!history) throw new NotFoundException('History not found');
        if (history.userId !== userId) throw new ForbiddenException('Not your history');

        return this.prisma.history.delete({ where: { id } });
    }
}
