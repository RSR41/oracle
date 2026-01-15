import Foundation

/// 히스토리 타입 열거형
/// Android: domain/model/HistoryType.kt
enum HistoryType: String, Codable, CaseIterable {
    case sajuFortune = "SAJU_FORTUNE"
    case compatibility = "COMPATIBILITY"
    case tarot = "TAROT"
    case dream = "DREAM"
    case faceReading = "FACE_READING"
    
    var displayName: String {
        switch self {
        case .sajuFortune: return String(localized: "menu.saju")
        case .compatibility: return String(localized: "menu.compatibility")
        case .tarot: return String(localized: "menu.tarot")
        case .dream: return String(localized: "menu.dream")
        case .faceReading: return String(localized: "menu.face")
        }
    }
    
    var icon: String {
        switch self {
        case .sajuFortune: return "star.fill"
        case .compatibility: return "heart.fill"
        case .tarot: return "suit.club.fill"
        case .dream: return "moon.stars.fill"
        case .faceReading: return "face.smiling"
        }
    }
}
