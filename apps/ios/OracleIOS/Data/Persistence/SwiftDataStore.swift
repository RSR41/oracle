import Foundation
import SwiftData

/// SwiftData 저장소
/// Android: data/local/HistoryDao.kt + PreferencesManager.kt 기능 통합
@MainActor
final class SwiftDataStore {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - History
    
    /// 히스토리 저장
    func saveHistory(_ record: HistoryRecord) throws {
        let model = HistoryModel(from: record)
        modelContext.insert(model)
        try modelContext.save()
    }
    
    /// 전체 히스토리 조회 (최신순)
    func fetchAllHistory() throws -> [HistoryRecord] {
        let descriptor = FetchDescriptor<HistoryModel>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        let models = try modelContext.fetch(descriptor)
        return models.compactMap { $0.toRecord() }
    }
    
    /// 타입별 히스토리 조회
    func fetchHistory(type: HistoryType) throws -> [HistoryRecord] {
        let typeValue = type.rawValue
        let predicate = #Predicate<HistoryModel> { $0.type == typeValue }
        var descriptor = FetchDescriptor<HistoryModel>(predicate: predicate)
        descriptor.sortBy = [SortDescriptor(\.createdAt, order: .reverse)]
        
        let models = try modelContext.fetch(descriptor)
        return models.compactMap { $0.toRecord() }
    }
    
    /// 히스토리 삭제
    func deleteHistory(id: String) throws {
        let predicate = #Predicate<HistoryModel> { $0.id == id }
        try modelContext.delete(model: HistoryModel.self, where: predicate)
        try modelContext.save()
    }
    
    /// 전체 히스토리 삭제
    func deleteAllHistory() throws {
        try modelContext.delete(model: HistoryModel.self)
        try modelContext.save()
    }
    
    // MARK: - Profile
    
    /// 프로필 저장
    func saveProfile(_ profile: Profile) throws {
        // 기존 프로필 삭제 후 저장 (upsert)
        let profileId = profile.id
        let predicate = #Predicate<ProfileModel> { $0.id == profileId }
        try modelContext.delete(model: ProfileModel.self, where: predicate)
        
        let model = ProfileModel(from: profile)
        modelContext.insert(model)
        try modelContext.save()
    }
    
    /// 전체 프로필 조회
    func fetchAllProfiles() throws -> [Profile] {
        let descriptor = FetchDescriptor<ProfileModel>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        let models = try modelContext.fetch(descriptor)
        return models.compactMap { $0.toProfile() }
    }
    
    /// 프로필 삭제
    func deleteProfile(id: String) throws {
        let predicate = #Predicate<ProfileModel> { $0.id == id }
        try modelContext.delete(model: ProfileModel.self, where: predicate)
        try modelContext.save()
    }
}
