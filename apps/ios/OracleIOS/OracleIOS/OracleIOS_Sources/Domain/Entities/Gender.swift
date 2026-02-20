import Foundation

/// 성별 열거형
/// Android: domain/model/Gender.kt (lines 3-10)
enum Gender: String, Codable, CaseIterable, Identifiable {
    case male = "male"
    case female = "female"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .male: return String(localized: "common.male")
        case .female: return String(localized: "common.female")
        }
    }
}
