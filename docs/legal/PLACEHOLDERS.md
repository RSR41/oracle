# 법적 문서 Placeholder 목록

스토어 제출 전 아래 placeholder를 모두 실제 정보로 교체해야 합니다.

---

## 치환 대상 목록

| Placeholder | 설명 | 적용 파일 |
|-------------|------|-----------|
| `TODO(FILL_ME): 회사명` | 서비스 운영 회사/개인 이름 | terms_of_service.md, privacy_policy.md |
| `TODO(FILL_ME): 대표자명` | 대표자 또는 운영자 성명 | terms_of_service.md |
| `TODO(FILL_ME): 이메일` | 대표 연락 이메일 주소 | terms_of_service.md, privacy_policy.md |
| `TODO(FILL_ME): 주소` | 사업장 소재지 | terms_of_service.md |
| `TODO(FILL_ME): 개인정보보호책임자명` | 개인정보 보호책임자 성명 | privacy_policy.md |
| `TODO(FILL_ME): 연락처` | 개인정보 관련 문의 전화번호 | privacy_policy.md |

---

## 교체 방법

### 방법 1: 직접 편집
1. `docs/legal/terms_of_service.md` 열기
2. Ctrl+H (찾아바꾸기)로 `TODO(FILL_ME): 회사명` → 실제 회사명
3. 나머지 placeholder도 동일하게 교체
4. `docs/legal/privacy_policy.md`도 동일하게 진행

### 방법 2: 스크립트 사용 (PowerShell)
```powershell
# 예시: 회사명 일괄 교체
$files = @("docs/legal/terms_of_service.md", "docs/legal/privacy_policy.md")
foreach ($file in $files) {
    (Get-Content $file) -replace 'TODO\(FILL_ME\): 회사명', '실제회사명' | Set-Content $file
}
```

---

## 교체 완료 체크리스트

- [ ] `TODO(FILL_ME): 회사명` → 실제 회사명 또는 개인 이름
- [ ] `TODO(FILL_ME): 대표자명` → 대표자 실명
- [ ] `TODO(FILL_ME): 이메일` → 실제 연락 가능한 이메일
- [ ] `TODO(FILL_ME): 주소` → 사업장 또는 거주지 주소
- [ ] `TODO(FILL_ME): 개인정보보호책임자명` → 책임자 실명
- [ ] `TODO(FILL_ME): 연락처` → 실제 전화번호

---

## 교체 후 검증

1. `grep -r "TODO(FILL_ME)" docs/legal/` 실행
2. 결과가 없으면 모든 placeholder 교체 완료
3. 웹 배포 후 모바일에서 페이지 표시 확인

---

> ⚠️ **중요**: placeholder가 남아있으면 스토어 심사에서 거부될 수 있습니다.
