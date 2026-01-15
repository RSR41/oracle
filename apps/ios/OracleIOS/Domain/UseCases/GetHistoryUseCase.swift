import Foundation

/// 히스토리 조회 UseCase
struct GetHistoryUseCase {
    private let repository: FortuneRepository
    
    init(repository: FortuneRepository) {
        self.repository = repository
    }
    
    /// 전체 히스토리 조회
    func execute() async throws -> [HistoryRecord] {
        try await repository.getHistory()
    }
}
