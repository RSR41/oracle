import Foundation

/// 히스토리 기록 모델
/// Android: domain/model/HistoryRecord.kt (lines 7-19)
struct HistoryRecord: Identifiable, Equatable, Codable {
    let id: String
    let type: HistoryType
    let title: String
    let summary: String
    let payload: String  // 상세 데이터 JSON
    let inputSnapshot: String  // 입력 정보 JSON
    let profileId: String?
    let partnerProfileId: String?
    let createdAt: Date
    let expiresAt: Date?
    let locale: String
    
    init(
        id: String = UUID().uuidString,
        type: HistoryType,
        title: String,
        summary: String,
        payload: String,
        inputSnapshot: String = "{}",
        profileId: String? = nil,
        partnerProfileId: String? = nil,
        createdAt: Date = Date(),
        expiresAt: Date? = nil,
        locale: String = "ko"
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.summary = summary
        self.payload = payload
        self.inputSnapshot = inputSnapshot
        self.profileId = profileId
        self.partnerProfileId = partnerProfileId
        self.createdAt = createdAt
        self.expiresAt = expiresAt
        self.locale = locale
    }
}

/// 레거시 히스토리 아이템 (호환용)
/// Android: domain/model/HistoryItem.kt (lines 3-7)
struct HistoryItem: Identifiable, Equatable, Codable {
    let id: String
    let birthInfo: BirthInfo
    let result: SajuResult
}
