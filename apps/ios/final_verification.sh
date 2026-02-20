#!/bin/bash
# 파일명: final_verification.sh
# 위치: oracle/apps/ios/
# 실행: cd apps/ios && bash final_verification.sh

echo "🔍 Oracle iOS 최종 검증 시작..."
echo ""

ERRORS=0
WARNINGS=0

# 1. 프로젝트 파일 존재
echo "1️⃣  프로젝트 파일 확인..."
if [ -f "OracleIOS.xcodeproj/project.pbxproj" ]; then
    echo "   ✅ Xcode 프로젝트 존재"
else
    echo "   ❌ Xcode 프로젝트 없음"
    ((ERRORS++))
fi

# 2. 핵심 Swift 파일 존재
echo "2️⃣  핵심 파일 확인..."
REQUIRED_FILES=(
    "OracleIOS/App/OracleIOSApp.swift"
    "OracleIOS/App/DI/AppContainer.swift"
    "OracleIOS/Domain/Engines/BasicFortuneEngine.swift"
    "OracleIOS/Domain/Engines/FortuneEngine.swift"
    "OracleIOS/Domain/Entities/BirthInfo.swift"
    "OracleIOS/Domain/Entities/FortuneResult.swift"
    "OracleIOS/Domain/Repositories/FortuneRepository.swift"
    "OracleIOS/Domain/UseCases/CalculateFortuneUseCase.swift"
    "OracleIOS/Data/Repositories/FortuneRepositoryImpl.swift"
    "OracleIOS/Data/Persistence/SwiftDataStore.swift"
    "OracleIOS/Data/Persistence/Models/HistoryModel.swift"
    "OracleIOS/Presentation/Navigation/MainTabView.swift"
    "OracleIOS/Presentation/Screens/Fortune/FortuneViewModel.swift"
    "OracleIOS/Presentation/Screens/Fortune/FortuneInputView.swift"
    "OracleIOS/Presentation/Screens/Fortune/FortuneResultView.swift"
    "OracleIOS/Presentation/Theme/Colors.swift"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "   ✅ $(basename $file)"
    else
        echo "   ❌ $file 누락"
        ((ERRORS++))
    fi
done

# 3. Swift 파일 총 수
echo "3️⃣  Swift 파일 수 확인..."
SWIFT_COUNT=$(find OracleIOS -name "*.swift" 2>/dev/null | wc -l | tr -d ' ')
if [ "$SWIFT_COUNT" -ge 30 ]; then
    echo "   ✅ Swift 파일: ${SWIFT_COUNT}개 (예상: 31개)"
else
    echo "   ⚠️ Swift 파일: ${SWIFT_COUNT}개 (예상: 31개)"
    ((WARNINGS++))
fi

# 4. 다국어 파일
echo "4️⃣  다국어 리소스 확인..."
if [ -f "OracleIOS/Resources/ko.lproj/Localizable.strings" ]; then
    KO_LINES=$(wc -l < "OracleIOS/Resources/ko.lproj/Localizable.strings" | tr -d ' ')
    echo "   ✅ 한국어: ${KO_LINES}줄"
else
    echo "   ❌ 한국어 리소스 누락"
    ((ERRORS++))
fi

if [ -f "OracleIOS/Resources/en.lproj/Localizable.strings" ]; then
    EN_LINES=$(wc -l < "OracleIOS/Resources/en.lproj/Localizable.strings" | tr -d ' ')
    echo "   ✅ 영어: ${EN_LINES}줄"
else
    echo "   ❌ 영어 리소스 누락"
    ((ERRORS++))
fi

# 5. Assets 확인
echo "5️⃣  Assets 확인..."
if [ -d "OracleIOS/Resources/Assets.xcassets" ]; then
    echo "   ✅ Assets.xcassets 존재"
else
    echo "   ⚠️ Assets.xcassets 없음 (setup_xcode_project.sh 실행 시 생성됨)"
    ((WARNINGS++))
fi

# 6. 빌드 테스트 (프로젝트 있을 때만)
echo "6️⃣  빌드 테스트..."
if [ -f "OracleIOS.xcodeproj/project.pbxproj" ]; then
    BUILD_OUTPUT=$(xcodebuild build \
        -project OracleIOS.xcodeproj \
        -scheme OracleIOS \
        -destination "platform=iOS Simulator,name=iPhone 15 Pro" \
        -quiet 2>&1)
    
    if [ $? -eq 0 ]; then
        echo "   ✅ 빌드 성공"
    else
        echo "   ❌ 빌드 실패"
        echo ""
        echo "에러 요약:"
        echo "$BUILD_OUTPUT" | grep -E "error:" | head -10
        ((ERRORS++))
    fi
else
    echo "   ⏭️ 프로젝트 없어서 스킵"
fi

# 7. 테스트 파일 확인
echo "7️⃣  테스트 파일 확인..."
if [ -d "OracleIOSTests" ]; then
    TEST_COUNT=$(find OracleIOSTests -name "*Tests.swift" 2>/dev/null | wc -l | tr -d ' ')
    echo "   ✅ 테스트 파일: ${TEST_COUNT}개"
else
    echo "   ⚠️ OracleIOSTests 폴더 없음"
    ((WARNINGS++))
fi

# 결과 출력
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ERRORS -eq 0 ]; then
    if [ $WARNINGS -eq 0 ]; then
        echo "🎉 모든 검증 통과! iOS 앱 준비 완료"
    else
        echo "✅ 검증 통과 (경고 ${WARNINGS}개)"
    fi
    echo ""
    echo "다음 단계:"
    echo "  1. open OracleIOS.xcodeproj"
    echo "  2. ⌘R로 시뮬레이터 실행"
    echo "  3. Fortune 기능 테스트:"
    echo "     - 생년월일 입력"
    echo "     - 결과 보기 버튼 탭"
    echo "     - 사주 결과 확인"
else
    echo "⚠️ ${ERRORS}개 에러, ${WARNINGS}개 경고"
    echo ""
    echo "에러 수정 후 다시 실행:"
    echo "  ./final_verification.sh"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

exit $ERRORS
