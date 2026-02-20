import Foundation

/// 사주 입력을 위한 사용자 프로필
/// Android: domain/model/ApiModels.kt (lines 32-41)
struct Profile: Identifiable, Equatable, Codable {
    let id: String
    let nickname: String
    let birthDate: String // yyyy-MM-dd
    let birthTime: String? // HH:mm
    let timeUnknown: Bool
    let calendarType: CalendarType
    let gender: Gender
    let createdAt: Date
    
    init(
        id: String = UUID().uuidString,
        nickname: String,
        birthDate: String,
        birthTime: String? = nil,
        timeUnknown: Bool = false,
        calendarType: CalendarType = .solar,
        gender: Gender = .male,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.nickname = nickname
        self.birthDate = birthDate
        self.birthTime = birthTime
        self.timeUnknown = timeUnknown
        self.calendarType = calendarType
        self.gender = gender
        self.createdAt = createdAt
    }
    
    /// BirthInfo로 변환
    func toBirthInfo() -> BirthInfo {
        BirthInfo(
            date: birthDate,
            time: birthTime ?? "",
            gender: gender,
            calendarType: calendarType
        )
    }
}
