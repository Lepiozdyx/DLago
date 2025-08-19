import Foundation

class BackgroundManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var backgrounds: [Background] = []
    @Published var progress: BackgroundProgress = BackgroundProgress()
    
    // MARK: - Private Properties
    
    private let dataManager: DataManager
    private let saveKey = "FindHiddenWord_Backgrounds_v1"
    private let progressKey = "FindHiddenWord_BackgroundProgress_v1"
    
    // MARK: - Initialization
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        setupInitialBackgrounds()
        loadProgress()
        loadBackgrounds()
        updateBackgroundStates()
    }
    
    // MARK: - Public Methods
    
    var activeBackgroundImageName: String {
        return progress.activeBackground
    }
    
    func purchaseBackground(_ backgroundType: BackgroundType, with coins: Int) -> Bool {
        guard let index = backgrounds.firstIndex(where: { $0.type == backgroundType }),
              !backgrounds[index].isPurchased,
              coins >= backgrounds[index].price else { return false }
        
        backgrounds[index].isPurchased = true
        progress.purchaseBackground(backgroundType.rawValue)
        
        // Automatically set as active after purchase
        setActiveBackground(backgroundType)
        
        return true
    }
    
    func setActiveBackground(_ backgroundType: BackgroundType) {
        guard let background = backgrounds.first(where: { $0.type == backgroundType }),
              background.isPurchased else { return }
        
        // Deactivate current active background
        for index in backgrounds.indices {
            backgrounds[index].isActive = false
        }
        
        // Activate new background
        if let newActiveIndex = backgrounds.firstIndex(where: { $0.type == backgroundType }) {
            backgrounds[newActiveIndex].isActive = true
            progress.setActiveBackground(backgroundType.rawValue)
            saveProgress()
            saveBackgrounds()
            
            // Force UI update
            objectWillChange.send()
        }
    }
    
    func canPurchase(_ backgroundType: BackgroundType, with coins: Int) -> Bool {
        guard let background = backgrounds.first(where: { $0.type == backgroundType }) else { return false }
        return !background.isPurchased && coins >= background.price
    }
    
    func getBackgroundPrice(_ backgroundType: BackgroundType) -> Int {
        return backgrounds.first(where: { $0.type == backgroundType })?.price ?? 0
    }
    
    // MARK: - Private Methods
    
    private func setupInitialBackgrounds() {
        backgrounds = BackgroundType.allCases.map { $0.background }
    }
    
    func updateBackgroundStates() {
        for index in backgrounds.indices {
            let backgroundId = backgrounds[index].id
            backgrounds[index].isPurchased = progress.isPurchased(backgroundId) || backgrounds[index].isDefault
            backgrounds[index].isActive = (backgroundId == progress.activeBackground)
        }
    }
    
    private func saveBackgrounds() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(backgrounds)
            UserDefaults.standard.set(data, forKey: saveKey)
            UserDefaults.standard.synchronize()
        } catch {
            print("Failed to save backgrounds: \(error)")
        }
    }
    
    private func loadBackgrounds() {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else { return }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let savedBackgrounds = try decoder.decode([Background].self, from: data)
            
            // Merge saved state with current backgrounds
            for savedBackground in savedBackgrounds {
                if let index = backgrounds.firstIndex(where: { $0.id == savedBackground.id }) {
                    backgrounds[index].isPurchased = savedBackground.isPurchased
                    backgrounds[index].isActive = savedBackground.isActive
                }
            }
        } catch {
            print("Failed to load backgrounds: \(error)")
        }
    }
    
    private func saveProgress() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(progress)
            UserDefaults.standard.set(data, forKey: progressKey)
            UserDefaults.standard.synchronize()
        } catch {
            print("Failed to save background progress: \(error)")
        }
    }
    
    private func loadProgress() {
        guard let data = UserDefaults.standard.data(forKey: progressKey) else { return }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            progress = try decoder.decode(BackgroundProgress.self, from: data)
        } catch {
            print("Failed to load background progress: \(error)")
            progress = BackgroundProgress()
        }
    }
    
    func clearAllData() {
        UserDefaults.standard.removeObject(forKey: saveKey)
        UserDefaults.standard.removeObject(forKey: progressKey)
        UserDefaults.standard.synchronize()
        
        progress = BackgroundProgress()
        setupInitialBackgrounds()
        updateBackgroundStates()
    }
}
