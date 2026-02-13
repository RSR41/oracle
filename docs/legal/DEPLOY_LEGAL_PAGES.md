# 법적 문서 배포 가이드

본 문서는 Oracle 사주 앱의 이용약관 및 개인정보처리방침을 외부 URL로 배포하는 구체적인 방법입니다.

---

## 배포 방식: GitHub Pages (권장)

이 레포지토리는 GitHub Pages 배포가 설정되어 있습니다.

### 1단계: GitHub 저장소 설정

1. GitHub에서 이 레포지토리 열기
2. **Settings** → **Pages** 이동
3. 아래와 같이 설정:
   - **Source**: `Deploy from a branch`
   - **Branch**: `main` (또는 기본 브랜치)
   - **Folder**: `/docs`
4. **Save** 클릭

### 2단계: 배포 확인

설정 후 1-2분 내에 다음 URL에서 접근 가능:

```
이용약관:
https://oracle-saju.github.io/oracle/legal/terms_of_service

개인정보처리방침:
https://oracle-saju.github.io/oracle/legal/privacy_policy
```

예시 (username이 `destiny-saju`인 경우):
```
https://destiny-saju.github.io/oracle/legal/terms_of_service
https://destiny-saju.github.io/oracle/legal/privacy_policy
```

### 3단계: 앱에 URL 적용

#### 방법 A: app_urls.dart 직접 수정 (개발용)
```dart
// lib/app/config/app_urls.dart
static const String termsOfService = 'https://oracle-saju.github.io/oracle/legal/terms_of_service';
static const String privacyPolicy = 'https://oracle-saju.github.io/oracle/legal/privacy_policy';
```

#### 방법 B: dart-define으로 빌드 시 주입 (릴리즈용)
```powershell
flutter build appbundle --release `
  --dart-define=TERMS_URL=https://oracle-saju.github.io/oracle/legal/terms_of_service `
  --dart-define=PRIVACY_URL=https://oracle-saju.github.io/oracle/legal/privacy_policy
```

---

## 배포 전 체크리스트

### placeholder 교체 확인
```powershell
# Windows PowerShell
Select-String -Path "docs\legal\*.md" -Pattern "TODO\(FILL_ME\)"
```

결과가 **없으면** 모든 placeholder 교체 완료.

### URL 접근 확인
- [ ] 이용약관 URL이 HTTPS로 접근 가능한가?
- [ ] 개인정보처리방침 URL이 HTTPS로 접근 가능한가?
- [ ] 모바일 브라우저에서 정상 표시되는가?
- [ ] 404 에러 없이 페이지가 로드되는가?

### 앱 내 동작 확인
- [ ] 설정 화면에서 "이용약관" 탭 시 브라우저 열림
- [ ] 설정 화면에서 "개인정보처리방침" 탭 시 브라우저 열림
- [ ] SnackBar 에러 메시지 없음 (placeholder가 아닌 실제 URL 사용 시)

---

## 커스텀 도메인 설정 (선택)

GitHub Pages에 커스텀 도메인을 연결하려면:

### 1단계: CNAME 파일 생성
`docs/CNAME` 파일 생성:
```
legal.yourdomain.com
```

### 2단계: DNS 설정
도메인 DNS에 CNAME 레코드 추가:
```
legal.yourdomain.com → oracle-saju.github.io
```

### 3단계: HTTPS 활성화
GitHub Pages 설정에서 "Enforce HTTPS" 활성화

---

## 트러블슈팅

### 문제: 페이지가 404
**확인사항**:
1. GitHub Pages 설정에서 Branch가 올바른가?
2. Folder가 `/docs`로 설정되어 있는가?
3. `docs/_config.yml` 파일이 존재하는가?
4. 커밋 후 1-2분 대기했는가?

### 문제: 마크다운이 렌더링되지 않음
**해결**: `docs/_config.yml`에 Jekyll 테마 설정이 있어야 함 (이미 추가됨)

### 문제: 링크가 깨짐
**확인**: baseurl 설정이 레포 이름과 일치하는지 확인
- `_config.yml`의 `baseurl: "/oracle"` 부분 확인

---

## 최종 URL 목록

| 페이지 | 경로 |
|--------|------|
| 인덱스 | `https://oracle-saju.github.io/oracle/` |
| 이용약관 | `https://oracle-saju.github.io/oracle/legal/terms_of_service` |
| 개인정보처리방침 | `https://oracle-saju.github.io/oracle/legal/privacy_policy` |

> ✅ 본 프로젝트 확정 GitHub 사용자명은 `oracle-saju`입니다.
