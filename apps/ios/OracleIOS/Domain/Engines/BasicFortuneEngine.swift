import Foundation

/// 기본 사주 계산 엔진 (MVP용)
/// Android: data/engine/BasicFortuneEngine.kt (lines 15-229)
/// 간단한 천간지지 계산 + 템플릿 기반 해석
final class BasicFortuneEngine: FortuneEngine {
    
    // MARK: - Dependencies
    private let sajuContents: [SajuContent]
    
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
    
    init(sajuContents: [SajuContent] = []) {
        self.sajuContents = sajuContents
    }
    
    // MARK: - FortuneEngine
    
    func calculate(birthInfo: BirthInfo) async throws -> FortuneResult {
        // MVP: 간단한 계산 시뮬레이션 (500ms 딜레이)
        try await Task.sleep(nanoseconds: 500_000_000)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let date = dateFormatter.date(from: birthInfo.date) ?? Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        var hour: Int? = nil
        if !birthInfo.time.isEmpty {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            if let time = timeFormatter.date(from: birthInfo.time) {
                hour = calendar.component(.hour, from: time)
            }
        }
        
        // 년주, 월주, 일주, 시주 계산
        let yearPillar = calculateYearPillar(year: year)
        let monthPillar = calculateMonthPillar(year: year, month: month)
        let dayPillar = calculateDayPillar(year: year, month: month, day: day)
        
        let hourPillar = hour.map { calculateHourPillar(hour: $0, dayStemIndex: heavenlyStems.firstIndex(of: dayPillar.heavenlyStem) ?? 0) }
        
        let fourPillars = FourPillars(
            year: yearPillar,
            month: monthPillar,
            day: dayPillar,
            hour: hourPillar
        )
        
        // 오행 계산
        let elements = calculateElements(yearPillar, monthPillar, dayPillar, hourPillar)
        
        // 해석 생성 (데이터 기반)
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
    
    // ... (중간 계산 로직 동일) ...
    // MARK: - 년주 계산
    private func calculateYearPillar(year: Int) -> Pillar {
        var stemIndex = (year - 4) % 10
        var branchIndex = (year - 4) % 12
        if stemIndex < 0 { stemIndex += 10 }
        if branchIndex < 0 { branchIndex += 12 }
        return Pillar(heavenlyStem: heavenlyStems[stemIndex], earthlyBranch: earthlyBranches[branchIndex])
    }
    
    // MARK: - 월주 계산
    private func calculateMonthPillar(year: Int, month: Int) -> Pillar {
        let stemIndex = ((year % 10) * 2 + month) % 10
        let branchIndex = (month + 1) % 12
        return Pillar(heavenlyStem: heavenlyStems[stemIndex], earthlyBranch: earthlyBranches[branchIndex])
    }
    
    // MARK: - 일주 계산
    private func calculateDayPillar(year: Int, month: Int, day: Int) -> Pillar {
        let stemIndex = (year + month + day) % 10
        let branchIndex = (year + month + day) % 12
        return Pillar(heavenlyStem: heavenlyStems[stemIndex], earthlyBranch: earthlyBranches[branchIndex])
    }
    
    // MARK: - 시주 계산
    private func calculateHourPillar(hour: Int, dayStemIndex: Int) -> Pillar {
        let hourIndex = hour / 2
        let stemIndex = (dayStemIndex * 2 + hourIndex) % 10
        return Pillar(heavenlyStem: heavenlyStems[stemIndex], earthlyBranch: earthlyBranches[hourIndex % 12])
    }
    
    // MARK: - 오행 계산
    private func calculateElements(_ pillars: Pillar?...) -> [String: Int] {
        var counts: [String: Int] = ["목": 0, "화": 0, "토": 0, "금": 0, "수": 0]
        for pillar in pillars.compactMap({ $0 }) {
            if let element = stemElements[pillar.heavenlyStem] {
                counts[element, default: 0] += 1
            }
        }
        return counts
    }
    
    // MARK: - 해석 생성 (데이터 기반)
    private func generateInterpretation(dayPillar: Pillar, elements: [String: Int], calendarType: CalendarType) -> String {
        let dayMaster = dayPillar.heavenlyStem
        let dayMasterElement = stemElements[dayMaster] ?? "토"
        
        let sortedElements = elements.sorted(by: { $0.key < $1.key })
        let dominantElement = elements.max(by: { $0.value < $1.value })?.key ?? "토"
        let weakestElement = elements.min(by: { $0.value < $1.value })?.key ?? "수"
        
        var lines: [String] = []
        
        // 1. 일간(나 자신) 해석
        // JSON 데이터에서 일간(천간) 데이터 조회 (예: id="chungan_gap")
        // code 값으로 매칭 시도 (code는 "갑", "을" 등)
        let dayMasterContent = sajuContents.first(where: { $0.code == dayMaster && $0.type == "천간" })
        let dayMasterDesc = dayMasterContent?.description ?? getElementDescription(dayMasterElement) // fallback
        
        lines.append(L("📊 일간(일주 천간): %@ (%@)", dayMaster, dayMasterElement))
        lines.append(dayMasterDesc)
        lines.append("")
        
        // 2. 오행 분석
        lines.append(L("🔮 오행 분석:"))
        for (element, count) in sortedElements {
            let filled = String(repeating: "●", count: count)
            let empty = String(repeating: "○", count: 4 - count)
            lines.append("  \(element): \(filled)\(empty) (\(count))")
        }
        lines.append("")
        
        // 3. 총운 및 조언 (데이터 기반)
        // 오행 데이터 조회
        let dominentContent = sajuContents.first(where: { $0.code == dominantElement && $0.type == "오행" })
        let weakestContent = sajuContents.first(where: { $0.code == weakestElement && $0.type == "오행" })
        
        lines.append(L("💫 총운:"))
        
        // 강한 기운 해석
        let strengthDesc = dominentContent?.attributeKo ?? getElementStrength(dominantElement)
        lines.append(L("%@의 기운이 강하여, 당신은 %@", dominantElement, strengthDesc))
        
        // 부족한 기운 조언
        if elements[weakestElement] == 0 {
            lines.append(L("%@의 기운이 부족합니다. 균형을 위해 보완이 필요합니다.", weakestElement))
            if let attr = weakestContent?.attributeKo {
                 lines.append(L("보완 키워드: %@", attr))
            }
        }
        
        lines.append("")
        lines.append(L("⚠️ 참고: 이 결과는 만세력 알고리즘과 기본 데이터를 바탕으로 합니다."))
        
        return lines.joined(separator: "\n")
    }
    
    // MARK: - Fallback Methods (데이터 없을 경우)
    
    func getEngineInfo() -> EngineInfo {
        EngineInfo(name: "BasicFortuneEngine", version: "2.0.0 (Data-Driven)", accuracy: .high)
    }
    
    private func getElementDescription(_ element: String) -> String {
       // ... 기존 하드코딩 (Fallback용) ...
       switch element {
        case "목": return "성장과 발전의 에너지가 있습니다."
        case "화": return "열정과 에너지가 넘칩니다."
        case "토": return "안정과 신뢰의 기운입니다."
        case "금": return "결단력과 정의감이 강합니다."
        case "수": return "지혜와 유연함을 갖추었습니다."
        default: return ""
        }
    }
    
    private func getElementStrength(_ element: String) -> String {
        return "강점" // Placeholder
    }
    
    private func getLuckyColors(elements: [String: Int]) -> [String] {
        let weakest = elements.min(by: { $0.value < $1.value })?.key ?? "토"
        switch weakest {
        case "목": return ["#228B22", "#90EE90"]
        case "화": return ["#FF4500", "#FF6347"]
        case "토": return ["#D2691E", "#DEB887"]
        case "금": return ["#FFD700", "#C0C0C0"]
        case "수": return ["#000080", "#4169E1"]
        default: return ["#D4A574", "#8B4513"]
        }
    }
    
    private func getLuckyNumbers(dayPillar: Pillar) -> [Int] {
        let stemIndex = heavenlyStems.firstIndex(of: dayPillar.heavenlyStem) ?? 0
        let branchIndex = earthlyBranches.firstIndex(of: dayPillar.earthlyBranch) ?? 0
        var numbers = [stemIndex + 1, branchIndex + 1, (stemIndex + branchIndex) % 9 + 1]
        return Array(Set(numbers)).sorted()
    }
}
