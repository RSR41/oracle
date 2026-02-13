# Prisma Migration & Seed Guide

## 준비

1. `backend/.env`에 `DATABASE_URL` 설정 (Neon/Supabase Free Postgres 권장)
2. 의존성 설치

```bash
cd backend
npm install
```

## 마이그레이션

```bash
cd backend
npm run prisma:generate
npm run prisma:migrate -- --name init
```

- 새 스키마 변경 시:

```bash
npm run prisma:migrate -- --name <change_name>
```

## 시드

```bash
cd backend
npm run prisma:seed
```

시드 결과:
- `seed-user@oracle.dev` 테스트 사용자 생성/갱신
- `history` 샘플 1건 추가

## 문제 해결

- `P1001` (DB 연결 실패): `DATABASE_URL` 호스트/포트/SSL 파라미터 확인
- SSL 요구 환경(Neon/Supabase): URL에 `sslmode=require` 권장
