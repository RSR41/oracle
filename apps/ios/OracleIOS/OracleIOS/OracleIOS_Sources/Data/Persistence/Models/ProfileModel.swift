import Foundation
import SwiftData

/// 프로필 저장용 SwiftData 모델
@Model
final class ProfileModel {
    @Attribute(.unique) var id: String
    var nickname: String
    var birthDate: String
    var birthTime: String?
    var timeUnknown: Bool
    var calendarType: String  // CalendarType.rawValue
    var gender: String  // Gender.rawValue
    var createdAt: Date
    
    init(
        id: String = UUID().uuidString,
        nickname: String,
        birthDate: String,
        birthTime: String? = nil,
        timeUnknown: Bool = false,
        calendarType: String = "solar",
        gender: String = "male",
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
    
    /// Profile에서 변환
    convenience init(from profile: Profile) {
        self.init(
            id: profile.id,
            nickname: profile.nickname,
            birthDate: profile.birthDate,
            birthTime: profile.birthTime,
            timeUnknown: profile.timeUnknown,
            calendarType: profile.calendarType.rawValue,
            gender: profile.gender.rawValue,
            createdAt: profile.createdAt
        )
    }
    
    /// Profile로 변환
    func toProfile() -> Profile? {
        guard let calType = CalendarType(rawValue: calendarType),
              let gen = Gender(rawValue: gender) else { return nil }
        
        return Profile(
            id: id,
            nickname: nickname,
            birthDate: birthDate,
            birthTime: birthTime,
            timeUnknown: timeUnknown,
            calendarType: calType,
            gender: gen,
            createdAt: createdAt
        )
    }
}
