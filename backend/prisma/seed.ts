import { PrismaClient } from '@prisma/client';
import bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  const passwordHash = await bcrypt.hash('dev-password-1234', 10);

  const user = await prisma.user.upsert({
    where: { email: 'seed-user@oracle.dev' },
    update: {},
    create: {
      email: 'seed-user@oracle.dev',
      password: passwordHash,
      name: 'Seed User',
      profile: {
        create: {
          birthDate: '1994-01-02',
          birthTime: '09:30',
          isSolar: true,
          gender: 'F',
        },
      },
    },
  });

  await prisma.history.create({
    data: {
      userId: user.id,
      type: 'DREAM',
      title: '시드 데이터: 꿈 해석',
      summary: '무료 DB 연동 확인용 시드 히스토리 데이터입니다.',
      metadata: {
        source: 'prisma-seed',
      },
    },
  });

  console.log(`✅ Seed complete for user: ${user.email}`);
}

main()
  .catch((error) => {
    console.error('❌ Seed failed', error);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
