import SwiftUI
import Combine
import SwiftData

/// 의존성 주입 컨테이너
/// Android: core/di/RepositoryModule.kt 대응 (수동 DI)
@MainActor
final class AppContainer: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: - Data Layer
    
    private lazy var dataStore: SwiftDataStore = {
        SwiftDataStore(modelContext: modelContext)
    }()
    
    private lazy var fortuneEngine: FortuneEngine = {
        BasicFortuneEngine()
    }()
    
    // MARK: - Repositories
    
    private lazy var fortuneRepository: FortuneRepository = {
        FortuneRepositoryImpl(engine: fortuneEngine, dataStore: dataStore)
    }()
    
    private lazy var profileRepository: ProfileRepository = {
        ProfileRepositoryImpl(dataStore: dataStore)
    }()
    
    private lazy var settingsRepository: SettingsRepository = {
        SettingsRepositoryImpl()
    }()
    
    // MARK: - UseCases
    
    private lazy var calculateFortuneUseCase: CalculateFortuneUseCase = {
        CalculateFortuneUseCase(repository: fortuneRepository)
    }()
    
    private lazy var saveHistoryUseCase: SaveHistoryUseCase = {
        SaveHistoryUseCase(repository: fortuneRepository)
    }()
    
    private lazy var getHistoryUseCase: GetHistoryUseCase = {
        GetHistoryUseCase(repository: fortuneRepository)
    }()
    
    // MARK: - ViewModels (Cached)
    
    private var _fortuneViewModel: FortuneViewModel?
    
    var fortuneViewModel: FortuneViewModel {
        if let existing = _fortuneViewModel {
            return existing
        }
        
        let vm = FortuneViewModel(
            calculateUseCase: calculateFortuneUseCase,
            saveHistoryUseCase: saveHistoryUseCase,
            getHistoryUseCase: getHistoryUseCase
        )
        _fortuneViewModel = vm
        return vm
    }
}
