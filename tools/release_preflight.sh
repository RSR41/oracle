#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FLUTTER_DIR="$ROOT_DIR/apps/flutter/oracle_flutter"
ANDROID_DIR="$FLUTTER_DIR/android"
IOS_PROJECT="$FLUTTER_DIR/ios/Runner.xcodeproj/project.pbxproj"

PASS_COUNT=0
WARN_COUNT=0
FAIL_COUNT=0

pass() { echo "[PASS] $1"; PASS_COUNT=$((PASS_COUNT+1)); }
warn() { echo "[WARN] $1"; WARN_COUNT=$((WARN_COUNT+1)); }
fail() { echo "[FAIL] $1"; FAIL_COUNT=$((FAIL_COUNT+1)); }

require_file() {
  local file="$1"
  if [[ -f "$file" ]]; then
    pass "파일 존재: ${file#$ROOT_DIR/}"
  else
    fail "파일 누락: ${file#$ROOT_DIR/}"
  fi
}

check_android_keystore_path() {
  local key_props="$ANDROID_DIR/key.properties"
  local key_example="$ANDROID_DIR/key.properties.example"
  require_file "$key_example"

  if [[ ! -f "$key_props" ]]; then
    warn "android/key.properties 없음 (로컬/CI에서 주입 필요)"
    return
  fi

  local store_file
  store_file="$(sed -n 's/^storeFile=//p' "$key_props" | tail -n 1 | tr -d '\r')"
  if [[ -z "$store_file" ]]; then
    fail "android/key.properties에 storeFile이 없습니다"
    return
  fi

  local resolved
  resolved="$(cd "$ANDROID_DIR" && python - <<PY
from pathlib import Path
print(Path('$store_file').resolve())
PY
)"

  if [[ -f "$resolved" ]]; then
    pass "Android keystore 경로 유효: $store_file"
  else
    fail "Android keystore 파일 없음: $store_file (resolved: $resolved)"
  fi

  if grep -q 'YOUR_' "$key_props"; then
    fail "android/key.properties에 placeholder(YOUR_) 값이 남아 있습니다"
  else
    pass "android/key.properties placeholder 제거 확인"
  fi
}

check_ios_signing_policy() {
  require_file "$IOS_PROJECT"
  [[ -f "$IOS_PROJECT" ]] || return

  local sections
  sections="$(awk '
    /97C147061CF9000F007C117D \/\* Debug \*\//,/name = Debug;/ { print }
    /97C147071CF9000F007C117D \/\* Release \*\//,/name = Release;/ { print }
    /249021D4217E4FDB00AE95B9 \/\* Profile \*\//,/name = Profile;/ { print }
  ' "$IOS_PROJECT")"

  if [[ "$sections" == *'CODE_SIGN_STYLE = Automatic;'* ]]; then
    pass "iOS CODE_SIGN_STYLE = Automatic"
  else
    fail "iOS CODE_SIGN_STYLE 설정 누락/불일치"
  fi

  if [[ "$sections" == *'DEVELOPMENT_TEAM = "$(ORACLE_IOS_TEAM_ID)";'* ]]; then
    pass "iOS DEVELOPMENT_TEAM = \$(ORACLE_IOS_TEAM_ID)"
  else
    fail "iOS DEVELOPMENT_TEAM 설정 누락/불일치"
  fi

  if [[ "$sections" == *'PROVISIONING_PROFILE_SPECIFIER = "";'* ]]; then
    pass "iOS PROVISIONING_PROFILE_SPECIFIER는 빈 값(Automatic 관리)"
  else
    fail "iOS PROVISIONING_PROFILE_SPECIFIER 설정 누락/불일치"
  fi
}

echo "== Oracle release preflight =="
check_android_keystore_path
check_ios_signing_policy

echo ""
echo "Summary: PASS=$PASS_COUNT WARN=$WARN_COUNT FAIL=$FAIL_COUNT"
if [[ "$FAIL_COUNT" -gt 0 ]]; then
  exit 1
fi
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
