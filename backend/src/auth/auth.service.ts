import { Inject, Injectable, UnauthorizedException, ConflictException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import * as bcrypt from 'bcrypt';
import { AUTH_REPOSITORY } from '../repository/repository.tokens';
import type { AuthRepository } from '../repository/interfaces/auth.repository';

@Injectable()
export class AuthService {
    constructor(
        @Inject(AUTH_REPOSITORY) private readonly authRepository: AuthRepository,
        private jwtService: JwtService,
    ) { }

    async register(dto: RegisterDto) {
        // Check if user exists
        const existing = await this.authRepository.findUserByEmail(dto.email);

        if (existing) {
            throw new ConflictException('Email already in use');
        }

        // Hash password
        const hashedPassword = await bcrypt.hash(dto.password, 10);

        // Create user
        const user = await this.authRepository.createUser({
            email: dto.email,
            password: hashedPassword,
            name: dto.name,
        });

        return {
            message: 'User registered successfully',
            user: {
                id: user.id,
                email: user.email,
                name: user.name,
            },
        };
    }

    async login(dto: LoginDto) {
        const user = await this.authRepository.findUserByEmail(dto.email);

        if (!user) {
            throw new UnauthorizedException('Invalid credentials');
        }

        const isPasswordValid = await bcrypt.compare(dto.password, user.password);
        if (!isPasswordValid) {
            throw new UnauthorizedException('Invalid credentials');
        }

        const payload = { sub: user.id, email: user.email };
        return {
            access_token: this.jwtService.sign(payload),
            user: {
                id: user.id,
                email: user.email, // PWA doesn't need much more than this initially
                name: user.name,
            },
        };
    }

    // Used by strategy to validate user existence is handled in the strategy itself usually, 
    // but if we had complex session logic, it would go here.
}
