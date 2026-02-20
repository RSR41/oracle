import Foundation

/// 히스토리 타입 열거형
/// Android: domain/model/HistoryType.kt
enum HistoryType: String, Codable, CaseIterable {
    case sajuFortune = "SAJU_FORTUNE"
    case manseDaeun = "MANSE_DAEUN"
    case manseSeun = "MANSE_SEUN"
    case manseWolun = "MANSE_WOLUN"
    case compatibility = "COMPATIBILITY"
    case tarot = "TAROT"
    case face = "FACE"
    case dream = "DREAM"
    
    var displayName: String {
        switch self {
        case .sajuFortune: return L("menu.saju")
        case .manseDaeun, .manseSeun, .manseWolun: return L("menu.manse")
        case .compatibility: return L("menu.compatibility")
        case .tarot: return L("menu.tarot")
        case .dream: return L("menu.dream")
        case .face: return L("menu.face")
        }
    }
    
    var icon: String {
        switch self {
        case .sajuFortune, .manseDaeun, .manseSeun, .manseWolun: return "star.fill"
        case .compatibility: return "heart.fill"
        case .tarot: return "suit.club.fill"
        case .dream: return "moon.stars.fill"
        case .face: return "face.smiling"
        }
    }
}
