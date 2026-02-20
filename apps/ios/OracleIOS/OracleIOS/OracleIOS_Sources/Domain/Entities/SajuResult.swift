import Foundation

/// 간단한 사주 결과 (레거시 호환용)
/// Android: domain/model/SajuResult.kt (lines 3-9)
struct SajuResult: Equatable, Codable {
    /// 오늘의 총운 요약
    let summaryToday: String
    
    /// 사주 기둥 표시 문자열
    let pillars: String
    
    /// 행운 색상 (헥스 코드)
    let luckyColor: String
    
    /// 행운 숫자
    let luckyNumber: Int
    
    /// 생성 시간 (밀리초)
    let generatedAtMillis: Int64
    
    init(
        summaryToday: String,
        pillars: String,
        luckyColor: String = "#FFD700",
        luckyNumber: Int = 7,
        generatedAtMillis: Int64 = Int64(Date().timeIntervalSince1970 * 1000)
    ) {
        self.summaryToday = summaryToday
        self.pillars = pillars
        self.luckyColor = luckyColor
        self.luckyNumber = luckyNumber
        self.generatedAtMillis = generatedAtMillis
    }
    
    /// FortuneResult에서 변환
    init(from result: FortuneResult) {
        self.summaryToday = result.interpretation.components(separatedBy: "\n").first ?? ""
        self.pillars = result.pillars.fullDisplay
        self.luckyColor = result.luckyColors.first ?? "#FFD700"
        self.luckyNumber = result.luckyNumbers.first ?? 7
        self.generatedAtMillis = Int64(result.generatedAt.timeIntervalSince1970 * 1000)
    }
}
