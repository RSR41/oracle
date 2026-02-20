import Foundation

/// 기본 사주 계산 엔진 (MVP용)
/// Android: data/engine/BasicFortuneEngine.kt (lines 15-229)
/// 간단한 천간지지 계산 + 템플릿 기반 해석
final class BasicFortuneEngine: FortuneEngine {
    
    // MARK: - 천간 (10개)
    private let heavenlyStems = ["갑", "을", "병", "정", "무", "기", "경", "신", "임", "계"]
    
    // MARK: - 지지 (12개)
    private let earthlyBranches = ["자", "축", "인", "묘", "진", "사", "오", "미", "신", "유", "술", "해"]
    
    // MARK: - 오행 매핑
    private let stemElements: [String: String] = [
        "갑": "목", "을": "목",
        "병": "화", "정": "화",
        "무": "토", "기": "토",
        "경": "금", "신": "금",
        "임": "수", "계": "수"
    ]
    
    // MARK: - FortuneEngine
    
    func calculate(birthInfo: BirthInfo) async throws -> FortuneResult {
        // MVP: 간단한 계산 시뮬레이션 (500ms 딜레이)
        try await Task.sleep(nanoseconds: 500_000_000)
        
        // 날짜 파싱 (yyyy-MM-dd)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter.date(from: birthInfo.date) ?? Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        // 시간 파싱 (HH:mm) - 선택적
        var hour: Int? = nil
        if !birthInfo.time.isEmpty {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            if let time = timeFormatter.date(from: birthInfo.time) {
                hour = calendar.component(.hour, from: time)
            }
        }
        
        // 년주 계산
        let yearPillar = calculateYearPillar(year: year)
        
        // 월주 계산
        let monthPillar = calculateMonthPillar(year: year, month: month)
        
        // 일주 계산
        let dayPillar = calculateDayPillar(year: year, month: month, day: day)
        
        // 시주 계산 (선택적)
        let hourPillar = hour.map { calculateHourPillar(hour: $0, dayStemIndex: heavenlyStems.firstIndex(of: dayPillar.heavenlyStem) ?? 0) }
        
        let fourPillars = FourPillars(
            year: yearPillar,
            month: monthPillar,
            day: dayPillar,
            hour: hourPillar
        )
        
        // 오행 계산
        let elements = calculateElements(yearPillar, monthPillar, dayPillar, hourPillar)
        
        // 해석 생성
        let interpretation = generateInterpretation(
            dayPillar: dayPillar,
            elements: elements,
            calendarType: birthInfo.calendarType
        )
        
        return FortuneResult(
            birthDate: birthInfo.date,
            birthTime: birthInfo.time,
            pillars: fourPillars,
            elements: elements,
            interpretation: interpretation,
            luckyColors: getLuckyColors(elements: elements),
            luckyNumbers: getLuckyNumbers(dayPillar: dayPillar)
        )
    }
    
    func getEngineInfo() -> EngineInfo {
        EngineInfo(
            name: "BasicFortuneEngine",
            version: "1.0.0",
            accuracy: .medium
        )
    }
    
    // MARK: - 년주 계산
    /// Android: BasicFortuneEngine.kt (lines 57-63)
    private func calculateYearPillar(year: Int) -> Pillar {
        var stemIndex = (year - 4) % 10
        var branchIndex = (year - 4) % 12
        
        if stemIndex < 0 { stemIndex += 10 }
        if branchIndex < 0 { branchIndex += 12 }
        
        return Pillar(
            heavenlyStem: heavenlyStems[stemIndex],
            earthlyBranch: earthlyBranches[branchIndex]
        )
    }
    
    // MARK: - 월주 계산
    /// Android: BasicFortuneEngine.kt (lines 65-71)
    private func calculateMonthPillar(year: Int, month: Int) -> Pillar {
        let stemIndex = ((year % 10) * 2 + month) % 10
        let branchIndex = (month + 1) % 12
        
        return Pillar(
            heavenlyStem: heavenlyStems[stemIndex],
            earthlyBranch: earthlyBranches[branchIndex]
        )
    }
    
    // MARK: - 일주 계산
    /// Android: BasicFortuneEngine.kt (lines 73-79)
    private func calculateDayPillar(year: Int, month: Int, day: Int) -> Pillar {
        let stemIndex = (year + month + day) % 10
        let branchIndex = (year + month + day) % 12
        
        return Pillar(
            heavenlyStem: heavenlyStems[stemIndex],
            earthlyBranch: earthlyBranches[branchIndex]
        )
    }
    
    // MARK: - 시주 계산
    /// Android: BasicFortuneEngine.kt (lines 81-89)
    private func calculateHourPillar(hour: Int, dayStemIndex: Int) -> Pillar {
        let hourIndex = hour / 2
        let stemIndex = (dayStemIndex * 2 + hourIndex) % 10
        
        return Pillar(
            heavenlyStem: heavenlyStems[stemIndex],
            earthlyBranch: earthlyBranches[hourIndex % 12]
        )
    }
    
    // MARK: - 오행 계산
    /// Android: BasicFortuneEngine.kt (lines 124-141)
    private func calculateElements(_ pillars: Pillar?...) -> [String: Int] {
        var counts: [String: Int] = [
            "목": 0, "화": 0, "토": 0, "금": 0, "수": 0
        ]
        
        for pillar in pillars.compactMap({ $0 }) {
            if let element = stemElements[pillar.heavenlyStem] {
                counts[element, default: 0] += 1
            }
        }
        
        return counts
    }
    
    // MARK: - 해석 생성
    /// Android: BasicFortuneEngine.kt (lines 143-173)
    private func generateInterpretation(dayPillar: Pillar, elements: [String: Int], calendarType: CalendarType) -> String {
        let dayMaster = dayPillar.heavenlyStem
        let dayMasterElement = stemElements[dayMaster] ?? "토"
        
        let dominantElement = elements.max(by: { $0.value < $1.value })?.key ?? "토"
        let weakestElement = elements.min(by: { $0.value < $1.value })?.key ?? "수"
        
        var lines: [String] = []
        
        lines.append("📊 일간(일주 천간): \(dayMaster) (\(dayMasterElement))")
        lines.append("")
        lines.append("🔮 오행 분석:")
        
        for (element, count) in elements.sorted(by: { $0.key < $1.key }) {
            let filled = String(repeating: "●", count: count)
            let empty = String(repeating: "○", count: 4 - count)
            lines.append("  \(element): \(filled)\(empty) (\(count))")
        }
        
        lines.append("")
        lines.append("💫 총운:")
        lines.append("\(dayMasterElement)의 기운을 타고난 당신은 \(getElementDescription(dayMasterElement))")
        lines.append("")
        lines.append("\(dominantElement)의 기운이 강하여 \(getElementStrength(dominantElement))")
        
        if elements[weakestElement] == 0 {
            lines.append("\(weakestElement)의 기운이 부족하니 \(getElementWeakness(weakestElement))")
        }
        
        lines.append("")
        lines.append("⚠️ 참고: 이 결과는 기본 계산 기반입니다. 정확한 분석은 전문가 상담을 권장합니다.")
        
        return lines.joined(separator: "\n")
    }
    
    // MARK: - 오행 설명
    /// Android: BasicFortuneEngine.kt (lines 175-182)
    private func getElementDescription(_ element: String) -> String {
        switch element {
        case "목": return "성장과 발전의 에너지가 있습니다. 새로운 시작에 유리하고 창의적인 면이 있습니다."
        case "화": return "열정과 에너지가 넘칩니다. 표현력이 풍부하고 리더십이 있습니다."
        case "토": return "안정과 신뢰의 기운입니다. 중심을 잘 잡고 균형감이 뛰어납니다."
        case "금": return "결단력과 정의감이 강합니다. 원칙을 중시하고 책임감이 있습니다."
        case "수": return "지혜와 유연함을 갖추었습니다. 적응력이 뛰어나고 통찰력이 있습니다."
        default: return "다양한 가능성을 가지고 있습니다."
        }
    }
    
    /// Android: BasicFortuneEngine.kt (lines 184-191)
    private func getElementStrength(_ element: String) -> String {
        switch element {
        case "목": return "창의적이고 성장 지향적인 성향이 두드러집니다."
        case "화": return "열정적이고 표현력이 뛰어난 면이 강조됩니다."
        case "토": return "안정적이고 신뢰할 수 있는 모습이 부각됩니다."
        case "금": return "원칙적이고 정의로운 면이 강하게 나타납니다."
        case "수": return "지적이고 유연한 사고가 돋보입니다."
        default: return "균형 잡힌 모습을 보입니다."
        }
    }
    
    /// Android: BasicFortuneEngine.kt (lines 193-200)
    private func getElementWeakness(_ element: String) -> String {
        switch element {
        case "목": return "창의성과 새로운 시작의 에너지를 보충하면 좋겠습니다."
        case "화": return "열정과 표현력을 더 발휘해보세요."
        case "토": return "안정감과 중심을 잡는 노력이 필요합니다."
        case "금": return "결단력과 원칙을 더 세워보세요."
        case "수": return "유연함과 지혜를 기르면 도움이 됩니다."
        default: return "균형을 맞추는 노력이 필요합니다."
        }
    }
    
    // MARK: - 행운 색상
    /// Android: BasicFortuneEngine.kt (lines 202-212)
    private func getLuckyColors(elements: [String: Int]) -> [String] {
        let weakest = elements.min(by: { $0.value < $1.value })?.key ?? "토"
        
        switch weakest {
        case "목": return ["#228B22", "#90EE90"] // 녹색 계열
        case "화": return ["#FF4500", "#FF6347"] // 빨강 계열
        case "토": return ["#D2691E", "#DEB887"] // 황토 계열
        case "금": return ["#FFD700", "#C0C0C0"] // 금/은색 계열
        case "수": return ["#000080", "#4169E1"] // 파랑 계열
        default: return ["#D4A574", "#8B4513"] // 기본 베이지
        }
    }
    
    // MARK: - 행운 숫자
    /// Android: BasicFortuneEngine.kt (lines 214-222)
    private func getLuckyNumbers(dayPillar: Pillar) -> [Int] {
        let stemIndex = heavenlyStems.firstIndex(of: dayPillar.heavenlyStem) ?? 0
        let branchIndex = earthlyBranches.firstIndex(of: dayPillar.earthlyBranch) ?? 0
        
        var numbers = [
            stemIndex + 1,
            branchIndex + 1,
            (stemIndex + branchIndex) % 9 + 1
        ]
        
        // 중복 제거
        return Array(Set(numbers)).sorted()
    }
}
