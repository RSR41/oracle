# 콘텐츠 데이터베이스 (Content DB)

앱 내의 타로, 사주, 꿈해몽, 관상 데이터는 Room Database를 통해 구조적으로 관리됩니다.

## 1. 데이터베이스 구조

### Entity
- **TarotCardEntity**: 22장의 메이저 아르카나 타로 카드 정보 (한/영 이름, 정/역방향 해석, 키워드, 이미지 경로)
- **SajuContentEntity**: 오행, 십신, 천간, 지지 등 사주 관련 기초 데이터 (한/영 설명, 속성)
- **DreamInterpretationEntity**: 꿈해몽 데이터 (키워드, 카테고리, 길몽/흉몽 여부, 해석, 관련어)
- **FaceAnalysisResultEntity**: 관상 분석 결과 저장소 (얼굴형, 이마/눈/코/입 분석 내역, 종합 해석)

### DAO
- **TarotCardDao**: 타로 카드 조회 (전체, ID별, 랜덤)
- **SajuContentDao**: 사주 콘텐츠 조회 (타입별, 코드별)
- **DreamDao**: 꿈해몽 검색 (키워드/동의어 검색, 카테고리 필터링)
- **FaceAnalysisDao**: 관상 결과 저장 및 조회

## 2. Seed Data & Initialization

앱 최초 실행 시 `assets/seed/` 폴더의 JSON 데이터를 읽어와 DB를 초기화합니다.

- **파일 위치**:
  - `assets/seed/tarot_cards.json`: 타로 카드 데이터
  - `assets/seed/saju_content.json`: 사주 기초 데이터
  - `assets/seed/dream_interpretations.json`: 꿈해몽 데이터

- **DatabaseSeeder**: `OracleApplication` 시작 시 비동기로 실행되며, 데이터가 없을 경우에만 Insert를 수행하여 성능 저하를 방지합니다.
