# 법적 문서 기준값 (심사 제출 1:1 매핑)

이 문서는 **커밋 가능한 기준값 문서**입니다. 앱 내 법적 링크와 심사 제출 문서가 동일한 값을 사용하도록 관리합니다.

> 민감정보(비밀번호, 키스토어, 개인 전화번호 등)는 이 파일에 기록하지 말고 로컬 보안 저장소에서만 관리하세요.

---

## 1) 문서 치환 기준값

아래 값은 `terms_of_service.md`, `privacy_policy.md`에 동일하게 반영해야 합니다.

- 회사명: `Oracle 사주`
- 대표자명(운영자): `Oracle 사주 운영팀`
- 이메일: `support@oracle-saju.com`
- 주소: `대한민국 서울특별시`
- 개인정보보호책임자명: `Oracle 사주 운영팀`
- 개인정보 연락처: `support@oracle-saju.com`

---

## 2) 앱 노출 방식 기준 (외부 URL 열기)

앱은 인앱 고정 문구가 아니라 **외부 URL 열기 방식**을 사용합니다.

- 이용약관: `https://oracle-saju.github.io/oracle/legal/terms_of_service`
- 개인정보처리방침: `https://oracle-saju.github.io/oracle/legal/privacy_policy`

해당 URL은 아래 파일과 1:1로 일치해야 합니다.

- `apps/flutter/oracle_flutter/lib/app/config/app_urls.dart`
- `docs/legal/terms_of_service.md`
- `docs/legal/privacy_policy.md`

---

## 3) 운영 원칙

1. 문서 본문의 placeholder를 커밋 전 모두 실제값으로 치환합니다.
2. 법적 문서 링크는 앱의 모든 설정 화면에서 `AppUrls` 값으로 단일화합니다.
3. 스토어 제출 시 기입하는 약관/개인정보 URL은 본 문서의 URL과 동일하게 유지합니다.
