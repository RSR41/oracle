import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../prisma.service';
import { AuthRepository, CreateUserInput } from '../interfaces/auth.repository';

@Injectable()
export class PrismaAuthRepository implements AuthRepository {
  constructor(private readonly prisma: PrismaService) {}

  findUserByEmail(email: string) {
    return this.prisma.user.findUnique({ where: { email } });
  }

  createUser(input: CreateUserInput) {
    return this.prisma.user.create({
      data: {
        email: input.email,
        password: input.password,
        name: input.name,
      },
    });
  }
}
