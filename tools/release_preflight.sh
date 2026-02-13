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
