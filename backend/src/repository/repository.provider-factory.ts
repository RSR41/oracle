import { ConfigService } from '@nestjs/config';
import { PrismaAuthRepository } from './providers/prisma-auth.repository';
import { PrismaHistoryRepository } from './providers/prisma-history.repository';
import { resolveDbProvider } from './db-provider';

export function getAuthRepository(
  configService: ConfigService,
  prismaAuthRepository: PrismaAuthRepository,
) {
  const provider = resolveDbProvider(configService.get<string>('DB_PROVIDER'));

  if (provider === 'prisma' || provider === 'supabase') {
    return prismaAuthRepository;
  }

  throw new Error(
    'DB_PROVIDER=firebase is not implemented yet. Use prisma/supabase or add a Firestore adapter.',
  );
}

export function getHistoryRepository(
  configService: ConfigService,
  prismaHistoryRepository: PrismaHistoryRepository,
) {
  const provider = resolveDbProvider(configService.get<string>('DB_PROVIDER'));

  if (provider === 'prisma' || provider === 'supabase') {
    return prismaHistoryRepository;
  }

  throw new Error(
    'DB_PROVIDER=firebase is not implemented yet. Use prisma/supabase or add a Firestore adapter.',
  );
}
