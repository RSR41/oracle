import Foundation
import SwiftData

/// 히스토리 저장용 SwiftData 모델
/// Android: data/local/HistoryEntity.kt (lines 15-26)
@Model
final class HistoryModel {
    @Attribute(.unique) var id: String
    var type: String  // HistoryType.rawValue
    var title: String
    var summary: String
    var payload: String  // 상세 데이터 JSON
    var inputSnapshot: String
    var profileId: String?
    var partnerProfileId: String?
    var createdAt: Date
    var expiresAt: Date?
    var locale: String
    var isPremium: Bool
    
    init(
        id: String = UUID().uuidString,
        type: String,
        title: String,
        summary: String,
        payload: String,
        inputSnapshot: String = "{}",
        profileId: String? = nil,
        partnerProfileId: String? = nil,
        createdAt: Date = Date(),
        expiresAt: Date? = nil,
        locale: String = "ko",
        isPremium: Bool = false
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
        self.isPremium = isPremium
    }
    
    /// HistoryRecord에서 변환
    convenience init(from record: HistoryRecord) {
        self.init(
            id: record.id,
            type: record.type.rawValue,
            title: record.title,
            summary: record.summary,
            payload: record.payload,
            inputSnapshot: record.inputSnapshot,
            profileId: record.profileId,
            partnerProfileId: record.partnerProfileId,
            createdAt: record.createdAt,
            expiresAt: record.expiresAt,
            locale: record.locale,
            isPremium: record.isPremium
        )
    }
    
    /// HistoryRecord로 변환
    func toRecord() -> HistoryRecord? {
        guard let historyType = HistoryType(rawValue: type) else { return nil }
        
        return HistoryRecord(
            id: id,
            type: historyType,
            title: title,
            summary: summary,
            payload: payload,
            inputSnapshot: inputSnapshot,
            profileId: profileId,
            partnerProfileId: partnerProfileId,
            createdAt: createdAt,
            expiresAt: expiresAt,
            locale: locale,
            isPremium: isPremium
        )
    }
}
