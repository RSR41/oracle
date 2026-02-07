# README: Porting Documentation

## 원본 React 기준 경로
`oracle/figma_tools/figma_1`

## 참고 문서
- [PORTING_SNAPSHOT.md](./PORTING_SNAPSHOT.md) (로컬 복사본)
- [BUG_REPORT_REACT.md](./BUG_REPORT_REACT.md) (로컬 복사본)

원본 위치:
- `../../../../figma_tools/figma_1/PORTING_SNAPSHOT.md`
- `../../../../figma_tools/figma_1/BUG_REPORT_REACT.md`

## 이 단계(Phase 11)에서 한 일
1. Flutter 프로젝트 생성 (`flutter create`)
2. 포팅용 스캐폴딩 폴더/파일 구성
3. `flutter analyze` 통과 검증

## 다음 단계 TODO
| Phase | 파일 | 작업 내용 |
|-------|------|----------|
| 22 | `app_colors.dart`, `app_theme.dart` | theme.css 토큰 완전 이식 |
| 33 | `translations.dart`, `app_state.dart` | AppContext.tsx 번역 161키 이식 |
| 44 | `app_nav.dart` | App.tsx 라우팅 로직 구현 |
| 55 | `lib/widgets/` | 공통 컴포넌트 포팅 |
| 66 | `lib/screens/` | 화면별 UI 구현 |
