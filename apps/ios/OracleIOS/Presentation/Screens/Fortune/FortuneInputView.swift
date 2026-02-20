import SwiftUI

/// 사주 입력 화면
/// Android: ui/screens/InputScreen.kt (lines 26-199)
struct FortuneInputView: View {
    @ObservedObject var viewModel: FortuneViewModel
    var onNavigateToResult: () -> Void
    var onBack: () -> Void
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // 닉네임
                    OracleCard {
                        OracleSectionTitle(text: L("profile.nickname"))
                        TextField(L("profile.nickname.placeholder"), text: $viewModel.nickname)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: viewModel.nickname) { _, newValue in
                                viewModel.updateNickname(newValue)
                            }
                        
                        if let error = viewModel.nicknameError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.oracleError)
                        }
                    }
                    
                    // 생년월일
                    OracleCard {
                        OracleSectionTitle(text: L("profile.birthDate"))
                        TextField("1990-01-01", text: $viewModel.date)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.numbersAndPunctuation)
                            .onChange(of: viewModel.date) { _, newValue in
                                viewModel.updateDate(newValue)
                            }
                        
                        if let error = viewModel.dateError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.oracleError)
                        }
                    }
                    
                    // 출생 시간
                    OracleCard {
                        OracleSectionTitle(text: L("profile.birthTime"))
                        
                        HStack {
                            TextField("14:30", text: $viewModel.time)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.numbersAndPunctuation)
                                .disabled(viewModel.timeUnknown)
                                .onChange(of: viewModel.time) { _, newValue in
                                    viewModel.updateTime(newValue)
                                }
                            
                            Toggle(isOn: $viewModel.timeUnknown) {
                                Text(L("profile.birthTime.unknown"))
                                    .font(.subheadline)
                            }
                            .toggleStyle(.button)
                            .onChange(of: viewModel.timeUnknown) { _, newValue in
                                viewModel.updateTimeUnknown(newValue)
                            }
                        }
                        
                        if let error = viewModel.timeError {
                            Text(error)
                                .font(.caption)
                                .foregroundColor(.oracleError)
                        }
                    }
                    
                    // 성별 & 달력 타입
                    OracleCard {
                        OracleSectionTitle(text: L("profile.gender"))
                        SelectableChipRow(
                            options: Gender.allCases,
                            selected: $viewModel.gender,
                            labelProvider: { $0.displayName }
                        )
                        
                        Divider()
                            .padding(.vertical, 8)
                        
                        OracleSectionTitle(text: L("profile.calendarType"))
                        SelectableChipRow(
                            options: CalendarType.allCases,
                            selected: $viewModel.calendarType,
                            labelProvider: { $0.displayName }
                        )
                        
                        // 윤달 (음력일 때만)
                        if viewModel.calendarType == .lunar {
                            Toggle(L("input.leapMonth"), isOn: $viewModel.isLeapMonth)
                                .padding(.top, 8)
                                .onChange(of: viewModel.isLeapMonth) { _, newValue in
                                    viewModel.updateIsLeapMonth(newValue)
                                }
                        }
                    }
                    
                    // 프로필 저장 체크
                    Toggle(isOn: $viewModel.isSaveProfileChecked) {
                        Text(L("profile.saveForLater"))
                    }
                    .padding(.horizontal, 8)
                    .onChange(of: viewModel.isSaveProfileChecked) { _, newValue in
                        viewModel.updateSaveProfile(newValue)
                    }
                    
                    // 결과 보기 버튼
                    OracleButton(
                        text: L("input.viewResult"),
                        action: {
                            viewModel.calculateAndNavigate()
                        },
                        isEnabled: !viewModel.isLoading
                    )
                    
                    if viewModel.isLoading {
                        ProgressView()
                    }
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.oracleError)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 16)
            }
            .background(Color.oracleBeige)
            .navigationTitle(L("profile.setup.title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: onBack) {
                        Image(systemName: "chevron.left")
                    }
                }
            }
        }
        .onChange(of: viewModel.shouldNavigateToResult) { _, shouldNavigate in
            if shouldNavigate {
                onNavigateToResult()
                viewModel.onNavigatedToResult()
            }
        }
    }
}
