import Foundation

/// 생년월일 정보
/// Android: domain/model/BirthInfo.kt (lines 3-8)
struct BirthInfo: Equatable, Codable {
    /// 생년월일 (yyyy-MM-dd 형식)
    let date: String
    
    /// 출생 시간 (HH:mm 형식, 모르면 빈 문자열)
    let time: String
    
    /// 성별
    let gender: Gender
    
    /// 달력 타입 (양력/음력)
    let calendarType: CalendarType
    
    init(
        date: String,
        time: String = "",
        gender: Gender,
        calendarType: CalendarType
    ) {
        self.date = date
        self.time = time
        self.gender = gender
        self.calendarType = calendarType
    }
}
