# Backend Implementation Guide

## 권장 경로: Neon/Supabase Free PostgreSQL + Prisma 유지

이 프로젝트는 NestJS + Prisma + PostgreSQL 조합을 기준으로 구성되어 있습니다.
무료 티어 환경에서는 **Neon** 또는 **Supabase(PostgreSQL)** 를 권장합니다.

## 1) `.env` 설정

`backend/.env` 파일을 생성하고 `DATABASE_URL`을 무료 Postgres URL로 지정합니다.

```bash
cd backend
cp .env.example .env
```

예시(Neon/Supabase 형식):

```dotenv
DATABASE_URL="postgresql://<USER>:<PASSWORD>@<HOST>/<DB>?sslmode=require"
```

> 참고: 실제 비밀번호/호스트는 각 서비스 대시보드 값을 사용하세요.

## 2) Prisma 마이그레이션/시드 절차

상세 절차는 `backend/prisma/README.md`를 따릅니다.

빠른 실행 순서:

```bash
cd backend
npm install
npm run prisma:generate
npm run prisma:migrate -- --name init
npm run prisma:seed
```

## 3) 서버 실행

```bash
cd backend
npm run start:dev
```

기본 주소: `http://localhost:8080`

## 4) 무료 DB 연동 점검(백엔드)

```bash
# health check
curl http://localhost:8080

# AI endpoint 왕복 확인
curl -X POST http://localhost:8080/ai/dream-meaning \
  -H 'Content-Type: application/json' \
  -d '{"dreamDescription":"하늘을 나는 꿈을 꿨어요"}'
```

## 5) Firebase 대안 검토 (Prisma 대체 영향)

Firebase(Firestore/Auth/Functions)로 전환하는 경우, 현재 Prisma 중심 구조를 다음처럼 재작성해야 합니다.

- Repository 레이어: Prisma CRUD → Firestore SDK 쿼리
- DTO/Validation: Nest DTO 유지 가능하나, 쿼리/인덱스 제약 반영 필요
- Query 패턴: relation join 중심 → 문서 비정규화 + 복합 인덱스 설계
- Migration 체계: Prisma migrate → 스키마 버전 문서 + 백필 스크립트

### 일정/리스크 비교표

| 항목 | Prisma + Neon/Supabase (권장) | Firebase 전환 |
|---|---|---|
| 초기 전환 비용 | 낮음 (환경변수 교체 중심) | 높음 (Repository/DTO/쿼리 재작성) |
| 예상 일정 | 0.5~1일 | 5~10일 |
| 데이터 모델 리스크 | 낮음 (기존 relation 유지) | 중~높음 (비정규화/인덱스 설계 필요) |
| 운영 복잡도 | 낮음 | 중간 (보안규칙 + 함수 배포) |
| 기존 테스트 재사용성 | 높음 | 낮음 |

**의사결정 권장안:** 단기 출시/안정성 기준으로는 **Prisma + 무료 PostgreSQL 유지**가 유리합니다.

## 6) API Endpoints

- Auth: `/auth/register`, `/auth/login`, `/auth/me`
- Tags (Public): `/public/tags/:tagId`
- Tags (App): `/tags/:tagId/claim`, `/tags/:tagId/transfer`
- History: `/history` (GET, POST, DELETE)
- Face: `/face/analyze`
- AI: `/ai/saju-summary`, `/ai/tarot-reading`, `/ai/dream-meaning`, `/ai/face-reading`
