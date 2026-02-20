import SwiftUI
import SwiftData

/// 앱 진입점
/// Android: MainActivity.kt + OracleApplication.kt 대응
@main
struct OracleIOSApp: App {
    let modelContainer: ModelContainer
    @StateObject private var container: AppContainer
    
    init() {
        // SwiftData ModelContainer 생성
        do {
            let schema = Schema([
                HistoryModel.self,
                ProfileModel.self
            ])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            let container = try ModelContainer(for: schema, configurations: [config])
            self.modelContainer = container
            
            // AppContainer 초기화
            let appContainer = AppContainer(modelContext: container.mainContext)
            self._container = StateObject(wrappedValue: appContainer)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environmentObject(container)
                .modelContainer(modelContainer)
        }
    }
}
