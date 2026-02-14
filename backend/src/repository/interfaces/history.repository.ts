import { History, Prisma } from '@prisma/client';

export interface CreateHistoryInput {
  userId: string;
  type: string;
  title: string;
  summary: string;
  metadata?: Prisma.InputJsonValue;
}

export interface HistoryRepository {
  create(input: CreateHistoryInput): Promise<History>;
  findAllByUserId(userId: string): Promise<History[]>;
  findById(id: string): Promise<History | null>;
  deleteById(id: string): Promise<History>;
}
