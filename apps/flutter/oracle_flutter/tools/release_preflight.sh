#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

pass() { echo "✅ $1"; }
warn() { echo "⚠️  $1"; }
fail() { echo "❌ $1"; exit 1; }

echo "[ORACLE] Mobile release preflight check"

[[ -f pubspec.yaml ]] || fail "pubspec.yaml not found"
pass "pubspec.yaml found"

if rg -q '^version:' pubspec.yaml; then
  VERSION_LINE="$(rg '^version:' pubspec.yaml | head -n1)"
  pass "App version set: $VERSION_LINE"
else
  fail "version is missing in pubspec.yaml"
fi

[[ -f android/app/build.gradle.kts ]] || fail "android/app/build.gradle.kts missing"
pass "Android Gradle config found"

if [[ -f android/key.properties ]]; then
  pass "android/key.properties found"
else
  warn "android/key.properties missing (release signing will fail)"
fi

if [[ -f ios/Runner/Info.plist ]]; then
  pass "iOS Info.plist found"
else
  fail "ios/Runner/Info.plist missing"
fi

if rg -q 'PRODUCT_BUNDLE_IDENTIFIER = com.destiny.oracle;' ios/Runner.xcodeproj/project.pbxproj; then
  pass "iOS bundle identifier configured"
else
  warn "Bundle identifier check did not match expected value (com.destiny.oracle)"
fi

if command -v flutter >/dev/null 2>&1; then
  pass "Flutter CLI available"
else
  warn "Flutter CLI not installed in current environment"
fi

echo ""
echo "Preflight complete."
