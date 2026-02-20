import Foundation

/// 달력 타입 열거형
/// Android: domain/model/CalendarType.kt (lines 3-10)
enum CalendarType: String, Codable, CaseIterable, Identifiable {
    case solar = "solar"
    case lunar = "lunar"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .solar: return L("common.solar")
        case .lunar: return L("common.lunar")
        }
    }
}
