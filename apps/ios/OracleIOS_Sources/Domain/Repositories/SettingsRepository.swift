import Foundation

/// 설정 Repository 프로토콜
/// Android: repository/SettingsRepository 분리
protocol SettingsRepository {
    /// 기본 달력 타입
    var defaultCalendarType: CalendarType { get async throws }
    func setDefaultCalendarType(_ type: CalendarType) async throws
    
    /// 앱 테마
    var themeMode: ThemeMode { get async throws }
    func setThemeMode(_ mode: ThemeMode) async throws
    
    /// 앱 언어
    var appLanguage: AppLanguage { get async throws }
    func setAppLanguage(_ language: AppLanguage) async throws
    
    /// Face 동의 여부
    var faceConsent: Bool { get async throws }
    func setFaceConsent(_ consented: Bool) async throws
}

/// 테마 모드
/// Android: domain/model/ThemeMode.kt
enum ThemeMode: String, Codable, CaseIterable {
    case light
    case dark
    case system
    
    var displayName: String {
        switch self {
        case .light: return String(localized: "settings.theme.light")
        case .dark: return String(localized: "settings.theme.dark")
        case .system: return String(localized: "settings.theme.system")
        }
    }
}

/// 앱 언어
/// Android: domain/model/AppLanguage.kt
enum AppLanguage: String, Codable, CaseIterable {
    case korean
    case english
    case system
    
    var displayName: String {
        switch self {
        case .korean: return String(localized: "settings.language.korean")
        case .english: return String(localized: "settings.language.english")
        case .system: return String(localized: "settings.language.system")
        }
    }
}
