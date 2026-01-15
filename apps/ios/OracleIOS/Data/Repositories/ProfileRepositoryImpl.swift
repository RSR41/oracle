import Foundation

/// 프로필 Repository 구현체
final class ProfileRepositoryImpl: ProfileRepository {
    private let dataStore: SwiftDataStore
    
    init(dataStore: SwiftDataStore) {
        self.dataStore = dataStore
    }
    
    func loadProfiles() async throws -> [Profile] {
        try await MainActor.run {
            try dataStore.fetchAllProfiles()
        }
    }
    
    func saveProfile(_ profile: Profile) async throws {
        try await MainActor.run {
            try dataStore.saveProfile(profile)
        }
    }
    
    func deleteProfile(id: String) async throws {
        try await MainActor.run {
            try dataStore.deleteProfile(id: id)
        }
    }
}
