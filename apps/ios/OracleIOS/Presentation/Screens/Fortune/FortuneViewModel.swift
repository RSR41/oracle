import Foundation
import SwiftUI

/// Fortune 화면 ViewModel
/// Android: ui/screens/InputViewModel.kt (lines 22-248)
@MainActor
final class FortuneViewModel: ObservableObject {
    // MARK: - Published Properties
    
    // 입력 상태
    @Published var nickname: String = ""
    @Published var date: String = "1990-01-01"
    @Published var time: String = ""
    @Published var gender: Gender = .male
    @Published var calendarType: CalendarType = .solar
    @Published var timeUnknown: Bool = false
    @Published var isLeapMonth: Bool = false
    @Published var isSaveProfileChecked: Bool = true
    
    // 에러 상태
    @Published var nicknameError: String?
    @Published var dateError: String?
    @Published var timeError: String?
    
    // 결과 상태
    @Published var result: FortuneResult?
    @Published var history: [HistoryRecord] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // 네비게이션
    @Published var shouldNavigateToResult: Bool = false
    
    // MARK: - Dependencies
    
    private let calculateUseCase: CalculateFortuneUseCase
    private let saveHistoryUseCase: SaveHistoryUseCase
    private let getHistoryUseCase: GetHistoryUseCase
    
    // MARK: - Init
    
    init(
        calculateUseCase: CalculateFortuneUseCase,
        saveHistoryUseCase: SaveHistoryUseCase,
        getHistoryUseCase: GetHistoryUseCase
    ) {
        self.calculateUseCase = calculateUseCase
        self.saveHistoryUseCase = saveHistoryUseCase
        self.getHistoryUseCase = getHistoryUseCase
    }
    
    // MARK: - Input Updates
    
    func updateNickname(_ value: String) {
        nickname = value
        nicknameError = nil
    }
    
    func updateDate(_ value: String) {
        date = value
        dateError = nil
    }
    
    func updateTime(_ value: String) {
        time = value
        timeError = nil
    }
    
    func updateGender(_ value: Gender) {
        gender = value
    }
    
    func updateCalendarType(_ value: CalendarType) {
        calendarType = value
    }
    
    func updateTimeUnknown(_ value: Bool) {
        timeUnknown = value
        if value {
            time = ""
            timeError = nil
        }
    }
    
    func updateIsLeapMonth(_ value: Bool) {
        isLeapMonth = value
    }
    
    func updateSaveProfile(_ value: Bool) {
        isSaveProfileChecked = value
    }
    
    // MARK: - Validation
    
    private func validateInput() -> Bool {
        var isValid = true
        
        // 닉네임 검증 (프로필 저장 시)
        if isSaveProfileChecked && nickname.trimmingCharacters(in: .whitespaces).isEmpty {
            nicknameError = String(localized: "input.error.nickname.required")
            isValid = false
        }
        
        // 날짜 검증
        let datePattern = #"^\d{4}-\d{2}-\d{2}$"#
        if !date.range(of: datePattern, options: .regularExpression).map({ _ in true }) ?? false {
            dateError = String(localized: "input.error.date.format")
            isValid = false
        }
        
        // 시간 검증 (선택 사항, 모름이 아닐 때만)
        if !timeUnknown && !time.isEmpty {
            let timePattern = #"^\d{2}:\d{2}$"#
            if !time.range(of: timePattern, options: .regularExpression).map({ _ in true }) ?? false {
                timeError = String(localized: "input.error.time.format")
                isValid = false
            }
        }
        
        return isValid
    }
    
    // MARK: - Actions
    
    /// 결과 생성 및 이동
    func calculateAndNavigate() {
        guard validateInput() else { return }
        
        Task {
            await calculate()
            if result != nil {
                shouldNavigateToResult = true
            }
        }
    }
    
    /// 사주 계산
    func calculate() async {
        isLoading = true
        errorMessage = nil
        
        let birthInfo = BirthInfo(
            date: date,
            time: timeUnknown ? "" : time,
            gender: gender,
            calendarType: calendarType
        )
        
        do {
            result = try await calculateUseCase.execute(birthInfo: birthInfo)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    /// 히스토리에 저장
    func saveToHistory() async {
        guard let fortuneResult = result else { return }
        
        let birthInfo = BirthInfo(
            date: date,
            time: timeUnknown ? "" : time,
            gender: gender,
            calendarType: calendarType
        )
        
        do {
            try await saveHistoryUseCase.execute(
                result: fortuneResult,
                birthInfo: birthInfo,
                profileId: nil
            )
            await loadHistory()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// 히스토리 로드
    func loadHistory() async {
        do {
            history = try await getHistoryUseCase.execute()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// 결과 화면 이동 완료 처리
    func onNavigatedToResult() {
        shouldNavigateToResult = false
    }
    
    /// 입력 리셋
    func resetToDefaults() {
        nickname = ""
        date = "1990-01-01"
        time = ""
        timeUnknown = false
        isLeapMonth = false
        nicknameError = nil
        dateError = nil
        timeError = nil
        result = nil
    }
}
