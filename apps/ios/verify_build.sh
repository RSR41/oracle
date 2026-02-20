#!/bin/bash
# 파일명: verify_build.sh
# 위치: oracle/apps/ios/
# 실행: cd apps/ios && bash verify_build.sh

set -e

PROJECT_PATH="OracleIOS.xcodeproj"
SCHEME="OracleIOS"
DESTINATION="platform=iOS Simulator,name=iPhone 15 Pro"

echo "🔍 Oracle iOS 빌드 검증 시작..."
echo ""

# 프로젝트 존재 확인
if [ ! -d "$PROJECT_PATH" ]; then
    echo "❌ Xcode 프로젝트가 없습니다."
    echo "   먼저 ./setup_xcode_project.sh 를 실행하세요."
    exit 1
fi

# 1. 클린 빌드
echo "🧹 1/3 클린..."
xcodebuild clean \
    -project "$PROJECT_PATH" \
    -scheme "$SCHEME" \
    -quiet 2>/dev/null || true

# 2. 빌드
echo "🔨 2/3 빌드..."
BUILD_START=$(date +%s)

xcodebuild build \
    -project "$PROJECT_PATH" \
    -scheme "$SCHEME" \
    -destination "$DESTINATION" \
    -quiet 2>&1 | tee build.log

BUILD_RESULT=$?
BUILD_END=$(date +%s)
BUILD_TIME=$((BUILD_END - BUILD_START))

if [ $BUILD_RESULT -eq 0 ]; then
    echo "   ✅ 빌드 성공 (${BUILD_TIME}초)"
else
    echo "   ❌ 빌드 실패"
    echo ""
    echo "에러 로그 (마지막 30줄):"
    tail -30 build.log
    echo ""
    echo "전체 로그: build.log"
    exit 1
fi

# 3. 테스트
echo "🧪 3/3 테스트..."
xcodebuild test \
    -project "$PROJECT_PATH" \
    -scheme "$SCHEME" \
    -destination "$DESTINATION" \
    -quiet 2>&1 | tee test.log

TEST_RESULT=$?

if [ $TEST_RESULT -eq 0 ]; then
    echo "   ✅ 테스트 통과"
else
    echo "   ⚠️ 테스트 실패 (선택 사항)"
    echo "   전체 로그: test.log"
fi

# 결과 요약
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $BUILD_RESULT -eq 0 ]; then
    echo "🎉 빌드 검증 완료!"
    echo ""
    echo "실행 방법:"
    echo "  open OracleIOS.xcodeproj"
    echo "  ⌘R 눌러 시뮬레이터 실행"
else
    echo "❌ 빌드 실패 - 에러 수정 필요"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

exit $BUILD_RESULT
