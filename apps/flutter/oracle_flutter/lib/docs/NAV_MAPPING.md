# Navigation Mapping (Phase 44)

**Source Snapshot**: `lib/docs/NAV_SNAPSHOT.json`
**React Source**: `src/app/App.tsx` (Logic), `src/app/screens/*.tsx` (Targets)

## 1. Route Mapping Registry

| React screenName | Flutter Route Path | Type | Implementation |
|------------------|--------------------|------|----------------|
| **Tabs** | | | |
| `home` | `/home` | Shell | `SimpleScreen` |
| `fortune` | `/fortune` | Shell | `SimpleScreen` |
| `compatibility` | `/compatibility` | Shell | `SimpleScreen` |
| `history` | `/history` | Shell | `SimpleScreen` |
| `profile` | `/profile` | Shell | `SimpleScreen` |
| **Features** | | | |
| `onboarding` | `/onboarding` | Custom | `OnboardingScreen` |
| `face` | `/face` | Stack | `SimpleScreen` |
| `ideal-type` | `/ideal-type` | Stack | `SimpleScreen` |
| `connection` | `/connection` | Stack | `SimpleScreen` |
| `settings` | `/settings` | Stack | `SimpleScreen` |
| `tarot` | `/tarot` | Stack | `SimpleScreen` |
| `dream` | `/dream` | Stack | `SimpleScreen` |
| `chat` | `/chat` | Stack | `SimpleScreen` |
| **Placeholders** | | | |
| `fortune-today` | `/fortune-today` | Stack | `ComingSoonScreen` |
| `calendar` | `/calendar` | Stack | `ComingSoonScreen` |
| `saju-analysis` | `/saju-analysis` | Stack | `ComingSoonScreen` |
| `consultation` | `/consultation` | Stack | `ComingSoonScreen` |
| `yearly-fortune` | `/yearly-fortune` | Stack | `ComingSoonScreen` |
| `compat-check` | `/compat-check` | Stack | `ComingSoonScreen` |
| `compat-result` | `/compat-result` | Stack | `ComingSoonScreen` |
| `profile-edit` | `/profile-edit` | Stack | `ComingSoonScreen` |
| `fortune-settings` | `/fortune-settings` | Stack | `ComingSoonScreen` |
| `connection-settings` | `/connection-settings` | Stack | `ComingSoonScreen` |
| `premium` | `/premium` | Stack | `ComingSoonScreen` |
| **Dynamic Details** | | | |
| `fortune-detail` | `/fortune-detail` | Stack | `ComingSoonScreen` (requires id) |
| `compat-detail` | `/compat-detail` | Stack | `ComingSoonScreen` (requires id) |
| `tarot-detail` | `/tarot-detail` | Stack | `ComingSoonScreen` (requires id) |
| `face-detail` | `/face-detail` | Stack | `ComingSoonScreen` (requires id) |
| `dream-detail` | `/dream-detail` | Stack | `ComingSoonScreen` (requires id) |

## 2. React Known Issues (Fact-based)

1. **Detail Implementation Missing**:
   - `History.tsx` items link to `*-detail` (e.g., `fortune-detail`), but `App.tsx` switch case does NOT handle these screens. They likely fall through or do nothing in React.
   - Flutter will provide a route for them to prevent crashes, using `ComingSoonScreen`.

2. **BottomNav Visibility**:
   - `App.tsx` explicitly shows BottomNav only for `['home', 'fortune', 'compatibility', 'history', 'profile']`.
   - All other screens (`face`, `settings`, etc.) hide the bottom bar. Flutter will follow this using `ShellRoute`.

## 3. Flutter Strategy
- **GoRouter**: Used for all routing.
- **NavState**: Replicates `activeTab`, `showOnboarding`, `screenStack` logic from React.
- **Redirect**:
  - If `showOnboarding` is true → Redirect to `/onboarding`.
  - If `showOnboarding` becomes false → Redirect to `/home`.
