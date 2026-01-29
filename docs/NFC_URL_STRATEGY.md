# NFC URL Strategy

## Overview

This document defines how NFC tags should be encoded and how URL routing works for the EF (이프) app.

---

## Strategy Comparison

### Option 1: Dynamic Link (Redirect) - RECOMMENDED ✅

**Concept**: Tag contains a permanent redirect URL. Server redirects to current PWA.

```
NFC Tag → https://redirect.rsr41.com/t/{tagId}
                    ↓
          302 Redirect to
                    ↓
         https://ef.rsr41.com/t/{tagId}
```

**Pros**:
- Domain can change without reprinting tags
- A/B testing possible (route to different PWA versions)
- Analytics tracking at redirect layer
- Batch invalidation possible (block compromised tags)

**Cons**:
- Requires redirect server maintenance
- Extra HTTP hop (negligible latency)

**Implementation**:
```env
# .env (redirect server)
REDIRECT_TARGET_BASE=https://ef.rsr41.com

# Redirect logic (pseudo-code)
GET /t/:tagId → 302 Redirect to ${REDIRECT_TARGET_BASE}/t/${tagId}
```

### Option 2: Static Direct URL

**Concept**: Tag contains the final PWA URL directly.

```
NFC Tag → https://ef.rsr41.com/t/{tagId}
```

**Pros**:
- Simpler architecture
- No redirect server needed

**Cons**:
- Domain change requires reprinting all tags
- No analytics at URL layer
- Cannot invalidate tags at URL level

---

## Recommendation

**Use Option 1 (Dynamic Link)** for production.

For development/testing, use environment variables:

```env
# Development
NFC_REDIRECT_BASE=http://localhost:3000

# Staging
NFC_REDIRECT_BASE=https://staging.ef.rsr41.com

# Production
NFC_REDIRECT_BASE=https://ef.rsr41.com
```

---

## Tag URL Format

### Structure
```
https://{REDIRECT_DOMAIN}/t/{tagId}
```

### tagId Format
- Length: 12-16 characters
- Charset: URL-safe base64 (A-Za-z0-9_-)
- Example: `xK9mP3nQ7vR2`

---

## App vs Web Routing

> [!IMPORTANT]
> Per requirements, NFC ALWAYS opens the **web** (PWA), never the app directly.

**Rationale**:
- Works for users without app installed
- Consistent experience across platforms
- App-installed users see summary → deep link to app if desired

---

## Implementation Files

| File | Location | Purpose |
|------|----------|---------|
| Redirect Server | TBD | 302 redirect to PWA |
| PWA Route | `pwa/src/app/tag/[token]/page.tsx` | Handle tag display |
| Backend API | `backend/src/routes/tag.routes.ts` | Tag info/validation |

---

## Domain Placeholder

Current domain is **undetermined**. Code uses environment variables:

```typescript
// pwa/.env.local
NEXT_PUBLIC_API_URL=http://localhost:8080

// backend/.env
FRONTEND_URL=http://localhost:3000
```

---

## Security Considerations

1. **Rate Limiting**: Prevent tag scraping by limiting requests per IP
2. **Invalid Tag Response**: Return generic error, don't reveal if tagId exists
3. **HTTPS Only**: All tag URLs must use HTTPS
4. **Token Validation**: Server validates tagId format before DB lookup
