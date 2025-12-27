# Oracle(오라클) Android 앱 제작 문서 (절대 기준 스펙)
- 대상: Android 앱 (Kotlin + Jetpack Compose)
- 목적: Figma Make 목업 기반 UI를 먼저 MVP로 완성 → 이후 Tier2/Tier3 기능을 순차 추가
- 이 문서가 “절대 기준”이며, 구현/추가 기능은 반드시 이 문서를 먼저 업데이트한 뒤 반영한다.

---

## 0) 지금 내가 해야 할 것 (초보자용, 순서 고정)
### A. 준비물
1) Windows PC
2) Android Studio 설치 (Stable 권장)
   - 최신 Stable 채널 확인 후 설치한다. (예: 2025년 12월 기준 Otter 2 Feature Drop 2025.2.2 Stable) :contentReference[oaicite:0]{index=0}
3) Android 휴대폰(실기기) 또는 Emulator
4) Git(선택이지만 강력 권장)

### B. “ChatGPT로 실제 코드를 만드는” 운영 방식 (중요)
- ChatGPT에게 코딩 요청할 때는 항상 아래 3가지를 함께 준다.
  1) 현재 폴더 구조(또는 `tree` 출력)
  2) 현재 에러 로그(있으면)
  3) “이번 단계에서 만들 기능 1개”만 지정 (예: HomeScreen UI만)

- ChatGPT에게 요청하는 형식(강제):
  - “파일을 통째로 다시 써주기”보다  
    **(1) 어느 파일의 (2) 어느 위치에 (3) 어떤 코드를 추가/수정/삭제** 하는지 단계별로 안내해달라고 요청한다.
  - 새 파일이면 “파일 경로 + 전체 파일 내용”으로 받는다.

---

## 1) 절대 기준 UI/화면 요구사항 (너가 준 기준 그대로)
아래 요구사항은 UI/네비/기능 구현 시 변경 금지. (추후 변경하려면 문서 수정 먼저)

### 1.1 하단 탭 (Bottom Tabs)
- 홈 / 운세 / 타로 / 날씨 / 부적  
(※ “상담” 화면은 탭이 아니라 운세/타로 내부 진입 또는 별도 진입으로 추가 가능. 단, MVP 단계에서는 우선 ‘상담’은 메뉴/탭에서 제외하거나, 운세 탭 내부 섹션으로 둔다.)

### 1.2 주요 화면 (식별된 화면)
#### [홈 화면]
- 상단: 사용자 프로필 / 알림 / 장바구니
- 운세 점수: 큰 숫자 + 그래프(예: 85점, “사소한 일은 OK”)
- 오늘의 운세 요약 카드
- 추천 콘텐츠 섹션
- 성향 분석 카드: “손재주가 좋은 성향입니다”
- 프로모션 배너: “롯데리인 4계절”
- 날씨/운세 연계 아이템 카드(보온/따뜻한 음료)
- 하단 탭: 홈/운세/타로/날씨/부적

#### [운세 화면]
- 필터: 순서(인기/최신) / 분야(운세/관상/꿈해몽/타로) / 타입(텍스트/음성/영상)
- 통계 그래프(요일별 접속 패턴)
- 이번 주 운세 / 이번 달 운세
- CTA 버튼 (“작성하기” 또는 “자세히 보기” 성격의 버튼)
- 하단 탭 네비게이션

#### [타로 화면]
- 궁합의 성격 추천: 후천/위인/맞이(아이콘 + 점수)
- 오늘의 추천 섹션
- 서비스 카드 리스트
- 타로 상담사 프로필 카드(사진/이름/키워드/가격)
- “전문번역” 뱃지
- 예약 버튼(리뷰 보기)
- 하단 탭 네비게이션

#### [상담 화면] / [상담 상세 화면]
- 상담사 리스트/상세/패키지/가격/리뷰 버튼/추천 섹션
- (MVP에서는 “리스트/상세 UI + 더미데이터”까지만)

#### [부적 화면]
- 카테고리 필터 + 콘텐츠 카드(이미지/제목/설명/리뷰 버튼)

#### [내정보(프로필/설정)]
- 내 기록/설정/리뷰/포인트/주문내역 등 진입

---

## 2) 기능 요구사항 (Tier 기준 그대로)
### 2.1 Tier 1: MVP 필수 기능 (단, MVP 구현 순서는 Phase로 나눔)
1) 사용자 인증 및 프로필
- 생년월일/시간/양음력/성별 입력
- NFC 태그 연결(token 기반)
- 프로필 저장(DataStore/서버)

2) 오늘의 운세
- 일일 운세 조회 (preview + full)
- 체크인(1일 1회)
- 운세 점수(0~100)
- 잠금/해제 메커니즘

3) 관상 분석
- 사진 업로드
- 비민감 분석 결과(요약)
- 품질 플래그 표시

4) 딥링크
- NFC 태그 → 앱 실행
- Custom Scheme: oracle://tag/{token}
- HTTPS App Links: https://yourdomain.com/tag/{token}

5) PWA 연결
- Custom Tabs로 PWA 열기
- 태그 찍자마자 즉시 결과

### 2.2 Tier 2: 빠른 수익화 기능
- 상담 마켓플레이스(리스트/상세/예약/리뷰/결제)
- 프리미엄 콘텐츠(주간/월간/궁합/맞춤 조언, 잠금해제 결제)
- 부적/굿즈 쇼핑(리스트/장바구니/주문/배송)

### 2.3 Tier 3: 커뮤니티/확장
- 콘텐츠 피드/검색/필터
- 통계/인사이트
- 알림(Push)

---

## 3) “지금 당장 만들 MVP” 정의 (Phase 1)
> 목표: “앱이 실행되고, 프로필 입력 → 오늘 운세(점수/요약) → 잠금/체크인 → 기록 저장”까지 동작  
> 상담/타로/부적/날씨는 “UI + 더미”만 먼저 만들고 Phase 2 이후 실제 연결

### Phase 1 (MVP-핵심 플로우)
필수 포함(반드시 구현):
1) Splash + DeepLink 진입 처리(토큰이 있으면 TagEntry로)
2) Profile 입력/저장
- birthDate, birthTime, timeUnknown, calendarType(solar/lunar), gender
3) Home 탭 UI (점수/요약/추천/성향/프로모션/날씨연계)
4) TodayFortune 기능
- /fortune/today 호출(또는 MOCK) → preview/full 표시
- 잠금 로직: 처음엔 preview만, checkin 하면 full unlock
5) Check-in (1일 1회)
- /fortune/checkin 호출(또는 MOCK) → unlocked=true
6) History(내 운세 기록)
- 최소: 날짜 리스트 + 상세로 재진입

Phase 1에서 “안 해도 되는 것(금지 아님, 우선순위 낮음)”:
- 결제/포인트
- 상담 예약 실제 기능
- 배송/주문
- Push 알림
- 관상 분석 실제 서버 연동 (UI/업로드 더미까지만 가능)

---

## 4) 데이터 모델 (절대 기준: 너가 준 모델과 호환)
### 4.1 User
- userId, profileId, birthDate, birthTime, timeUnknown, calendarType, gender, nfcToken, createdAt

### 4.2 DailyFortune
- fortuneId, profileId, dateKey, score, preview, full, unlocked
- categories: love/career/health/money

### 4.3 FaceAnalysis
- analysisId, profileId, dateKey, imageUrl(원본 저장 안함 권장), summaryText, flags

### 4.4 Consultant / Consultation / Product
- 문서의 모델을 그대로 따른다.

---

## 5) API 엔드포인트 설계 (절대 기준)
- Base Path: /api
- 인증: /auth/register, /auth/login, /auth/logout, /auth/me
- 프로필: POST /profile, GET/PUT /profile/:profileId
- 태그: GET /public/tag/:token, POST /public/tag/:token/bind
- 운세: POST /fortune/today, POST /fortune/checkin, GET /fortune/weekly, GET /fortune/monthly
- 관상: POST /face/upload, GET /face/history
- 상담: GET /consultants, GET /consultants/:id, POST /consultations, GET /consultations/my, POST /consultations/:id/review
- 상품: GET /products, GET /products/:id, POST /cart, POST /orders
- 콘텐츠: GET /contents, GET /contents/:id

---

## 6) Android 기술 스택 (권장, 문서 기준)
- Kotlin
- Jetpack Compose + Material3
- Navigation Compose
- Hilt(DI)
- Retrofit + OkHttp(Network)
- DataStore(Local Storage)
- Coil(Image Loading)

### 버전 정책(중요)
- 버전은 “고정 숫자 박아넣기”보다 BOM/Stable 기반을 우선한다.
- Compose는 BOM 사용 권장 (BOM 개념은 공식 문서에 있음) :contentReference[oaicite:1]{index=1}
- 2025년 12월 기준 Compose BOM 예시로 2025.12.00이 안내됨(참고) :contentReference[oaicite:2]{index=2}
- Kotlin 최신 릴리즈는 공식 문서에서 확인한다(예: 2025-12-16 Kotlin 2.3.0) :contentReference[oaicite:3]{index=3}
- Android Gradle Plugin/Android Studio는 Android Developers 최신 업데이트를 확인해 Stable로 사용한다. :contentReference[oaicite:4]{index=4}

---

## 7) Android 앱 아키텍처 규칙 (구현 강제)
### 7.1 레이어 구조
- ui/ : Compose 화면, 컴포넌트, navigation
- data/ : remote(api/dto), local(datastore), repository 구현
- domain/ : (선택이지만 권장) model, usecase, repository interface
- di/ : Hilt 모듈
- core/ : 공통 유틸, Result wrapper, error mapping, constants

### 7.2 상태 관리
- 각 Screen은 ViewModel 1개를 가진다.
- ViewModel은 StateFlow로 UIState를 노출한다.
- UI는 “상태 기반 렌더링(Loading/Success/Error/Empty)”만 한다.

### 7.3 네트워크/스토리지
- Retrofit 인터페이스(ApiService) + OkHttp Interceptor
- AccessToken(있다면) DataStore 저장
- ProfileId / nfcToken 저장
- MOCK_MODE일 때는 네트워크 호출 대신 MockDataSource 사용

---

## 8) 파일 구조(최종 목표 트리, Android만 우선)
> “oracle/monorepo”를 유지하되, Android는 아래 구조를 절대 기준으로 맞춘다.

oracle/
└── apps/
    └── android/
        ├── README_SETUP.md
        ├── TEST_GUIDE.md
        ├── PROJECT_STATE_ANDROID.md
        └── app/
            └── src/main/java/com/rsr41/oracle/
                ├── OracleApplication.kt
                ├── di/
                │   └── AppModule.kt
                ├── core/
                │   ├── Constants.kt
                │   ├── Result.kt
                │   └── UiState.kt
                ├── data/
                │   ├── local/
                │   │   └── PreferencesManager.kt
                │   ├── remote/
                │   │   ├── ApiService.kt
                │   │   ├── NetworkClient.kt
                │   │   └── dto/
                │   │       ├── TagResponse.kt
                │   │       ├── ProfileRequest.kt
                │   │       ├── FortuneResponse.kt
                │   │       ├── ConsultantDto.kt
                │   │       └── ProductDto.kt
                │   └── repository/
                │       ├── OracleRepository.kt
                │       ├── ConsultantRepository.kt
                │       └── ProductRepository.kt
                ├── domain/ (권장)
                │   ├── model/
                │   ├── repository/
                │   └── usecase/
                └── ui/
                    ├── MainActivity.kt
                    ├── navigation/
                    │   ├── Routes.kt
                    │   └── NavGraph.kt
                    ├── screens/
                    │   ├── SplashScreen.kt
                    │   ├── TagEntryScreen.kt
                    │   ├── ProfileScreen.kt
                    │   ├── HomeScreen.kt
                    │   ├── FortuneScreen.kt
                    │   ├── TarotScreen.kt
                    │   ├── WeatherScreen.kt
                    │   ├── AmuletScreen.kt
                    │   ├── ConsultantListScreen.kt
                    │   ├── ConsultantDetailScreen.kt
                    │   ├── BookingScreen.kt
                    │   ├── HistoryScreen.kt
                    │   └── FaceInsightScreen.kt
                    ├── components/
                    │   ├── TopAppBarOracle.kt
                    │   ├── BottomTabs.kt
                    │   ├── OracleCard.kt
                    │   ├── OracleChips.kt
                    │   ├── FortuneScoreCard.kt
                    │   ├── FortuneSummaryCard.kt
                    │   ├── ConsultantCard.kt
                    │   └── ProductCard.kt
                    └── theme/
                        ├── Color.kt
                        ├── Type.kt
                        └── Theme.kt

---

## 9) 네비게이션(Screen Flow) (절대 기준)
[Splash] (딥링크 처리)
  - 딥링크 토큰 있으면 → TagEntry
  - 없으면 → Home(탭)

[TagEntry] (NFC 진입)
  - token 확인 → /public/tag/:token 검증(또는 mock)
  - token 바인딩 → /public/tag/:token/bind
  - 프로필 없으면 Profile로 이동

[Profile] (프로필 입력/저장)
  - 저장 성공 → Home

[Home Tabs]
- Home
- Fortune
- Tarot
- Weather
- Amulet

전역 접근:
- FaceInsight (관상 분석) (Phase 2에서 활성화 가능)

---

## 10) 딥링크 + NFC + PWA 연결 (Phase 1.5~2)
### 10.1 딥링크
- Custom scheme: oracle://tag/{token}
- HTTPS App Links: https://yourdomain.com/tag/{token}
- Splash에서 intent를 파싱해 token이 있으면 TagEntry로 라우팅

### 10.2 NFC
- NFC 스캔 시 token을 얻는다.
- token이 있으면 앱 내부에서 TagEntry로 이동(동일 처리)
- NDEF/URI record를 우선 지원한다.

### 10.3 PWA Custom Tabs
- token 기반 URL을 Custom Tabs로 연다:
  - https://yourdomain.com/tag/{token}
- “태그 찍자마자 즉시 결과” 요구사항을 위해:
  - 앱 내 결과 화면 로딩 + PWA 열기 중 하나를 선택 가능
  - Phase 1에서는 “앱 내부 결과” 우선 + 보조로 PWA 버튼 제공

---

## 11) MOCK 모드 (초보자 필수)
> 백엔드가 없거나 불안정할 때도 앱이 무조건 돌아가게 만든다.

- BuildConfig.MOCK_MODE boolean을 둔다.
- true일 때:
  - fortune/today, checkin, tag verify/bind, consultants, products는 MockDataSource에서 반환
- false일 때:
  - Retrofit 실제 호출

Mock 데이터 요구사항:
- 홈 점수(예: 85)
- preview 1~2줄
- full 4~6줄
- categories(연애/금전/건강/직장 점수)
- 주간/월간은 Phase 2로 미룸(또는 더미로만)

---

## 12) 완료 기준 (Acceptance Criteria) — Phase 1
아래가 되면 “MVP 1차 완성”으로 간주한다.

1) 앱 실행 시 크래시 없음
2) Splash → Home 진입 OK
3) Profile 입력 저장 OK (DataStore 저장 확인)
4) Home에 점수/요약/추천/성향/프로모션/날씨연계 카드가 표시됨(더미 가능)
5) Fortune 탭에서
   - 필터 UI 존재
   - 오늘 운세 preview 표시
   - 체크인 버튼(1일 1회)이 있고, 체크인 후 full이 unlock되어 표시됨
6) History 탭(또는 내정보 내부)에서
   - 오늘 운세 기록이 리스트로 쌓임(최소 7일)
7) MOCK_MODE=true에서 모든 플로우가 동작
8) MOCK_MODE=false로 바꾸면 실제 API 호출 시도(서버 없으면 에러 UI 표시)

---

## 13) Phase 2 이후(확장 구현 규칙)
- 상담/타로/부적/날씨는 Phase 1에서는 UI/더미만 허용
- Phase 2부터 순서:
  1) 상담 마켓플레이스(리스트/상세/예약/리뷰)
  2) 프리미엄(주간/월간/궁합) + 잠금해제(결제는 마지막)
  3) 부적/굿즈(리스트/상세/장바구니/주문)
  4) 관상 분석 실제 업로드/결과
  5) 알림/통계/피드/검색

---

## 14) “ChatGPT에게 코딩을 시킬 때” 사용할 요청 템플릿(복붙용)
### 14.1 첫 요청(프로젝트 초기 셋업)
- 목표: Compose + Navigation + BottomTabs + Theme + Home/Fortune/Tarot/Weather/Amulet 뼈대

요청문(복붙):
“너는 상용 앱 경험 많은 시니어 Android 엔지니어다.
내 프로젝트는 oracle/apps/android이고, 이 문서(ANDROID_APP_BUILD_SPEC.md)가 절대 기준이다.
지금 단계 목표는 Phase 1의 ‘앱 뼈대’다.

필수:
- Kotlin + Jetpack Compose + Navigation Compose
- BottomTabs 5개(홈/운세/타로/날씨/부적)
- HomeScreen과 FortuneScreen 기본 UI 구성
- ViewModel + UiState + Repository 구조 잡기(빈 구현 가능)
- MOCK_MODE 토글 구조 만들기

출력 형식:
1) 수정/추가할 파일 목록
2) 각 파일별로 ‘어디를 수정’하는지 단계별
3) 새 파일은 전체 코드 제공
4) 빌드/실행 방법, 확인 방법”

### 14.2 두번째 요청(오늘의 운세 기능)
“Phase 1에서 TodayFortune + Check-in + Unlock + History를 구현해줘.
MOCK_MODE=true일 때 완전 동작해야 하고, false일 때는 ApiService 호출하도록 연결해줘.
UI는 FortuneScreen에 preview/full을 나누고 잠금 UI를 보여줘.”

---

## 15) 주의사항(필수)
- 기능을 추가하거나 화면 구조를 바꾸고 싶으면, 먼저 이 문서를 수정하고 그 다음 구현한다.
- 임의로 탭 이름/화면 이름/데이터 모델 필드를 바꾸지 않는다.
- 모든 네트워크 실패는 “에러 화면/배너/재시도 버튼”으로 처리한다(크래시 금지).

---
(끝)
