# Build Status & Guide

## Project Info
- **Framework**: React 18 + Vite + TypeScript
- **Path**: `C:\Users\qkrtj\destiny\oracle\figma_mockup\Fortunetellingappdesign-main`

## Status
- **Analysis**: 소스 코드 구조 및 디자인 토큰 분석 완료.
- **Dependency Install**: `npm install` 실행 중 (네트워크/시스템 환경에 따라 지연 중).
- **Build**: 의존성 설치 완료 후 가능.

## How to Run (Local)
이 폴더에서 터미널을 열고 다음 명령어를 순서대로 실행하세요.

### 1. Install Dependencies
```bash
npm install
```
(이미 진행 중이라면 완료될 때까지 대기)

### 2. Dev Server Start (실행)
```bash
npm run dev
```
- 성공 시: `http://localhost:5173` (또는 유사 URL)이 출력됩니다.
- 브라우저로 해당 URL에 접속하여 앱을 확인하세요.

### 3. Production Build (검증용)
```bash
npm run build
```
- 타입스크립트 에러 없이 `dist/` 폴더가 생성되면 소스 무결성 확인 완료.

## Troubleshooting
- **Node Version**: v18.0.0 이상 권장.
- **Permission**: Windows 권한 문제 발생 시 관리자 권한 터미널 사용.
- **Cache**: `npm install` 실패 시 `node_modules` 폴더 삭제 후 재시도.
