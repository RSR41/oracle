import Foundation

/// Fortune Repository 구현체
/// Android: repository/SajuRepositoryImpl.kt (lines 12-90)
final class FortuneRepositoryImpl: FortuneRepository {
    private let engine: FortuneEngine
    private let dataStore: SwiftDataStore
    private let userDefaults: UserDefaults
    
    // 마지막 결과 저장 키
    private let lastResultKey = "LastHistoryItem"
    
    init(engine: FortuneEngine, dataStore: SwiftDataStore, userDefaults: UserDefaults = .standard) {
        self.engine = engine
        self.dataStore = dataStore
        self.userDefaults = userDefaults
    }
    
    // MARK: - FortuneRepository
    
    func calculate(birthInfo: BirthInfo) async throws -> FortuneResult {
        try await engine.calculate(birthInfo: birthInfo)
    }
    
    func saveHistory(result: FortuneResult, birthInfo: BirthInfo, profileId: String?) async throws {
        // 입력 정보를 JSON으로 직렬화
        let inputEncoder = JSONEncoder()
        let inputData = try inputEncoder.encode(birthInfo)
        let inputJSON = String(data: inputData, encoding: .utf8) ?? "{}"
        
        // 결과를 JSON으로 직렬화
        let resultEncoder = JSONEncoder()
        let resultData = try resultEncoder.encode(result)
        let resultJSON = String(data: resultData, encoding: .utf8) ?? "{}"
        
        let record = HistoryRecord(
            type: .sajuFortune,
            title: String(localized: "history.saju.title"),
            summary: String(result.interpretation.prefix(40)) + "...",
            payload: resultJSON,
            inputSnapshot: inputJSON,
            profileId: profileId,
            expiresAt: Calendar.current.date(byAdding: .day, value: 7, to: Date())
        )
        
        try await MainActor.run {
            try dataStore.saveHistory(record)
        }
    }
    
    func getHistory() async throws -> [HistoryRecord] {
        try await MainActor.run {
            try dataStore.fetchAllHistory()
        }
    }
    
    func deleteHistory(id: String) async throws {
        try await MainActor.run {
            try dataStore.deleteHistory(id: id)
        }
    }
    
    func saveLastResult(_ item: HistoryItem) async throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(item)
        userDefaults.set(data, forKey: lastResultKey)
    }
    
    func loadLastResult() async throws -> HistoryItem? {
        guard let data = userDefaults.data(forKey: lastResultKey) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(HistoryItem.self, from: data)
    }
}
