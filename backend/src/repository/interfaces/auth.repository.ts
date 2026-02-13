import { User } from '@prisma/client';

export interface CreateUserInput {
  email: string;
  password: string;
  name?: string;
}

export interface AuthRepository {
  findUserByEmail(email: string): Promise<User | null>;
  createUser(input: CreateUserInput): Promise<User>;
}
