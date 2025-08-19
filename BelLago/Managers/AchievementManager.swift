import Foundation

class AchievementManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var achievements: [Achievement] = []
    @Published var progress: AchievementProgress = AchievementProgress()
    
    // MARK: - Private Properties
    
    private let dataManager: DataManager
    private let saveKey = "FindHiddenWord_Achievements_v1"
    private let progressKey = "FindHiddenWord_Progress_v1"
    
    // MARK: - Initialization
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        setupInitialAchievements()
        loadProgress()
        loadAchievements()
        checkAllAchievements()
    }
    
    // MARK: - Public Methods
    
    func recordSubmit() {
        progress.recordSubmit()
        checkFirstGuessAchievement()
        saveProgress()
    }
    
    func recordLevelCompletion(_ level: Int, attemptsUsed: Int) {
        let totalAttempts = 10 - attemptsUsed + 1
        progress.recordLevelCompletion(level, attemptsUsed: totalAttempts)
        checkCodeBreakerAchievement()
        checkPerfectionAchievement()
        saveProgress()
    }
    
    func recordGameOver() {
        progress.recordGameOver()
        checkPersistenceAchievement()
        saveProgress()
    }
    
    func recordLevelUnlock(_ level: Int) {
        progress.recordLevelUnlock(level)
        checkTravelerAchievement()
        saveProgress()
    }
    
    func claimAchievement(_ achievementType: AchievementType) -> Int {
        guard let index = achievements.firstIndex(where: { $0.type == achievementType }),
              achievements[index].canClaim else { return 0 }
        
        let reward = achievements[index].coinReward
        achievements[index].isClaimed = true
        saveAchievements()
        
        return reward
    }
    
    func checkAllAchievements() {
        checkFirstGuessAchievement()
        checkCodeBreakerAchievement()
        checkPersistenceAchievement()
        checkTravelerAchievement()
        checkPerfectionAchievement()
    }
    
    // MARK: - Private Achievement Checks
    
    private func checkFirstGuessAchievement() {
        if progress.totalSubmits >= 1 {
            unlockAchievement(.firstGuess)
        }
    }
    
    private func checkCodeBreakerAchievement() {
        if progress.completedLevels.contains(1) {
            unlockAchievement(.codeBreaker)
        }
    }
    
    private func checkPersistenceAchievement() {
        if progress.totalGameOvers >= 1 {
            unlockAchievement(.persistence)
        }
    }
    
    private func checkTravelerAchievement() {
        let allLevels: Set<Int> = [1, 2, 3, 4, 5]
        if progress.unlockedLevels.isSuperset(of: allLevels) {
            unlockAchievement(.traveler)
        }
    }
    
    private func checkPerfectionAchievement() {
        if progress.perfectWins >= 1 {
            unlockAchievement(.perfection)
        }
    }
    
    private func unlockAchievement(_ type: AchievementType) {
        guard let index = achievements.firstIndex(where: { $0.type == type }),
              !achievements[index].isUnlocked else { return }
        
        achievements[index].isUnlocked = true
        saveAchievements()
    }
    
    // MARK: - Data Persistence
    
    private func setupInitialAchievements() {
        achievements = AchievementType.allCases.map { $0.achievement }
    }
    
    private func saveAchievements() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(achievements)
            UserDefaults.standard.set(data, forKey: saveKey)
            UserDefaults.standard.synchronize()
        } catch {
            print("Failed to save achievements: \(error)")
        }
    }
    
    private func loadAchievements() {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else { return }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let savedAchievements = try decoder.decode([Achievement].self, from: data)
            
            // Merge saved state with current achievements
            for savedAchievement in savedAchievements {
                if let index = achievements.firstIndex(where: { $0.id == savedAchievement.id }) {
                    achievements[index].isUnlocked = savedAchievement.isUnlocked
                    achievements[index].isClaimed = savedAchievement.isClaimed
                }
            }
        } catch {
            print("Failed to load achievements: \(error)")
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
            print("Failed to save progress: \(error)")
        }
    }
    
    private func loadProgress() {
        guard let data = UserDefaults.standard.data(forKey: progressKey) else { return }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            progress = try decoder.decode(AchievementProgress.self, from: data)
        } catch {
            print("Failed to load progress: \(error)")
            progress = AchievementProgress()
        }
    }
    
    func clearAllData() {
        UserDefaults.standard.removeObject(forKey: saveKey)
        UserDefaults.standard.removeObject(forKey: progressKey)
        UserDefaults.standard.synchronize()
        
        progress = AchievementProgress()
        setupInitialAchievements()
    }
}
