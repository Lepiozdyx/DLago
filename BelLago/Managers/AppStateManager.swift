//
//  AppStateManager.swift
//  BelLago
//
//  Created by Alex on 15.08.2025.
//


import Foundation

class AppStateManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = AppStateManager()
    
    // MARK: - Published Properties
    
    @Published var coins: Int = 0
    @Published var unlockedLevels: Set<Int> = [1]
    @Published var currentLevel: Int?
    @Published var gameVMs: [Int: GameViewModel] = [:]
    
    // MARK: - Services
    
    let dataManager: DataManager
    let soundManager: SoundManager
    let helperManager: HelperManager
    
    // MARK: - Private Properties
    
    private let coinRewardPerLevel: Int = 100
    
    // MARK: - Initialization
    
    private init() {
        self.dataManager = DataManager()
        self.soundManager = SoundManager()
        self.helperManager = HelperManager()
        
        loadAppState()
    }
    
    // MARK: - Public Methods
    
    func unlockLevel(_ level: Int) {
        guard level > 0 && level <= 5 else { return }
        
        unlockedLevels.insert(level)
        saveAppState()
    }
    
    func addCoins(_ amount: Int) {
        coins += amount
        saveAppState()
    }
    
    func isLevelUnlocked(_ level: Int) -> Bool {
        unlockedLevels.contains(level)
    }
    
    func startLevel(_ level: Int, config: LevelConfig) {
        guard isLevelUnlocked(level) else { return }
        
        currentLevel = level
        
        if gameVMs[level] == nil {
            gameVMs[level] = GameViewModel(levelConfig: config)
        }
        
        gameVMs[level]?.startLevel()
    }
    
    func completeLevel(_ level: Int) {
        addCoins(coinRewardPerLevel)
        
        let nextLevel = level + 1
        if nextLevel <= 5 {
            unlockLevel(nextLevel)
        }
        
        currentLevel = nil
        saveAppState()
    }
    
    func resetLevel(_ level: Int) {
        gameVMs[level]?.resetLevel()
    }
    
    func exitCurrentLevel() {
        currentLevel = nil
    }
    
    func saveAppState() {
        let progress = SavedProgress(
            unlockedLevels: Array(unlockedLevels),
            coins: coins,
            bestTimes: [:],
            dateSaved: Date()
        )
        dataManager.save(progress: progress)
    }
    
    func loadAppState() {
        guard let progress = dataManager.loadProgress() else {
            // First time launch - set defaults
            coins = 0
            unlockedLevels = [1]
            return
        }
        
        coins = progress.coins
        unlockedLevels = Set(progress.unlockedLevels)
        
        // Ensure level 1 is always unlocked
        unlockedLevels.insert(1)
    }
    
    func clearAllProgress() {
        dataManager.clearProgress()
        coins = 0
        unlockedLevels = [1]
        currentLevel = nil
        gameVMs.removeAll()
        saveAppState()
    }
}