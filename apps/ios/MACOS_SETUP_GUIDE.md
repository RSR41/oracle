# macOS 설정 및 빌드 가이드

> **대상**: macOS + Xcode 15.0+  
> **목표**: Oracle iOS 앱 빌드 및 실행

---

## 목차

1. [사전 준비](#1-사전-준비)
2. [Git Clone 및 최신 코드 받기](#2-git-clone-및-최신-코드-받기)
3. [방법 A: XcodeGen 자동 생성 (권장)](#3-방법-a-xcodegen-자동-생성-권장)
4. [방법 B: Xcode 수동 프로젝트 생성](#4-방법-b-xcode-수동-프로젝트-생성)
5. [빌드 및 테스트](#5-빌드-및-테스트)
6. [흔한 빌드 에러 및 해결법](#6-흔한-빌드-에러-및-해결법)
7. [최종 검증 체크리스트](#7-최종-검증-체크리스트)

---

## 1. 사전 준비

### 필수 도구 확인
```bash
# Xcode 버전 확인 (15.0+ 필요)
xcodebuild -version

# 시뮬레이터 목록 확인
xcrun simctl list devices available | grep "iPhone 15"

# XcodeGen 설치 (방법 A 사용 시)
brew install xcodegen
```

### 예상 출력
```
Xcode 15.x
Build version xxxxx

iPhone 15 Pro (xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx) (Shutdown)
```

---

## 2. Git Clone 및 최신 코드 받기

```bash
# 1. 저장소 클론 (처음인 경우)
cd ~/Developer  # 또는 원하는 위치
git clone https://github.com/RSR41/oracle.git
cd oracle

# 2. 이미 클론되어 있다면 최신 코드 pull
cd ~/Developer/oracle  # 실제 경로로 변경
git pull origin main

# 3. iOS 코드 확인
ls -la apps/ios/OracleIOS/
```

### 예상 결과
```
App/
Data/
Domain/
Presentation/
Resources/
```

---

## 3. 방법 A: XcodeGen 자동 생성 (권장)

### 3-1. project.yml 생성

`apps/ios/project.yml` 파일을 생성합니다:

```yaml
name: OracleIOS
options:
  bundleIdPrefix: com.rsr41.oracle
  deploymentTarget:
    iOS: "17.0"
  xcodeVersion: "15.0"
  createIntermediateGroups: true

settings:
  base:
    SWIFT_VERSION: "5.9"
    GENERATE_INFOPLIST_FILE: YES
    CURRENT_PROJECT_VERSION: 1
    MARKETING_VERSION: 1.0.0
    SWIFT_EMIT_LOC_STRINGS: YES

targets:
  OracleIOS:
    type: application
    platform: iOS
    sources:
      - path: OracleIOS
        excludes:
          - "**/.DS_Store"
    resources:
      - path: OracleIOS/Resources
        buildPhase: resources
    settings:
      PRODUCT_BUNDLE_IDENTIFIER: com.rsr41.oracle.ios
      INFOPLIST_KEY_UIApplicationSceneManifest_Generation: YES
      INFOPLIST_KEY_UIApplicationSupportsIndirectInputEvents: YES
      INFOPLIST_KEY_UILaunchScreen_Generation: YES
      INFOPLIST_KEY_UISupportedInterfaceOrientations_iPhone: "UIInterfaceOrientationPortrait"
    info:
      path: OracleIOS/Info.plist
      properties:
        CFBundleDisplayName: Oracle
        CFBundleShortVersionString: "1.0.0"
        UILaunchStoryboardName: ""

  OracleIOSTests:
    type: bundle.unit-test
    platform: iOS
    sources:
      - path: OracleIOSTests
    dependencies:
      - target: OracleIOS
    settings:
      PRODUCT_BUNDLE_IDENTIFIER: com.rsr41.oracle.ios.tests
```

### 3-2. 자동화 스크립트 실행

`apps/ios/setup_xcode_project.sh` 파일을 생성하고 실행:

```bash
#!/bin/bash
# 파일명: setup_xcode_project.sh
# 위치: oracle/apps/ios/
# 실행: cd apps/ios && bash setup_xcode_project.sh

set -e  # 에러 발생 시 중단

echo "🚀 Oracle iOS 프로젝트 설정 시작..."

# 1. 현재 위치 확인
if [ ! -d "OracleIOS" ]; then
    echo "❌ OracleIOS 폴더를 찾을 수 없습니다. apps/ios/ 디렉토리에서 실행하세요."
    exit 1
fi

# 2. XcodeGen 확인
if ! command -v xcodegen &> /dev/null; then
    echo "📦 XcodeGen 설치 중..."
    brew install xcodegen
fi

# 3. 테스트 폴더 생성 (없는 경우)
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
    
    func testCalculateReturnsResult() async throws {
        let birthInfo = BirthInfo(
            date: "1990-01-15",
            time: "14:30",
            gender: .male,
            calendarType: .solar
        )
        
        let result = try await engine.calculate(birthInfo: birthInfo)
        
        XCTAssertFalse(result.interpretation.isEmpty)
        XCTAssertFalse(result.pillars.fullDisplay.isEmpty)
    }
    
    func testEngineInfo() {
        let info = engine.getEngineInfo()
        
        XCTAssertEqual(info.name, "BasicFortuneEngine")
        XCTAssertEqual(info.version, "1.0.0")
    }
}
EOF
fi

# 4. Resources 폴더 정리
if [ ! -d "OracleIOS/Resources/Assets.xcassets" ]; then
    echo "📁 Assets.xcassets 생성..."
    mkdir -p "OracleIOS/Resources/Assets.xcassets/AppIcon.appiconset"
    cat > "OracleIOS/Resources/Assets.xcassets/Contents.json" << 'EOF'
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
EOF
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
fi

# 5. project.yml 존재 확인
if [ ! -f "project.yml" ]; then
    echo "❌ project.yml 파일이 없습니다. 먼저 생성하세요."
    exit 1
fi

# 6. XcodeGen 실행
echo "🔧 XcodeGen으로 프로젝트 생성 중..."
xcodegen generate

# 7. 결과 확인
if [ -f "OracleIOS.xcodeproj/project.pbxproj" ]; then
    echo "✅ Xcode 프로젝트 생성 완료!"
    echo ""
    echo "다음 단계:"
    echo "  1. open OracleIOS.xcodeproj"
    echo "  2. ⌘B 빌드"
    echo "  3. ⌘R 실행"
else
    echo "❌ 프로젝트 생성 실패"
    exit 1
fi
```

### 3-3. 실행 방법

```bash
cd ~/Developer/oracle/apps/ios
chmod +x setup_xcode_project.sh
./setup_xcode_project.sh
```

---

## 4. 방법 B: Xcode 수동 프로젝트 생성

### 4-1. 새 프로젝트 생성

1. **Xcode 실행**
2. **File → New → Project** (⇧⌘N)
3. **iOS → App** 선택 → Next
4. **설정 입력**:
   | 항목 | 값 |
   |------|-----|
   | Product Name | `OracleIOS` |
   | Team | (선택 안 함 또는 개인 계정) |
   | Organization Identifier | `com.rsr41.oracle` |
   | Interface | SwiftUI |
   | Language | Swift |
   | Storage | ✅ SwiftData 체크 |
   | Include Tests | ✅ 체크 |
5. **저장 위치**: `~/Developer/oracle/apps/ios/` 선택
6. **Create** 클릭

### 4-2. 기본 파일 삭제

Xcode에서 다음 파일들을 **삭제** (Move to Trash):
- `ContentView.swift`
- `Item.swift`

### 4-3. 생성된 Swift 파일 추가

1. **프로젝트 네비게이터**에서 `OracleIOS` 폴더 우클릭
2. **Add Files to "OracleIOS"...** 선택
3. **경로 이동**: `~/Developer/oracle/apps/ios/OracleIOS/`
4. **폴더 선택**: `App`, `Domain`, `Data`, `Presentation`, `Resources` 전체 선택
5. **옵션 설정**:
   | 옵션 | 설정 |
   |------|------|
   | Copy items if needed | ❌ 해제 |
   | Create groups | ✅ 선택 |
   | Add to targets: OracleIOS | ✅ 체크 |
6. **Add** 클릭

### 4-4. Localizable.strings 추가

1. **Resources** 그룹 우클릭 → Add Files
2. `ko.lproj`, `en.lproj` 폴더 추가
3. 각 `Localizable.strings` 파일 선택
4. **File Inspector** (오른쪽 패널) → **Localization** 섹션
5. **Localize...** 클릭 → Korean/English 선택

### 4-5. Build Settings 확인

1. **OracleIOS 타겟** 선택
2. **Build Settings** 탭
3. 확인할 항목:
   | 항목 | 값 |
   |------|-----|
   | iOS Deployment Target | 17.0 |
   | Swift Language Version | 5.9 |

---

## 5. 빌드 및 테스트

### 빌드 검증 스크립트

`apps/ios/verify_build.sh` 파일 생성:

```bash
#!/bin/bash
# 파일명: verify_build.sh
# 실행: cd apps/ios && bash verify_build.sh

set -e

PROJECT_PATH="OracleIOS.xcodeproj"
SCHEME="OracleIOS"
DESTINATION="platform=iOS Simulator,name=iPhone 15 Pro"

echo "🧹 클린 빌드 시작..."
xcodebuild clean \
  -project "$PROJECT_PATH" \
  -scheme "$SCHEME" \
  -quiet

echo "🔨 빌드 시작..."
xcodebuild build \
  -project "$PROJECT_PATH" \
  -scheme "$SCHEME" \
  -destination "$DESTINATION" \
  -quiet

if [ $? -eq 0 ]; then
    echo "✅ 빌드 성공!"
else
    echo "❌ 빌드 실패"
    exit 1
fi

echo "🧪 테스트 시작..."
xcodebuild test \
  -project "$PROJECT_PATH" \
  -scheme "$SCHEME" \
  -destination "$DESTINATION" \
  -quiet

if [ $? -eq 0 ]; then
    echo "✅ 테스트 통과!"
else
    echo "⚠️ 테스트 실패 - 로그 확인 필요"
fi

echo ""
echo "🎉 검증 완료!"
echo "실행 방법: open OracleIOS.xcodeproj 후 ⌘R"
```

### 실행 방법

```bash
cd ~/Developer/oracle/apps/ios
chmod +x verify_build.sh
./verify_build.sh
```

---

## 6. 흔한 빌드 에러 및 해결법

### 에러 1: Cannot find type 'X' in scope

**원인**: 파일이 타겟에 추가되지 않음

**해결**:
```bash
# Xcode에서:
# 1. 해당 파일 선택
# 2. File Inspector → Target Membership
# 3. OracleIOS 체크박스 활성화
```

**자동 수정 시도**:
```swift
// 파일 상단에 import 추가
import Foundation
import SwiftUI
import SwiftData
```

---

### 에러 2: Missing argument label 'Y:' in call

**원인**: 함수 호출 시 레이블 누락

**해결**: 에러 메시지에 나온 레이블 추가
```swift
// Before
FortuneResult(birthDate, birthTime, ...)

// After  
FortuneResult(birthDate: birthDate, birthTime: birthTime, ...)
```

---

### 에러 3: Value of type 'Z' has no member 'method'

**원인**: 프로토콜 구현 누락 또는 타입 불일치

**해결**: 프로토콜에 정의된 메서드 구현
```swift
// FortuneEngine 프로토콜 확인
protocol FortuneEngine {
    func calculate(birthInfo: BirthInfo) async throws -> FortuneResult
    func getEngineInfo() -> EngineInfo
}

// 구현체에서 모두 구현
```

---

### 에러 4: Cannot convert value of type 'A' to expected argument type 'B'

**원인**: 타입 미스매치

**예시**: `String` vs `String?`

**해결**:
```swift
// Before
let time: String = birthTime  // birthTime이 String?인 경우

// After
let time: String = birthTime ?? ""
```

---

### 에러 5: A ModelContainer failed to be created

**원인**: SwiftData 스키마 문제

**해결**:
```swift
// OracleIOSApp.swift에서 스키마 확인
let schema = Schema([
    HistoryModel.self,
    ProfileModel.self
])

// @Model 클래스에 @Attribute(.unique) 확인
@Model
final class HistoryModel {
    @Attribute(.unique) var id: String  // ✅ 필수
    // ...
}
```

---

### 에러 6: No such module 'OracleIOS'

**원인**: 테스트 타겟에서 앱 모듈 참조 실패

**해결**:
```swift
// 테스트 파일 상단
@testable import OracleIOS  // ✅ @testable 필수
```

**Build Settings 확인**:
- OracleIOSTests 타겟 → Build Settings
- `ENABLE_TESTABILITY` = `YES`

---

### 에러 7: Failed to find a matching configuration

**원인**: Localizable.strings 언어 설정 문제

**해결**:
1. Xcode에서 프로젝트 파일 선택 (최상단)
2. **Info** 탭 → **Localizations**
3. Korean, English 추가
4. `Localizable.strings` 파일 선택 → Localize

---

### 자동 에러 수정 스크립트

`apps/ios/auto_fix_common_errors.sh`:

```bash
#!/bin/bash
# 파일명: auto_fix_common_errors.sh
# 흔한 에러 자동 수정 시도

echo "🔧 자동 에러 수정 시도..."

# 1. Foundation import 추가 (없는 파일에)
find OracleIOS -name "*.swift" | while read file; do
    if ! grep -q "import Foundation" "$file"; then
        if grep -q "import SwiftUI" "$file" || grep -q "import SwiftData" "$file"; then
            # SwiftUI/SwiftData는 Foundation 포함
            continue
        fi
        echo "📝 Foundation import 추가: $file"
        sed -i '' '1i\
import Foundation
' "$file"
    fi
done

# 2. @MainActor 누락 체크
grep -l "class.*ObservableObject" OracleIOS/**/*.swift 2>/dev/null | while read file; do
    if ! grep -q "@MainActor" "$file"; then
        echo "⚠️ @MainActor 누락 가능성: $file"
    fi
done

# 3. Assets.xcassets 존재 확인
if [ ! -d "OracleIOS/Resources/Assets.xcassets" ]; then
    echo "📁 Assets.xcassets 생성..."
    mkdir -p "OracleIOS/Resources/Assets.xcassets"
    echo '{"info":{"version":1,"author":"xcode"}}' > "OracleIOS/Resources/Assets.xcassets/Contents.json"
fi

echo "✅ 자동 수정 완료!"
echo "다시 빌드해보세요: xcodebuild build ..."
```

---

## 7. 최종 검증 체크리스트

`apps/ios/final_verification.sh`:

```bash
#!/bin/bash
# 파일명: final_verification.sh
# 최종 검증 스크립트

echo "🔍 Oracle iOS 최종 검증 시작..."
echo ""

ERRORS=0

# 1. 프로젝트 파일 존재
echo "1️⃣ 프로젝트 파일 확인..."
if [ -f "OracleIOS.xcodeproj/project.pbxproj" ]; then
    echo "   ✅ Xcode 프로젝트 존재"
else
    echo "   ❌ Xcode 프로젝트 없음"
    ((ERRORS++))
fi

# 2. 핵심 Swift 파일 존재
echo "2️⃣ 핵심 파일 확인..."
REQUIRED_FILES=(
    "OracleIOS/App/OracleIOSApp.swift"
    "OracleIOS/App/DI/AppContainer.swift"
    "OracleIOS/Domain/Engines/BasicFortuneEngine.swift"
    "OracleIOS/Presentation/Navigation/MainTabView.swift"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "   ✅ $file"
    else
        echo "   ❌ $file 누락"
        ((ERRORS++))
    fi
done

# 3. 빌드 성공 여부
echo "3️⃣ 빌드 테스트..."
BUILD_OUTPUT=$(xcodebuild build \
    -project OracleIOS.xcodeproj \
    -scheme OracleIOS \
    -destination "platform=iOS Simulator,name=iPhone 15 Pro" \
    -quiet 2>&1)

if [ $? -eq 0 ]; then
    echo "   ✅ 빌드 성공"
else
    echo "   ❌ 빌드 실패"
    echo "$BUILD_OUTPUT" | tail -20
    ((ERRORS++))
fi

# 4. Swift 파일 수
echo "4️⃣ Swift 파일 수 확인..."
SWIFT_COUNT=$(find OracleIOS -name "*.swift" | wc -l | tr -d ' ')
if [ "$SWIFT_COUNT" -ge 30 ]; then
    echo "   ✅ Swift 파일: ${SWIFT_COUNT}개"
else
    echo "   ⚠️ Swift 파일: ${SWIFT_COUNT}개 (예상: 31개)"
fi

# 5. 다국어 파일
echo "5️⃣ 다국어 파일 확인..."
if [ -f "OracleIOS/Resources/ko.lproj/Localizable.strings" ]; then
    echo "   ✅ 한국어 리소스"
else
    echo "   ❌ 한국어 리소스 누락"
    ((ERRORS++))
fi

if [ -f "OracleIOS/Resources/en.lproj/Localizable.strings" ]; then
    echo "   ✅ 영어 리소스"
else
    echo "   ❌ 영어 리소스 누락"
    ((ERRORS++))
fi

# 결과 출력
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
if [ $ERRORS -eq 0 ]; then
    echo "🎉 모든 검증 통과! iOS 앱 준비 완료"
    echo ""
    echo "다음 단계:"
    echo "  1. open OracleIOS.xcodeproj"
    echo "  2. ⌘R로 시뮬레이터 실행"
    echo "  3. Fortune 기능 테스트"
else
    echo "⚠️ $ERRORS개 항목 실패"
    echo "위 에러를 수정한 후 다시 실행하세요."
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
```

---

## 부록: 스크립트 실행 순서 요약

```bash
# 1. 저장소 클론 또는 pull
cd ~/Developer
git clone https://github.com/RSR41/oracle.git
cd oracle/apps/ios

# 2. XcodeGen으로 프로젝트 생성 (권장)
./setup_xcode_project.sh

# 3. 빌드 검증
./verify_build.sh

# 4. 에러 발생 시 자동 수정 시도
./auto_fix_common_errors.sh

# 5. 최종 검증
./final_verification.sh

# 6. Xcode에서 실행
open OracleIOS.xcodeproj
# ⌘R 눌러 시뮬레이터 실행
```
