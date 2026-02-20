import SwiftUI
import Combine

/// 메인 탭 뷰 (네비게이션)
/// Android: ui/navigation/OracleNavHost.kt (lines 40-161)
struct MainTabView: View {
    @EnvironmentObject var container: AppContainer
    
    var body: some View {
        TabView {
            // 사주 탭
            FortuneTab()
                .tabItem {
                    Label(String(localized: "tab.fortune"), systemImage: "star.fill")
                }
            
            // 타로 탭 (Placeholder)
            PlaceholderView(title: String(localized: "menu.tarot"), icon: "suit.club.fill")
                .tabItem {
                    Label(String(localized: "tab.tarot"), systemImage: "suit.club.fill")
                }
            
            // 꿈해몽 탭 (Placeholder)
            PlaceholderView(title: String(localized: "menu.dream"), icon: "moon.stars.fill")
                .tabItem {
                    Label(String(localized: "tab.dream"), systemImage: "moon.stars.fill")
                }
            
            // 관상 탭 (Placeholder)
            PlaceholderView(title: String(localized: "menu.face"), icon: "face.smiling")
                .tabItem {
                    Label(String(localized: "tab.face"), systemImage: "face.smiling")
                }
            
            // 설정 탭 (Placeholder)
            PlaceholderView(title: String(localized: "common.settings"), icon: "gearshape.fill")
                .tabItem {
                    Label(String(localized: "tab.settings"), systemImage: "gearshape.fill")
                }
        }
        .accentColor(.oracleBrown)
    }
}

/// 사주 탭 (네비게이션 스택)
struct FortuneTab: View {
    @EnvironmentObject var container: AppContainer
    @State private var path: [FortuneDestination] = []
    
    enum FortuneDestination: Hashable {
        case result
        case history
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            FortuneInputView(
                viewModel: container.fortuneViewModel,
                onNavigateToResult: {
                    path.append(.result)
                },
                onBack: {}
            )
            .navigationDestination(for: FortuneDestination.self) { destination in
                switch destination {
                case .result:
                    if let result = container.fortuneViewModel.result {
                        FortuneResultView(
                            result: result,
                            birthInfo: BirthInfo(
                                date: container.fortuneViewModel.date,
                                time: container.fortuneViewModel.timeUnknown ? "" : container.fortuneViewModel.time,
                                gender: container.fortuneViewModel.gender,
                                calendarType: container.fortuneViewModel.calendarType
                            ),
                            onSave: {
                                Task {
                                    await container.fortuneViewModel.saveToHistory()
                                }
                            },
                            onBack: {
                                path.removeLast()
                            }
                        )
                    }
                case .history:
                    HistoryView(
                        viewModel: container.fortuneViewModel,
                        onBack: {
                            path.removeLast()
                        }
                    )
                }
            }
        }
    }
}

/// Placeholder 뷰 (아직 구현 안 된 기능)
struct PlaceholderView: View {
    let title: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: icon)
                .font(.system(size: 64))
                .foregroundColor(.oracleOutline)
            
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.oracleBrown)
            
            Text(String(localized: "menu.comingSoon"))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.oracleBeige)
    }
}
