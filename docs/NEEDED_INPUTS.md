# NEEDED_INPUTS.md (Phase 4 Update)

## 🔴 Blocking Questions for Backend

### 1. Domain Name Finalization
- **Context**: NFC tags require a permanent URL.
- **Question**: Is `rsr41.com` available and final? Or should we use a generic shortener?
- **Action**: Currently using placeholder `rsr41.com` in docs, but `localhost` in dev code.

### 2. Saju/Manseok Algorithm Source
- **Context**: Logic exists in Android (`FortuneEngine`).
- **Question**: Can we use a strict "porting" of the Android Kotlin code to TypeScript? Or is there a preferred external library?
- **Action**: Will port essential logic to Flutter/Dart first for offline capability. Backend will only store results.

### 3. Face Analysis Provider
- **Context**: Phase 4 uses Dummy API.
- **Question**: Do you have a contract with a specific provider (AWS/Google/Naver)?
- **Action**: Designing generic "Embedding + Score" schema to fit any provider later.

---

## 🟡 Policy Clarifications

### 4. Data Retention
- **Question**: How long to keep "Unclaimed" PWA input data?
- **Proposal**: 24 Hours.
- **Status**: Implemented as documentation policy.

### 5. Transfer Data Reset
- **Question**: When transferring a tag, do we delete the *previous owner's history*?
- **Proposal**: No, history belongs to the User, not the Tag. The Tag just becomes associated with a new User.
- **Status**: Implemented in DB Design.

---

## 🟢 Confirmed Items
- **Stack**: NestJS + Prisma + Postgres.
- **Auth**: Email/Password.
- **NFC Behavior**: Always opens PWA.
