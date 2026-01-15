import Foundation

/// 사주 계산 엔진 프로토콜
/// Android: domain/engine/EngineInterfaces.kt (lines 10-22)
protocol FortuneEngine {
    /// 사주 계산
    /// - Parameter birthInfo: 생년월일시 정보
    /// - Returns: 천간지지, 오행, 십신, 해석
    func calculate(birthInfo: BirthInfo) async throws -> FortuneResult
    
    /// 엔진 정보 (디버깅/로깅용)
    func getEngineInfo() -> EngineInfo
}

/// 엔진 메타정보
/// Android: domain/engine/EngineInterfaces.kt (lines 36-40)
struct EngineInfo {
    let name: String
    let version: String
    let accuracy: AccuracyLevel
}

/// 정확도 수준
/// Android: domain/engine/EngineInterfaces.kt (line 42)
enum AccuracyLevel {
    case low
    case medium
    case high
}
