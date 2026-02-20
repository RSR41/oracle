import Foundation

/// 사주 기둥 (천간 + 지지)
/// Android: domain/engine/EngineInterfaces.kt (lines 79-84)
struct Pillar: Equatable, Codable {
    /// 천간 (갑을병정무기경신임계)
    let heavenlyStem: String
    
    /// 지지 (자축인묘진사오미신유술해)
    let earthlyBranch: String
    
    /// 간지 조합 (예: 갑자)
    var ganji: String {
        "\(heavenlyStem)\(earthlyBranch)"
    }
}

/// 사주 사주 (년월일시)
/// Android: domain/engine/EngineInterfaces.kt (lines 72-77)
struct FourPillars: Equatable, Codable {
    let year: Pillar
    let month: Pillar
    let day: Pillar
    let hour: Pillar?
    
    /// 전체 기둥 문자열 (예: 갑자 을축 병인 정묘)
    var fullDisplay: String {
        var pillars = [year.ganji, month.ganji, day.ganji]
        if let hour = hour {
            pillars.append(hour.ganji)
        }
        return pillars.joined(separator: " ")
    }
}

/// 사주 계산 결과
/// Android: domain/engine/EngineInterfaces.kt (lines 57-67)
struct FortuneResult: Equatable, Codable, Identifiable {
    let id: UUID
    
    /// 생년월일 (yyyy-MM-dd)
    let birthDate: String
    
    /// 출생 시간 (HH:mm 또는 "")
    let birthTime: String
    
    /// 사주 사주
    let pillars: FourPillars
    
    /// 오행 분포 (목/화/토/금/수 각각 개수)
    let elements: [String: Int]
    
    /// 십신 분포 (MVP에서는 비어있음)
    let tenGods: [String: Int]
    
    /// 해석 텍스트
    let interpretation: String
    
    /// 행운 색상 (헥스 코드)
    let luckyColors: [String]
    
    /// 행운 숫자
    let luckyNumbers: [Int]
    
    /// 생성 시간
    let generatedAt: Date
    
    init(
        id: UUID = UUID(),
        birthDate: String,
        birthTime: String,
        pillars: FourPillars,
        elements: [String: Int],
        tenGods: [String: Int] = [:],
        interpretation: String,
        luckyColors: [String] = [],
        luckyNumbers: [Int] = [],
        generatedAt: Date = Date()
    ) {
        self.id = id
        self.birthDate = birthDate
        self.birthTime = birthTime
        self.pillars = pillars
        self.elements = elements
        self.tenGods = tenGods
        self.interpretation = interpretation
        self.luckyColors = luckyColors
        self.luckyNumbers = luckyNumbers
        self.generatedAt = generatedAt
    }
}
