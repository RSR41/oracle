import Foundation
import SwiftData

/// 의존성 주입 컨테이너
/// Android: core/di/RepositoryModule.kt 대응 (수동 DI)
@MainActor
final class AppContainer: ObservableObject {
    private let modelContext: ModelContext
    
    // MARK: - Cached Data (Source of Truth)
    let sajuContent: [SajuContent]
    let tarotCards: [TarotCard]
    let dreamInterpretations: [DreamInterpretation]
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
        
        // 1. Core Data / Repositories Initialization
        // (Lazy properties handles initialization)
        
        // 2. Load JSON Data (Blocking Load on Startup - OK for MVP size)
        self.sajuContent = JsonDataLoader.load(filename: "saju_content")
        self.tarotCards = JsonDataLoader.load(filename: "tarot_cards")
        self.dreamInterpretations = JsonDataLoader.load(filename: "dream_interpretations")
        
        print("✅ AppContainer: Data Loaded - Saju: \(sajuContent.count), Tarot: \(tarotCards.count), Dream: \(dreamInterpretations.count)")
    }
    
    // MARK: - Data Layer
    
    private lazy var dataStore: SwiftDataStore = {
        SwiftDataStore(modelContext: modelContext)
    }()
    
    private lazy var fortuneEngine: FortuneEngine = {
        BasicFortuneEngine(sajuContents: sajuContent)
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
    private var _settingsViewModel: SettingsViewModel?
    private var _tarotViewModel: TarotViewModel?
    private var _dreamViewModel: DreamViewModel?
    private var _faceViewModel: FaceViewModel?
    
    var fortuneViewModel: FortuneViewModel {
        if let existing = _fortuneViewModel { return existing }
        
        let vm = FortuneViewModel(
            calculateUseCase: calculateFortuneUseCase,
            saveHistoryUseCase: saveHistoryUseCase,
            getHistoryUseCase: getHistoryUseCase
        )
        _fortuneViewModel = vm
        return vm
    }
    
    var settingsViewModel: SettingsViewModel {
        if let existing = _settingsViewModel { return existing }
        
        let vm = SettingsViewModel(repository: settingsRepository)
        _settingsViewModel = vm
        return vm
    }
    
    var tarotViewModel: TarotViewModel {
        if let existing = _tarotViewModel { return existing }
        
        // Inject loaded cards
        let vm = TarotViewModel(cards: tarotCards)
        _tarotViewModel = vm
        return vm
    }
    
    var dreamViewModel: DreamViewModel {
        if let existing = _dreamViewModel { return existing }
        
        // Inject loaded interpretations
        let vm = DreamViewModel(interpretations: dreamInterpretations)
        _dreamViewModel = vm
        return vm
    }
    
    var faceViewModel: FaceViewModel {
        if let existing = _faceViewModel { return existing }
        
        let vm = FaceViewModel(settingsRepository: settingsRepository)
        _faceViewModel = vm
        return vm
    }
}
