#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
FLUTTER_ROOT="${REPO_ROOT}/apps/flutter/oracle_flutter"
ANDROID_ROOT="${FLUTTER_ROOT}/android"
KEY_PROPS="${ANDROID_ROOT}/key.properties"
GRADLE_FILE="${ANDROID_ROOT}/app/build.gradle.kts"

fail_count=0
warn_count=0

pass() { echo "[PASS] $*"; }
warn() { echo "[WARN] $*"; warn_count=$((warn_count + 1)); }
fail() { echo "[FAIL] $*"; fail_count=$((fail_count + 1)); }

section() {
  echo
  echo "== $* =="
}

section "Android release signing 정책 검증"
if [[ ! -f "${KEY_PROPS}" ]]; then
  fail "${KEY_PROPS} 파일이 없습니다. 운영 배포는 실패 처리합니다."
else
  pass "key.properties 파일이 존재합니다."

  required_keys=(keyAlias keyPassword storeFile storePassword)
  for key in "${required_keys[@]}"; do
    value="$(awk -F'=' -v k="$key" '$1==k{print substr($0, index($0,$2))}' "${KEY_PROPS}" | tail -n 1 | xargs || true)"
    if [[ -z "${value}" ]]; then
      fail "key.properties 필수 키 누락: ${key}"
      continue
    fi
    if [[ "${value}" == *"YOUR_"* ]]; then
      fail "key.properties ${key}에 placeholder(YOUR_)가 남아 있습니다."
    else
      pass "${key} 값이 설정되어 있습니다."
    fi

    if [[ "${key}" == "storeFile" ]]; then
      store_file_path="${ANDROID_ROOT}/${value}"
      if [[ ! -f "${store_file_path}" ]]; then
        fail "storeFile 대상 keystore를 찾을 수 없습니다: ${store_file_path}"
      else
        pass "storeFile 대상 keystore가 존재합니다."
      fi
    fi
  done
fi

section "Gradle release fallback 금지 검증"
if rg -n "signingConfigs\.getByName\(\"debug\"\)" "${GRADLE_FILE}" >/dev/null; then
  fail "release 빌드에서 debug signing fallback 사용 흔적이 있습니다."
else
  pass "release 빌드의 debug signing fallback이 제거되어 있습니다."
fi

section "참고 점검 (경고 전용)"
if command -v flutter >/dev/null 2>&1; then
  if (cd "${FLUTTER_ROOT}" && flutter analyze >/dev/null); then
    pass "flutter analyze 통과"
  else
    fail "flutter analyze 실패"
  fi
else
  warn "flutter 명령을 찾을 수 없어 flutter analyze를 건너뜁니다."
fi

echo
if (( fail_count > 0 )); then
  echo "Preflight 실패: FAIL=${fail_count}, WARN=${warn_count}"
  exit 1
fi

echo "Preflight 성공: FAIL=0, WARN=${warn_count}"
