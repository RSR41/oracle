# Backend Implementation Guide

## Recommended Fast Path: Serverless PostgreSQL (Neon/Supabase)

This backend uses Prisma with PostgreSQL (`backend/prisma/schema.prisma`).
For the fastest free deployment path, connect to a managed serverless Postgres instance (Neon or Supabase) by replacing `DATABASE_URL`.

## 1. Prerequisites
- Node.js (v18+)
- A Neon or Supabase Postgres project/instance

## 2. Environment Setup
Inside `oracle/backend`, create `.env` (or update existing):

```bash
DATABASE_URL="postgresql://<user>:<password>@<host>/<db>?sslmode=require"
JWT_SECRET="dev_secret_key_do_not_use_in_prod"
JWT_EXPIRATION="7d"
PORT=8080
```

> For Neon/Supabase, use the provider's SSL-enabled connection string.

## 3. Prisma Setup / Migration / Seed Runbook
Inside `oracle/backend`:

```bash
npm install
npx prisma generate
npx prisma migrate deploy
npx prisma db seed   # optional, only if prisma seed is configured
```

For local schema changes during development:

```bash
npx prisma migrate dev --name <change_name>
```

## 4. Running the Server
```bash
npm run start:dev
```
Server starts on `http://localhost:8080`.

## 5. API Endpoints Available
- **Auth**: `/auth/register`, `/auth/login`, `/auth/me`
- **Tags (Public)**: `/public/tags/:tagId`
- **Tags (App)**: `/tags/:tagId/claim`, `/tags/:tagId/transfer`
- **History**: `/history` (GET, POST, DELETE)
- **Face**: `/face/analyze` (Mock)
