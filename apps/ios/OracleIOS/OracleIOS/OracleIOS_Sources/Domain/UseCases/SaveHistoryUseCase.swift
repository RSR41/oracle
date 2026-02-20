import Foundation

/// 히스토리 저장 UseCase
struct SaveHistoryUseCase {
    private let repository: FortuneRepository
    
    init(repository: FortuneRepository) {
        self.repository = repository
    }
    
    /// 결과를 히스토리에 저장
    func execute(result: FortuneResult, birthInfo: BirthInfo, profileId: String? = nil) async throws {
        try await repository.saveHistory(result: result, birthInfo: birthInfo, profileId: profileId)
    }
}
