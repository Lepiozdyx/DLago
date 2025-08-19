import Foundation

class AppStateManager: ObservableObject {
    
    // MARK: - Singleton
    
    static let shared = AppStateManager()
    
    // MARK: - Published Properties
    
    @Published var coins: Int = 0
    @Published var unlockedLevels: Set<Int> = [1]
    
    // MARK: - Services
    
    let dataManager: DataManager
    let soundManager: SoundManager
    let helperManager: HelperManager
    let achievementManager: AchievementManager
    let backgroundManager: BackgroundManager
    let dailyTaskManager: DailyTaskManager
    
    // MARK: - Private Properties
    
    private let coinRewardPerLevel: Int = 100
    
    // MARK: - Initialization
    
    private init() {
        self.dataManager = DataManager()
        self.soundManager = SoundManager()
        self.helperManager = HelperManager()
        self.achievementManager = AchievementManager(dataManager: self.dataManager)
        self.backgroundManager = BackgroundManager(dataManager: self.dataManager)
        self.dailyTaskManager = DailyTaskManager(dataManager: self.dataManager)
        
        loadAppState()
        
        // Sync unlocked levels with achievement progress
        achievementManager.progress.unlockedLevels = unlockedLevels
    }
    
    // MARK: - Public Methods
    
    func unlockLevel(_ level: Int) {
        guard level > 0 && level <= 5 else { return }
        
        unlockedLevels.insert(level)
        achievementManager.recordLevelUnlock(level)
        saveAppState()
    }
    
    func addCoins(_ amount: Int) {
        coins += amount
        saveAppState()
    }
    
    func isLevelUnlocked(_ level: Int) -> Bool {
        unlockedLevels.contains(level)
    }
    
    func completeLevel(_ level: Int, attemptsRemaining: Int = 0) {
        addCoins(coinRewardPerLevel)
        
        let attemptsUsed = 10 - attemptsRemaining
        achievementManager.recordLevelCompletion(level, attemptsUsed: attemptsUsed)
        
        let nextLevel = level + 1
        if nextLevel <= 5 {
            unlockLevel(nextLevel)
        }
        
        saveAppState()
    }
    
    func recordSubmit() {
        achievementManager.recordSubmit()
    }
    
    func recordGameOver() {
        achievementManager.recordGameOver()
    }
    
    func claimAchievement(_ achievementType: AchievementType) {
        let reward = achievementManager.claimAchievement(achievementType)
        if reward > 0 {
            addCoins(reward)
        }
    }
    
    // MARK: - Daily Task Methods
    
    func recordGameStarted() {
        dailyTaskManager.recordGameStarted()
    }
    
    func recordShopVisited() {
        dailyTaskManager.recordShopVisited()
    }
    
    func recordPurchaseMade() {
        dailyTaskManager.recordPurchaseMade()
        
        // Check if all backgrounds are purchased after each purchase
        let totalBackgrounds = backgroundManager.backgrounds.count
        let purchasedBackgrounds = backgroundManager.backgrounds.filter { $0.isPurchased }.count
        dailyTaskManager.checkAllBackgroundsPurchased(
            totalBackgrounds: totalBackgrounds,
            purchasedBackgrounds: purchasedBackgrounds
        )
    }
    
    func claimDailyTask(_ taskType: DailyTaskType) {
        let reward = dailyTaskManager.claimTask(taskType)
        if reward > 0 {
            addCoins(reward)
        }
    }
    
    // MARK: - Background Methods
    
    func getCurrentBackgroundImageName() -> String {
        return backgroundManager.activeBackgroundImageName
    }
    
    func purchaseBackground(_ backgroundType: BackgroundType) -> Bool {
        let price = backgroundManager.getBackgroundPrice(backgroundType)
        
        if backgroundManager.purchaseBackground(backgroundType, with: coins) {
            addCoins(-price)
            
            // Record purchase for daily tasks
            recordPurchaseMade()
            
            return true
        }
        
        return false
    }
    
    func setActiveBackground(_ backgroundType: BackgroundType) {
        backgroundManager.setActiveBackground(backgroundType)
        // Force UI update by triggering objectWillChange
        objectWillChange.send()
    }
    
    func canAffordBackground(_ backgroundType: BackgroundType) -> Bool {
        return backgroundManager.canPurchase(backgroundType, with: coins)
    }
    
    // MARK: - Save/Load Methods
    
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
        
        // Sync with achievement manager
        achievementManager.progress.unlockedLevels = unlockedLevels
    }
    
    func clearAllProgress() {
        dataManager.clearProgress()
        achievementManager.clearAllData()
        backgroundManager.clearAllData()
        dailyTaskManager.clearAllData()
        coins = 0
        unlockedLevels = [1]
        saveAppState()
    }
}
