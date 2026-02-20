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
    
    /// 음력 윤달 사용 여부
    var isLunarLeapMonthEnabled: Bool { get async throws }
    func setLunarLeapMonthEnabled(_ enabled: Bool) async throws
}

/// 테마 모드
/// Android: domain/model/ThemeMode.kt
enum ThemeMode: String, Codable, CaseIterable {
    case light
    case dark
    case system
    
    var displayName: String {
        switch self {
        case .light: return L("settings.theme.light")
        case .dark: return L("settings.theme.dark")
        case .system: return L("settings.theme.system")
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
        case .korean: return L("settings.language.korean")
        case .english: return L("settings.language.english")
        case .system: return L("settings.language.system")
        }
    }
}
