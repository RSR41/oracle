# Placeholder 값 템플릿

스토어 제출 전 아래 값들을 실제 정보로 입력하세요.

---

## 입력 항목

```yaml
# 1. 회사/운영자 정보
회사명: ""                    # 예: (주)오라클사주, 홍길동(개인사업자)
대표자명: ""                  # 예: 홍길동
주소: ""                      # 예: 서울특별시 강남구 테헤란로 123

# 2. 연락처
이메일: ""                    # 예: contact@example.com
연락처: ""                    # 예: 02-1234-5678 또는 010-1234-5678

# 3. 개인정보 담당
개인정보보호책임자명: ""       # 예: 홍길동 (대표자와 동일 가능)
```

---

## 교체 방법

위 값을 채운 후, 아래 PowerShell 명령으로 일괄 교체:

```powershell
cd oracle/docs/legal

# 1. 회사명 교체
(Get-Content terms_of_service.md, privacy_policy.md) -replace 'TODO\(FILL_ME\): 회사명', '실제회사명' | Set-Content -Path { $_.PSPath }

# 2. 수동 교체 권장 (정확성을 위해)
# 에디터에서 "TODO(FILL_ME):" 검색 후 직접 입력
```

---

## 교체 전 검증

```powershell
# placeholder 남아있는지 확인
Select-String -Path "docs\legal\*.md" -Pattern "TODO\(FILL_ME\)"
```

결과가 **비어있으면** 모든 교체 완료!

---

## GitHub 사용자명

GitHub Pages 배포 시 사용:

```yaml
github_username: ""           # 예: oracle-saju
```

이 값은 `lib/app/config/app_urls.dart`의 `YOUR_USERNAME` 부분에도 적용됩니다.
