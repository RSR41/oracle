# SAJU Phase 1 Implementation Notes

## 목적
외부 기준안(절기 / 대운 / 강약)을 기존 ORACLE Flutter 사주 엔진에 단계적으로 반영하기 위한 구현 메모.

## 현재 이번 단계에서 반영한 것
1. `lib/app/services/saju/solar_terms.dart` 추가
   - `SolarTerm` enum
   - `SolarTermEntry`
   - `kSolarTermTable` 스캐폴드
   - `getSolarTermDateTime()`
   - `buildSolarTermSequence()`
   - `isNearSolarTermBoundary()`
2. `lib/app/services/saju/saju_service.dart` 연결 함수 초안 반영
   - `resolveSajuYear()`
   - `resolveSajuMonthIndex()`
   - `buildSajuWarnings()`
   - `calculate()`에서 위 함수 호출
   - 절기 테이블 부재 시 legacy fallback 유지
3. `SajuResult.warnings` 직렬화/역직렬화 연결

## 왜 먼저 스캐폴드부터 넣는가
- 절기 테이블(1900~2100)을 당장 수작업으로 넣는 것은 비효율적이다.
- 하지만 resolver 인터페이스를 먼저 고정해두면 이후 데이터 생성 스크립트를 붙이기 쉬워진다.
- 기존 근사 로직을 즉시 삭제하지 않고 병행 유지할 수 있다.

## 다음 반영 순서
### 1. 절기 계산
- `resolveSajuYear()` / `resolveSajuMonth()` 분리
- 테이블 데이터 존재 시 우선 사용
- 데이터 부재 시 legacy 근사값 fallback 유지
- 경계일/시간 미상 warning 생성

### 2. 대운 계산
- `DaewoonResult` / `DaewoonEntry` 구조 도입 검토
- `3일 = 1년`, `1일 = 4개월` 환산 로직 구현
- 기준 절기(다음/이전 절) 탐색 로직 연결

### 3. 강약 계산
- 기존 단일 문자열(`신강/중화/신약`)을 유지하되,
  내부적으로는 점수 기반 구조를 계산하도록 점진 전환
- 최소 목표:
  - 월령
  - 통근
  - 투간
  - 누수
  - 장간 지원
  - 합충 패널티

## 구현 원칙
- 기존 public API를 한 번에 깨지 않는다.
- 모델은 하위 호환 유지 우선.
- UI는 warning/factor 노출을 점진 적용.
- 절기 테이블이 비어 있어도 앱이 죽지 않게 fallback 보장.
