import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { PassportModule } from '@nestjs/passport';
import { JwtModule } from '@nestjs/jwt';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { JwtStrategy } from './jwt.strategy';
import { AUTH_REPOSITORY } from '../repository/repository.tokens';
import { PrismaAuthRepository } from '../repository/providers/prisma-auth.repository';
import { getAuthRepository } from '../repository/repository.provider-factory';

@Module({
  imports: [
    PassportModule,
    JwtModule.registerAsync({
      imports: [ConfigModule],
      useFactory: async (configService: ConfigService) => ({
        secret: configService.get<string>('JWT_SECRET') || 'dev_secret_key_do_not_use_in_prod',
        signOptions: { expiresIn: '7d' },
      }),
      inject: [ConfigService],
    }),
  ],
  controllers: [AuthController],
  providers: [
    AuthService,
    JwtStrategy,
    PrismaAuthRepository,
    {
      provide: AUTH_REPOSITORY,
      useFactory: getAuthRepository,
      inject: [ConfigService, PrismaAuthRepository],
    },
  ],
  exports: [AUTH_REPOSITORY],
})
export class AuthModule { }
