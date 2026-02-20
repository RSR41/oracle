import Foundation

/// 사주 계산 UseCase
/// Android: domain/usecase/BuildMockSajuUseCase.kt 개선
struct CalculateFortuneUseCase {
    private let repository: FortuneRepository
    
    init(repository: FortuneRepository) {
        self.repository = repository
    }
    
    /// 사주 계산 실행
    /// - Parameter birthInfo: 생년월일시 정보
    /// - Returns: 계산 결과
    func execute(birthInfo: BirthInfo) async throws -> FortuneResult {
        try await repository.calculate(birthInfo: birthInfo)
    }
}
