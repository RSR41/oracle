import { Injectable, OnModuleInit, OnModuleDestroy, Logger } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
    private readonly logger = new Logger(PrismaService.name);

    constructor(config: ConfigService) {
        const fallback = 'postgresql://postgres:password123@127.0.0.1:5433/ef_db?schema=public&connect_timeout=5';
        const envUrl = config.get<string>('DATABASE_URL') || process.env.DATABASE_URL;
        const isProduction = process.env.NODE_ENV === 'production';

        if (!envUrl) {
            if (isProduction) {
                throw new Error('❌ [PrismaService] DATABASE_URL is required in PRODUCTION. Fallback is disabled.');
            }
            console.warn('⚠️ [PrismaService] DATABASE_URL env not found. Using DEV fallback.');
        }

        const url = envUrl || fallback;

        super({
            datasources: {
                db: {
                    url,
                },
            },
            // log: ['query', 'info', 'warn', 'error'], // Optional: Enable prisma logs in dev
        });
    }

    async onModuleInit() {
        const isProduction = process.env.NODE_ENV === 'production';

        try {
            await this.$connect();
            this.logger.log('Prisma connected to database');
        } catch (error) {
            if (isProduction) {
                throw error; // Production must crash if DB is missing
            } else {
                this.logger.error(`❌ DB Connection failed: ${error.message}`);
                this.logger.warn('⚠️ Server is starting WITHOUT Database. DB-dependent endpoints will fail.');
                // We deliberately swallow the error in DEV so the app can start listening on port 8080
            }
        }
    }

    async onModuleDestroy() {
        await this.$disconnect();
    }
}
