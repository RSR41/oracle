import Foundation

/// 사주 Repository 프로토콜
/// Android: repository/SajuRepository.kt (lines 11-51) 간소화 버전
protocol FortuneRepository {
    /// 사주 계산
    func calculate(birthInfo: BirthInfo) async throws -> FortuneResult
    
    /// 히스토리 저장
    func saveHistory(result: FortuneResult, birthInfo: BirthInfo, profileId: String?) async throws
    
    /// 히스토리 조회
    func getHistory() async throws -> [HistoryRecord]
    
    /// 히스토리 삭제
    func deleteHistory(id: String) async throws
    
    /// 마지막 결과 저장
    func saveLastResult(_ item: HistoryItem) async throws
    
    /// 마지막 결과 조회
    func loadLastResult() async throws -> HistoryItem?
}
