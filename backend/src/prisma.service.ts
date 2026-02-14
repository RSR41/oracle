import { Injectable, OnModuleInit, OnModuleDestroy, Logger } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
    private readonly logger = new Logger(PrismaService.name);

    constructor(config: ConfigService) {
        const envUrl = config.get<string>('DATABASE_URL') || process.env.DATABASE_URL;

        if (!envUrl) {
            throw new Error('❌ [PrismaService] DATABASE_URL is required. Set a PostgreSQL connection string (Neon/Supabase recommended).');
        }

        super({
            datasources: {
                db: {
                    url: envUrl,
                },
            },
            // log: ['query', 'info', 'warn', 'error'], // Optional: Enable prisma logs in dev
        });
    }

    async onModuleInit() {
        try {
            await this.$connect();
            this.logger.log('Prisma connected to database');
        } catch (error) {
            this.logger.error(`❌ DB Connection failed: ${error.message}`);
            throw error;
        }
    }

    async onModuleDestroy() {
        await this.$disconnect();
    }
}
