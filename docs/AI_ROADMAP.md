# AI 기능 확장 로드맵

본 문서는 Oracle 사주 앱에 AI 기능을 추가하기 위한 Phase별 계획입니다.

> ⚠️ **현재 상태**: 네트워크 전송 없음, ML Kit 미사용. 스토어 제출에 AI는 필수가 아닙니다.

---

## Phase 3: 온디바이스 AI - ML Kit Face Detection

### 목표
얼굴 이미지 업로드 → ML Kit 기반 특징 추출 → 관상학적 해석 제공

### 의존성 추가
```yaml
# pubspec.yaml
dependencies:
  google_mlkit_face_detection: ^0.10.0
```

### 필요 권한
```xml
<!-- android/app/src/main/AndroidManifest.xml -->
<uses-permission android:name="android.permission.CAMERA" />
```

### 구현 파일
| 파일 | 설명 |
|------|------|
| `lib/app/services/face_detection_service.dart` | ML Kit 얼굴 검출 래퍼 |
| `lib/app/models/face_characteristics.dart` | 얼굴 특징 데이터 모델 |
| `lib/app/services/physiognomy_rule_engine.dart` | 랜드마크 → 성격/운세 매핑 |

### 처리 흐름
```
1. 이미지 선택 (image_picker)
   ↓
2. ML Kit FaceDetector.processImage()
   ↓
3. Face 객체에서 랜드마크 추출
   - 눈 간격/크기
   - 코 길이/폭
   - 입 모양
   - 얼굴 윤곽
   ↓
4. PhysiognomyRuleEngine으로 해석 생성
   ↓
5. 결과 로컬 저장 (sqflite)
```

### 개인정보 영향
- **변경 없음**: 이미지가 서버로 전송되지 않음
- `privacy_policy.md` 수정 불필요

---

## Phase 4: 서버형 AI - LLM 통합 (선택)

### 목표
사주/타로/꿈해몽/관상 결과를 LLM으로 자연어 요약 및 개인화

### 아키텍처 옵션

#### 옵션 A: 클라우드 LLM 직접 호출 (간단)
```
Flutter App → Gemini API (직접)
```
- 장점: 백엔드 불필요
- 단점: API 키 노출 위험, 비용 관리 어려움

#### 옵션 B: 백엔드 프록시 (권장)
```
Flutter App → oracle/backend → Gemini/OpenAI API
```
- 장점: API 키 안전, 비용 제어, 캐싱 가능
- 단점: 백엔드 배포 필요

### 백엔드 엔드포인트 설계

#### POST /api/fortune/generate
```json
// Request
{
  "type": "saju" | "tarot" | "dream" | "face",
  "input": {
    "birthDate": "1990-01-15",
    "birthTime": "14:30",
    "gender": "male"
  }
}

// Response
{
  "summary": "오늘은 창의력이 빛나는 날입니다...",
  "details": {
    "career": "...",
    "love": "...",
    "health": "..."
  }
}
```

#### POST /api/face/analyze
```json
// Request (이미지 업로드)
{
  "imageBase64": "...",
  "analysisType": "physiognomy"
}

// Response
{
  "characteristics": {...},
  "interpretation": "당신의 얼굴에서 리더십이..."
}
```

### 보안 고려사항
1. **API 키 관리**: 백엔드 `.env`에만 저장, 앱에 노출 금지
2. **Rate Limiting**: 사용자당 요청 제한
3. **비용 제어**: 일일/월간 사용량 제한

### 개인정보 영향
- **중요 변경**: 이미지/개인정보가 서버로 전송됨
- `privacy_policy.md` 수정 필요:
  - "서버 전송: ❌ 없음" → "서버 전송: ✅ 있음 (AI 분석 시)"
  - AI 분석 목적 추가
  - 데이터 보관 정책 추가

---

## Phase 5: 하이브리드 접근 (비용 최적화)

### 전략
1. **기본 결과**: 규칙 기반 (무료)
2. **상세 분석**: LLM 호출 (사용자 요청 시)

### UI 설계
```
┌─────────────────────────┐
│ 오늘의 운세 결과        │
│ (규칙 기반 기본 분석)   │
├─────────────────────────┤
│ [AI 상세 분석 받기] 버튼 │  ← 탭 시 LLM 호출
└─────────────────────────┘
```

### 구현 파일
| 파일 | 설명 |
|------|------|
| `lib/app/services/fortune_narrative_provider.dart` | 추상 인터페이스 |
| `lib/app/services/template_narrative_provider.dart` | 규칙 기반 구현 |
| `lib/app/services/llm_narrative_provider.dart` | LLM 연동 구현 |

---

## 권장 순서

1. **현재 상태로 스토어 제출** (AI 없이 MVP 출시)
2. **Phase 3**: ML Kit 관상 기능 고도화 (2주)
3. **Phase 4/5**: LLM 통합 검토 (사용자 피드백 후)

---

## 참고: backend 디렉토리 현황

```
oracle/backend/
├── src/
│   ├── auth/         ← 인증 모듈
│   ├── face/         ← 관상 분석 엔드포인트 (확장 가능)
│   ├── history/      ← 히스토리 관리
│   ├── tags/         ← 태그 관리
│   └── main.ts       ← NestJS 진입점
├── prisma/
│   └── schema.prisma ← DB 스키마
└── .env.example      ← 환경변수 템플릿
```

현재 Flutter 앱은 이 백엔드를 호출하지 않습니다. AI 기능 추가 시 연동 가능합니다.
