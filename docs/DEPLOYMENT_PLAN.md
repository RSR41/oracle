# DEPLOYMENT_PLAN.md

## EF (이프) Deployment Guide

---

## Environment Overview

| Environment | Purpose | URL Pattern |
|-------------|---------|-------------|
| Local | Development | localhost:* |
| Staging | Testing | staging.*.com |
| Production | Live users | *.com |

---

## 1. Local Development Setup

### Prerequisites
- Flutter SDK 3.19+
- Node.js 20+
- Docker Desktop
- Android Studio / Xcode

### Backend

```bash
cd oracle/backend

# Copy environment file
cp .env.example .env

# Start services
docker-compose up -d

# Verify
curl http://localhost:8080/health
```

### PWA

```bash
cd oracle/pwa

# Install dependencies
npm install

# Start dev server
npm run dev

# Open http://localhost:3000
```

### Flutter App

```bash
cd oracle/apps/flutter

# Get dependencies
flutter pub get

# Run on Android emulator
flutter run -d android

# Run on iOS simulator
flutter run -d ios
```

---

## 2. Backend Deployment (AWS)

### Architecture

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Route 53  │────▶│     ALB     │────▶│    ECS      │
└─────────────┘     └─────────────┘     │  (Fargate)  │
                                        └──────┬──────┘
                                               │
                    ┌──────────────────────────┼──────────────────────────┐
                    │                          │                          │
              ┌─────▼─────┐            ┌───────▼───────┐          ┌───────▼───────┐
              │   RDS     │            │  ElastiCache  │          │      S3       │
              │ PostgreSQL│            │    (Redis)    │          │   (Assets)    │
              └───────────┘            └───────────────┘          └───────────────┘
```

### Deployment Steps

```bash
# 1. Build Docker image
docker build -t ef-backend .

# 2. Push to ECR
aws ecr get-login-password | docker login --username AWS --password-stdin $ECR_URL
docker tag ef-backend:latest $ECR_URL/ef-backend:latest
docker push $ECR_URL/ef-backend:latest

# 3. Update ECS service
aws ecs update-service --cluster ef-cluster --service ef-backend --force-new-deployment
```

---

## 3. PWA Deployment (Vercel)

### Setup

```bash
# Install Vercel CLI
npm i -g vercel

# Link project
cd oracle/pwa
vercel link
```

### Deploy

```bash
# Preview deployment
vercel

# Production deployment
vercel --prod
```

### Environment Variables (Vercel Dashboard)

| Variable | Value |
|----------|-------|
| `NEXT_PUBLIC_API_URL` | https://api.ef.rsr41.com |
| `NEXT_PUBLIC_APP_STORE_URL` | https://apps.apple.com/... |
| `NEXT_PUBLIC_PLAY_STORE_URL` | https://play.google.com/... |

---

## 4. Flutter App Release

### Android (Google Play)

```bash
cd oracle/apps/flutter

# Build release APK
flutter build apk --release

# Build App Bundle (recommended)
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

Upload to Google Play Console.

### iOS (App Store)

```bash
cd oracle/apps/flutter

# Build iOS
flutter build ios --release

# Open in Xcode
open ios/Runner.xcworkspace
```

Archive and upload via Xcode.

---

## 5. NFC Redirect Server

### Simple Implementation (Cloudflare Workers)

```javascript
// worker.js
export default {
  async fetch(request, env) {
    const url = new URL(request.url);
    const tagId = url.pathname.replace('/t/', '');
    
    if (!tagId) {
      return new Response('Invalid tag', { status: 400 });
    }
    
    const targetUrl = `${env.PWA_BASE_URL}/tag/${tagId}`;
    
    return Response.redirect(targetUrl, 302);
  }
}
```

Deploy:
```bash
wrangler deploy
```

---

## 6. Database Migrations

### Initial Setup

```bash
cd oracle/backend

# Run migrations
npm run db:migrate

# Seed data (development only)
npm run db:seed
```

### Production Migration

```bash
# Create migration
npm run db:migration:create -- --name add_transfer_table

# Apply migration
NODE_ENV=production npm run db:migrate
```

---

## 7. Monitoring & Logging

### Recommended Services

| Service | Purpose |
|---------|---------|
| AWS CloudWatch | Backend logs & metrics |
| Sentry | Error tracking (Flutter + PWA) |
| Firebase Analytics | App usage analytics |
| Vercel Analytics | PWA performance |

### Health Checks

| Endpoint | Expected |
|----------|----------|
| `GET /health` | `{"status": "ok"}` |
| `GET /ready` | `{"database": "ok", "cache": "ok"}` |

---

## 8. Rollback Procedures

### Backend (ECS)

```bash
# List previous task definitions
aws ecs list-task-definitions --family ef-backend

# Rollback to previous version
aws ecs update-service \
  --cluster ef-cluster \
  --service ef-backend \
  --task-definition ef-backend:PREVIOUS_VERSION
```

### PWA (Vercel)

```bash
# List deployments
vercel ls

# Rollback to specific deployment
vercel rollback [deployment-url]
```

### Mobile App

- Android: Use staged rollout, halt if issues
- iOS: Cannot rollback, submit hotfix

---

## 9. Security Checklist

- [ ] HTTPS enforced on all endpoints
- [ ] API rate limiting enabled
- [ ] Database credentials in secrets manager
- [ ] CORS configured properly
- [ ] JWT secret rotated
- [ ] SQL injection protection (parameterized queries)
- [ ] Input validation on all endpoints
- [ ] Dependency vulnerabilities checked

---

## 10. Post-Deployment Verification

### Smoke Tests

1. **PWA**: Navigate to `/tag/test-tag` → Should load
2. **API**: `curl https://api.ef.rsr41.com/health` → 200 OK
3. **App**: Fresh install → Can register → Can login

### E2E Test Suite

```bash
cd oracle/e2e
npm run test:production
```
