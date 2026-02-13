# Backend Implementation Guide

## Status: Code Ready / Waiting for Docker

The backend code for Phase 4 is fully implemented using NestJS + Prisma.
However, the database (PostgreSQL) container could not be started due to a local Docker Desktop issue.

### 1. Prerequisites (Action Required)
- **Fix Docker**: Ensure `docker info` returns valid server status.
- **Run Database**:
  ```bash
  cd ../
  docker compose up -d
  ```

### 2. Database Setup (Once Docker is running)
Inside `oracle/backend`:
```bash
# Install dependencies (if not done)
npm install

# Generate Prisma Client & Migrate DB
npx prisma generate
npx prisma migrate dev --name init
```

### 3. Running the Server
```bash
# Development Mode
npm run start:dev
```
Server will start on `http://localhost:8080`.

### 4. API Endpoints Available
- **Auth**: `/auth/register`, `/auth/login`, `/auth/me`
- **Tags (Public)**: `/public/tags/:tagId`
- **Tags (App)**: `/tags/:tagId/claim`, `/tags/:tagId/transfer`
- **History**: `/history` (GET, POST, DELETE)
- **Face**: `/face/analyze` (Mock)

### 5. Environment Variables
Check `.env`. Default configuration:
- DB: `postgresql://postgres:postgres@localhost:5432/ef_db?schema=public`
- JWT Secret: `dev_secret_key_doe_not_use_in_prod`


### 6. DB Provider 전환 (Prisma/Supabase)
- `DB_PROVIDER`로 저장소 provider를 선택합니다.
  - `prisma`: 로컬 PostgreSQL + Prisma
  - `supabase`: Supabase Postgres + Prisma (코드 동일, `DATABASE_URL`만 Supabase로 교체)
- `.env` 예시
  ```env
  DB_PROVIDER="supabase"
  DATABASE_URL="postgresql://<user>:<password>@<host>:5432/postgres?schema=public&sslmode=require"
  ```
- 현재 `firebase` provider는 인터페이스 분기만 준비되어 있고 구현은 추후 Firestore adapter 추가가 필요합니다.
