# Next Steps: Release Candidate & Beyond

이 문서는 1차 출시(사주 MVP)를 위한 잔여 과제 및 차기 릴리즈 우선순위를 정의합니다.

---

## 0. MVP/베타 범위 정의 (SSOT)

### MVP (항상 접근 가능, BETA_FEATURES=false에서도 노출)
1. **사주**: 생년월시 기반 사주 풀이
2. **만세력**: 캘린더 기반 운세 조회
3. **타로**: 3장 카드 뽑기 및 해석
4. **꿈해몽**: 꿈 내용 입력 후 해석
5. **관상**: 얼굴 이미지 업로드/촬영 → 분석 결과 출력

### 베타 (BETA_FEATURES=true일 때만 노출)
1. **소개팅**: oracle_meeting 패키지 전체
2. **이상형 생성**: 나와 잘맞는 사주의 이성 이미지 생성

---

## 1. 1차 출시(RC) 직전 준비 (Must-Have)
출시 전 반드시 완료해야 할 최소한의 패키징 및 법적 요구사항입니다.

- [x] **베타 격리 검증**: `BETA_FEATURES=false`로 MVP 5개 기능 접근 가능 확인
- [x] **이용약관/방침 추가**: 설정 화면에서 외부 URL 링크 연결 구현 (Phase E-7)
- [ ] **스토어 자산 준비**: 앱 아이콘(1024x1024), 스플래시 화면, 설명문.
- [ ] **법적 URL 교체**: `app_urls.dart`의 placeholder URL을 실제 URL로 변경
- [ ] **패키지명/버전 확정**: `pubspec.yaml` 및 `build.gradle`의 `applicationId` 최종 확인.
- [ ] **에러 로깅 도입**: Crashlytics(Firebase) 연동을 통한 출시 후 크래시 추적.

---

## 2. Phase 3: 관상 AI 통합 (ML Kit)

### 목표
얼굴 이미지 업로드 → ML Kit 기반 특징 추출 → 관상학적 해석 제공

### 작업 순서
1. **ML Kit 통합**
   - [ ] `pubspec.yaml`에 `google_mlkit_face_detection` 추가
   - [ ] `FaceDetectionService` 클래스 생성
   - [ ] 얼굴 검출 및 랜드마크 추출 구현
   - [ ] 얼굴 미검출 시 사용자 친화적 에러 메시지

2. **규칙 기반 해석 생성**
   - [ ] `FaceCharacteristics` 모델 클래스 생성
   - [ ] `PhysiognomyRuleEngine` 클래스 생성
   - [ ] 랜드마크 → 성격/운세 매핑 규칙 정의

### 예상 변경 파일
- NEW: `lib/app/services/face_detection_service.dart`
- NEW: `lib/app/models/face_characteristics.dart`
- MODIFY: `lib/app/screens/face/face_screen.dart`
- MODIFY: `pubspec.yaml`

---

## 3. Phase 4: LLM 기반 결과 생성 (선택적)

### 목표
사주/타로/꿈해몽/관상 결과를 LLM으로 자연어 요약 및 개인화

### 전략: 비용 최소화
1. **온디바이스 LLM 우선** (가능하면)
2. **클라우드 LLM은 최후 수단** (Gemini 1.5 Flash 무료 티어)
3. **하이브리드 접근**: 규칙 기반 기본 제공, "AI 요약" 버튼 탭 시에만 LLM 호출

### 예상 변경 파일
- NEW: `lib/app/services/fortune_narrative_provider.dart`
- NEW: `lib/app/services/template_narrative_provider.dart`
- NEW: `lib/app/services/llm_narrative_provider.dart`
- NEW: `lib/app/services/llm_output_validator.dart`

---

## 4. 출시 후 단기 고도화 (Nice-to-Have)
사용자 피드백을 기반으로 한 제품 퀄리티 향상 과제입니다.

- **사주 시나리오 E2E 테스트**: 입력 → 결과 → 저장 → 히스토리 → 공유의 전체 흐름 자동 검증.
- **공유 기능 강화**: 결과 화면을 이미지로 캡처하여 카카오톡/인스타그램에 공유 (Share Plus 사용).
- **데이터 백업**: 구글/애플 로그인 연동을 통한 SQLite 데이터 클라우드 동기화.

---

## 5. 우선순위 요약 (Top 5)

| 순위 | 태스크 | DoD (Definition of Done) | 상태 |
| :--- | :--- | :--- | :--- |
| **1** | **MVP/베타 범위 복구** | MVP 5개(사주/만세력/타로/꿈해몽/관상) 항상 접근 가능 | ✅ 완료 |
| **2** | **이용약관/방침 추가** | 설정 화면에서 외부 URL 링크 노출 및 작동 | ✅ 완료 |
| **3** | **법적 URL 교체** | placeholder URL을 실제 URL로 변경 | ⏳ 수동 작업 필요 |
| **4** | **관상 AI (ML Kit)** | 얼굴 검출 및 규칙 기반 해석 제공 | 🔜 Phase 3 |
| **5** | **아이콘/스플래시 적용** | 실제 기기에서 앱 설치 시 고유 아이콘 노출 | ⏳ 진행 필요 |

---

## 6. 제외 대상 (Post-Release)
- **PWA 도입**: 현재 Flutter Web 지원이 고려되지 않으므로 차기 과제로 분리.
- **NFC 연동**: 오프라인 연동 기능은 2.0 버전 이후로 보류.
