# PHASE 4: Backend Implementation Plan

## 1. Architecture Overview

- **Framework**: NestJS (TypeScript)
- **Database**: PostgreSQL (v16)
- **ORM**: Prisma
- **Environment**: Docker Compose (Local Dev)
- **Auth Strategy**: JWT (Access Token + Refresh Token)

---

## 2. Database Schema (Prisma Draft)

```prisma
model User {
  id        String   @id @default(uuid())
  email     String   @unique
  password  String   // Hashed
  name      String?
  createdAt DateTime @default(now())
  
  profile   Profile?
  tags      Tag[]
  history   History[]
}

model Profile {
  id          String  @id @default(uuid())
  userId      String  @unique
  user        User    @relation(fields: [userId], references: [id])
  
  birthDate   String  // YYYY-MM-DD
  birthTime   String? // HH:mm
  isSolar     Boolean @default(true)
  isUnknown   Boolean @default(false)
  gender      String  // M/F
}

model Tag {
  id        String    @id @default(uuid())
  tagId     String    @unique // The 16-char ID on the physical tag
  ownerId   String?
  owner     User?     @relation(fields: [ownerId], references: [id])
  
  status    String    @default("UNCLAIMED") // UNCLAIMED, CLAIMED, BLOCKED
  
  // Initial setup data (before claim)
  tempData  Json?     // { name, birthDate, ... }
  
  createdAt DateTime  @default(now())
}

model History {
  id        String   @id @default(uuid())
  userId    String
  user      User     @relation(fields: [userId], references: [id])
  
  type      String   // SAJU, TAROT, FACE, COMPATIBILITY
  summary   String
  metadata  Json?    // Detailed result data
  
  createdAt DateTime @default(now())
}
```

---

## 3. API Endpoints Plan

### 3.1 Auth
| Method | Path | Description |
|--------|------|-------------|
| POST | `/auth/register` | Create account |
| POST | `/auth/login` | Return JWT |
| GET | `/auth/me` | Current user info |

### 3.2 Tags (NFC)
| Method | Path | Description |
|--------|------|-------------|
| GET | `/public/tags/:tagId` | Public summary (PWA) |
| POST | `/public/tags/:tagId/setup` | Save initial data (PWA) |
| POST | `/tags/:tagId/claim` | Link tag to user (App) |
| POST | `/tags/:tagId/transfer` | Transfer ownership (App) |

### 3.3 Fortune/History
| Method | Path | Description |
|--------|------|-------------|
| GET | `/history` | List user history |
| POST | `/history` | Save a result |
| POST | `/fortune/saju` | Calculate/Store Saju (Optional) |
| POST | `/face/analyze` | Dummy Face Analysis |

---

## 4. Implementation Steps

1. **Setup**: Initialize NestJS project in `oracle/backend`.
2. **Docker**: Create `docker-compose.yml` for Postgres.
3. **Prisma**: Define schema and migrate.
4. **Auth Module**: Implement Login/Register with JWT.
5. **Tag Module**: Implement schema and PWA endpoints.
6. **Flutter Integration**: Update `AuthProvider` and `HistoryProvider`.
7. **Verify**: Test full flow (NFC -> PWA -> App Claim).
