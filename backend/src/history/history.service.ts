import { Inject, Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { CreateHistoryDto } from './dto/create-history.dto';
import { HISTORY_REPOSITORY } from '../repository/repository.tokens';
import type { HistoryRepository } from '../repository/interfaces/history.repository';

@Injectable()
export class HistoryService {
    constructor(@Inject(HISTORY_REPOSITORY) private readonly historyRepository: HistoryRepository) { }

    async create(userId: string, dto: CreateHistoryDto) {
        return this.historyRepository.create({
            userId,
            type: dto.type,
            title: dto.title,
            summary: dto.summary,
            metadata: dto.metadata || {},
        });
    }

    async findAll(userId: string) {
        return this.historyRepository.findAllByUserId(userId);
    }

    async remove(userId: string, id: string) {
        const history = await this.historyRepository.findById(id);

        if (!history) throw new NotFoundException('History not found');
        if (history.userId !== userId) throw new ForbiddenException('Not your history');

        return this.historyRepository.deleteById(id);
    }
}
