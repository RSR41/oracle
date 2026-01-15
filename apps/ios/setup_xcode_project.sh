#!/bin/bash
# 파일명: setup_xcode_project.sh
# 위치: oracle/apps/ios/
# 실행: cd apps/ios && bash setup_xcode_project.sh

set -e  # 에러 발생 시 중단

echo "🚀 Oracle iOS 프로젝트 설정 시작..."
echo ""

# 현재 위치 확인
if [ ! -d "OracleIOS" ]; then
    echo "❌ OracleIOS 폴더를 찾을 수 없습니다."
    echo "   apps/ios/ 디렉토리에서 실행하세요."
    exit 1
fi

# XcodeGen 확인 및 설치
if ! command -v xcodegen &> /dev/null; then
    echo "📦 XcodeGen 설치 중..."
    if command -v brew &> /dev/null; then
        brew install xcodegen
    else
        echo "❌ Homebrew가 설치되어 있지 않습니다."
        echo "   먼저 Homebrew를 설치하세요: https://brew.sh"
        exit 1
    fi
fi

echo "✅ XcodeGen 확인됨: $(xcodegen --version)"

# 테스트 폴더 생성
if [ ! -d "OracleIOSTests" ]; then
    echo "📁 테스트 폴더 생성..."
    mkdir -p OracleIOSTests
    cat > OracleIOSTests/BasicFortuneEngineTests.swift << 'EOF'
import XCTest
@testable import OracleIOS

final class BasicFortuneEngineTests: XCTestCase {
    
    var engine: BasicFortuneEngine!
    
    override func setUp() {
        super.setUp()
        engine = BasicFortuneEngine()
    }
    
    override func tearDown() {
        engine = nil
        super.tearDown()
    }
    
    func testCalculateReturnsResult() async throws {
        // Given
        let birthInfo = BirthInfo(
            date: "1990-01-15",
            time: "14:30",
            gender: .male,
            calendarType: .solar
        )
        
        // When
        let result = try await engine.calculate(birthInfo: birthInfo)
        
        // Then
        XCTAssertFalse(result.interpretation.isEmpty, "해석이 비어있으면 안됨")
        XCTAssertFalse(result.pillars.fullDisplay.isEmpty, "사주 기둥이 비어있으면 안됨")
        XCTAssertFalse(result.luckyColors.isEmpty, "행운 색상이 비어있으면 안됨")
        XCTAssertFalse(result.luckyNumbers.isEmpty, "행운 숫자가 비어있으면 안됨")
    }
    
    func testCalculateWithoutTime() async throws {
        // Given - 시간 없음
        let birthInfo = BirthInfo(
            date: "1990-01-15",
            time: "",
            gender: .female,
            calendarType: .lunar
        )
        
        // When
        let result = try await engine.calculate(birthInfo: birthInfo)
        
        // Then
        XCTAssertNil(result.pillars.hour, "시간 없으면 시주도 없어야 함")
    }
    
    func testEngineInfo() {
        // When
        let info = engine.getEngineInfo()
        
        // Then
        XCTAssertEqual(info.name, "BasicFortuneEngine")
        XCTAssertEqual(info.version, "1.0.0")
        XCTAssertEqual(info.accuracy, .medium)
    }
    
    func testSameInputSameOutput() async throws {
        // Given
        let birthInfo = BirthInfo(
            date: "1990-01-15",
            time: "14:30",
            gender: .male,
            calendarType: .solar
        )
        
        // When
        let result1 = try await engine.calculate(birthInfo: birthInfo)
        let result2 = try await engine.calculate(birthInfo: birthInfo)
        
        // Then - 동일 입력은 동일 결과 (생성 시간 제외)
        XCTAssertEqual(result1.pillars, result2.pillars)
        XCTAssertEqual(result1.elements, result2.elements)
    }
}
EOF
    echo "   ✅ BasicFortuneEngineTests.swift 생성됨"
fi

# Assets.xcassets 생성
if [ ! -d "OracleIOS/Resources/Assets.xcassets" ]; then
    echo "📁 Assets.xcassets 생성..."
    mkdir -p "OracleIOS/Resources/Assets.xcassets/AppIcon.appiconset"
    mkdir -p "OracleIOS/Resources/Assets.xcassets/AccentColor.colorset"
    
    # Contents.json (루트)
    cat > "OracleIOS/Resources/Assets.xcassets/Contents.json" << 'EOF'
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF
    
    # AppIcon
    cat > "OracleIOS/Resources/Assets.xcassets/AppIcon.appiconset/Contents.json" << 'EOF'
{
  "images" : [
    {
      "idiom" : "universal",
      "platform" : "ios",
      "size" : "1024x1024"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF
    
    # AccentColor (Oracle Gold)
    cat > "OracleIOS/Resources/Assets.xcassets/AccentColor.colorset/Contents.json" << 'EOF'
{
  "colors" : [
    {
      "color" : {
        "color-space" : "srgb",
        "components" : {
          "alpha" : "1.000",
          "blue" : "0.216",
          "green" : "0.686",
          "red" : "0.831"
        }
      },
      "idiom" : "universal"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF
    echo "   ✅ Assets.xcassets 생성됨"
fi

# project.yml 확인
if [ ! -f "project.yml" ]; then
    echo "❌ project.yml 파일이 없습니다."
    echo "   HANDOVER.md를 참고하여 project.yml을 생성하세요."
    exit 1
fi

# 기존 xcodeproj 삭제
if [ -d "OracleIOS.xcodeproj" ]; then
    echo "🗑️  기존 Xcode 프로젝트 삭제..."
    rm -rf "OracleIOS.xcodeproj"
fi

# XcodeGen 실행
echo "🔧 XcodeGen으로 프로젝트 생성 중..."
xcodegen generate

# 결과 확인
if [ -f "OracleIOS.xcodeproj/project.pbxproj" ]; then
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "✅ Xcode 프로젝트 생성 완료!"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo "다음 단계:"
    echo "  1. open OracleIOS.xcodeproj"
    echo "  2. ⌘B 빌드"
    echo "  3. ⌘R 시뮬레이터 실행"
    echo ""
    echo "또는 커맨드라인 빌드:"
    echo "  ./verify_build.sh"
else
    echo "❌ 프로젝트 생성 실패"
    exit 1
fi
