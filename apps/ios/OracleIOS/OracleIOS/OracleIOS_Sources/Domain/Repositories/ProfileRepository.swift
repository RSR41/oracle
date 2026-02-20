import Foundation

/// 프로필 Repository 프로토콜
/// Android: repository/SajuRepository.kt 프로필 관련 메서드 분리
protocol ProfileRepository {
    /// 모든 프로필 조회
    func loadProfiles() async throws -> [Profile]
    
    /// 프로필 저장
    func saveProfile(_ profile: Profile) async throws
    
    /// 프로필 삭제
    func deleteProfile(id: String) async throws
}
