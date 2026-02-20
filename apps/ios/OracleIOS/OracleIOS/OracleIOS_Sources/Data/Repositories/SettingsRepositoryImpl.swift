import Foundation

/// 설정 Repository 구현체
/// UserDefaults 기반 (Android DataStore 대응)
final class SettingsRepositoryImpl: SettingsRepository {
    private let userDefaults: UserDefaults
    
    // Keys
    private enum Keys {
        static let calendarType = "defaultCalendarType"
        static let themeMode = "themeMode"
        static let appLanguage = "appLanguage"
        static let faceConsent = "faceConsent"
    }
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - Calendar Type
    
    var defaultCalendarType: CalendarType {
        get async throws {
            guard let value = userDefaults.string(forKey: Keys.calendarType),
                  let type = CalendarType(rawValue: value) else {
                return .solar
            }
            return type
        }
    }
    
    func setDefaultCalendarType(_ type: CalendarType) async throws {
        userDefaults.set(type.rawValue, forKey: Keys.calendarType)
    }
    
    // MARK: - Theme Mode
    
    var themeMode: ThemeMode {
        get async throws {
            guard let value = userDefaults.string(forKey: Keys.themeMode),
                  let mode = ThemeMode(rawValue: value) else {
                return .system
            }
            return mode
        }
    }
    
    func setThemeMode(_ mode: ThemeMode) async throws {
        userDefaults.set(mode.rawValue, forKey: Keys.themeMode)
    }
    
    // MARK: - App Language
    
    var appLanguage: AppLanguage {
        get async throws {
            guard let value = userDefaults.string(forKey: Keys.appLanguage),
                  let lang = AppLanguage(rawValue: value) else {
                return .system
            }
            return lang
        }
    }
    
    func setAppLanguage(_ language: AppLanguage) async throws {
        userDefaults.set(language.rawValue, forKey: Keys.appLanguage)
    }
    
    // MARK: - Face Consent
    
    var faceConsent: Bool {
        get async throws {
            userDefaults.bool(forKey: Keys.faceConsent)
        }
    }
    
    func setFaceConsent(_ consented: Bool) async throws {
        userDefaults.set(consented, forKey: Keys.faceConsent)
    }
}
