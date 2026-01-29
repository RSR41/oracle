# PHASE 4: NFC & Tag Operations Guide

## 1. Tag ID Lifecycle

### 1.1 Generation Strategy
- **Format**: 16-character URL-safe Base64 string (e.g., `xK9mP3nQ7vR2wB4t`).
- **Entropy**: 96 bits, sufficient to prevent manual guessing.
- **Batching**: Generated in batches (e.g., Batch #2026-01) with associated CSV export.

### 1.2 Manufacturing Process
1. **Encoding**: URL = `https://redirect.rsr41.com/t/{tagId}` (or env variable base).
2. **Printing**: QR Code (backup) + Human Readable ID on packaging.
3. **Status**: DB records created as `UNCLAIMED`.

---

## 2. User Flows

### 2.1 Scenario A: New User (No App)
1. Tap NFC.
2. Open PWA (`/public/tags/:tagId`).
3. View "Unclaimed Tag" message.
4. Input basic Birth Info (Name, Date, Time, Gender).
5. View "Today's Fortune Summary" (Read-Only).
6. **call-to-action**: "Install App to save and view details".

### 2.2 Scenario B: App User (Claiming)
1. Install/Open App.
2. Login.
3. Tap "Register Tag" menu.
4. Scan NFC or Enter ID.
5. Server checks status:
   - If `UNCLAIMED`: Link to User, status -> `CLAIMED`.
   - If `CLAIMED`: Error "Already owned".

### 2.3 Scenario C: Transfer (Gift/Resale)
1. **Owner**: App > Tag Settings > "Transfer Ownership".
2. **Server**: Generates 8-digit temporary code (valid 24h).
3. **Recipient**: App > Register Tag > "I have a transfer code".
4. **Server**:
   - Verify code.
   - **Video/Data Reset**: Delete all private history associated with this tag.
   - Re-link tag to Recipient.
   - Old Owner loses access.

---

## 3. URL Strategy (Domain Undecided)

### Current Implementation (Phase 4)
- Use **Environment Variables** for Base URL.
- Development: `http://192.168.x.x:3000/t/{id}`
- Production: `https://ef.rsr41.com/t/{id}`

### Recommendation
- Do **NOT** hardcode domain in logic.
- NFC Tags should point to a **Redirect Server** (or a stable shortened domain) if possible, but for MVP, pointing to the main PWA domain is acceptable if the domain is purchased.

---

## 4. Security & Privacy
- **PWA Initial Data**: Stored in `tempData` column in `Tag` table.
- **TTL**: `tempData` cleared after 24h if not claimed (Cron job required).
- **Privacy**: When transferring, `History` table rows linked to the *User* are kept (users keep their memories), but the *Tag* association is severed.
