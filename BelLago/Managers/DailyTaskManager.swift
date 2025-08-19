import Foundation

class DailyTaskManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var dailyTasks: [DailyTask] = []
    @Published var progress: DailyTaskProgress = DailyTaskProgress()
    @Published var canReceiveDailyBonus: Bool = true
    
    // MARK: - Private Properties
    
    private let dataManager: DataManager
    private let saveKey = "FindHiddenWord_DailyTasks_v1"
    private let progressKey = "FindHiddenWord_DailyTaskProgress_v1"
    
    // MARK: - Constants
    
    private let dailyBonusAmount: Int = 10
    
    // MARK: - Initialization
    
    init(dataManager: DataManager) {
        self.dataManager = dataManager
        setupInitialTasks()
        loadProgress()
        loadDailyTasks()
        updateDailyBonusAvailability()
        checkAllTasks()
    }
    
    // MARK: - Public Methods
    
    func recordGameStarted() {
        progress.recordGameStarted()
        checkGameStartedTask()
        saveProgress()
    }
    
    func recordShopVisited() {
        progress.recordShopVisited()
        checkShopVisitedTask()
        saveProgress()
    }
    
    func recordPurchaseMade() {
        progress.recordPurchaseMade()
        checkPurchaseMadeTask()
        saveProgress()
    }
    
    func checkAllBackgroundsPurchased(totalBackgrounds: Int, purchasedBackgrounds: Int) {
        if purchasedBackgrounds >= totalBackgrounds {
            progress.recordAllBackgroundsPurchased()
            checkAllBackgroundsPurchasedTask()
            saveProgress()
        }
    }
    
    func claimDailyBonus() -> Int {
        guard canReceiveDailyBonus else { return 0 }
        
        progress.recordDailyBonusReceived()
        updateDailyBonusAvailability()
        saveProgress()
        
        return dailyBonusAmount
    }
    
    func claimTask(_ taskType: DailyTaskType) -> Int {
        guard let index = dailyTasks.firstIndex(where: { $0.type == taskType }),
              dailyTasks[index].canClaim else { return 0 }
        
        let reward = dailyTasks[index].coinReward
        dailyTasks[index].isClaimed = true
        saveDailyTasks()
        
        return reward
    }
    
    func checkAllTasks() {
        checkGameStartedTask()
        checkShopVisitedTask()
        checkPurchaseMadeTask()
        checkAllBackgroundsPurchasedTask()
        // Decorative tasks are always false unless manually set
    }
    
    // MARK: - Private Task Checks
    
    private func checkGameStartedTask() {
        if progress.gameStarted {
            completeTask(.gameStarted)
        }
    }
    
    private func checkShopVisitedTask() {
        if progress.shopVisited {
            completeTask(.shopVisited)
        }
    }
    
    private func checkPurchaseMadeTask() {
        if progress.purchaseMade {
            completeTask(.purchaseMade)
        }
    }
    
    private func checkAllBackgroundsPurchasedTask() {
        if progress.allBackgroundsPurchased {
            completeTask(.allBackgroundsPurchased)
        }
    }
    
    private func completeTask(_ type: DailyTaskType) {
        guard let index = dailyTasks.firstIndex(where: { $0.type == type }),
              !dailyTasks[index].isCompleted else { return }
        
        dailyTasks[index].isCompleted = true
        dailyTasks[index].completedDate = Date()
        saveDailyTasks()
    }
    
    private func updateDailyBonusAvailability() {
        canReceiveDailyBonus = progress.canReceiveDailyBonus
    }
    
    // MARK: - Data Persistence
    
    private func setupInitialTasks() {
        dailyTasks = DailyTaskType.allCases.map { $0.dailyTask }
    }
    
    private func saveDailyTasks() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let data = try encoder.encode(dailyTasks)
            UserDefaults.standard.set(data, forKey: saveKey)
            UserDefaults.standard.synchronize()
        } catch {
            print("Failed to save daily tasks: \(error)")
        }
    }
    
    private func loadDailyTasks() {
        guard let data = UserDefaults.standard.data(forKey: saveKey) else { return }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let savedTasks = try decoder.decode([DailyTask].self, from: data)
            
            // Merge saved state with current tasks
            for savedTask in savedTasks {
                if let index = dailyTasks.firstIndex(where: { $0.id == savedTask.id }) {
                    dailyTasks[index].isCompleted = savedTask.isCompleted
                    dailyTasks[index].isClaimed = savedTask.isClaimed
                    dailyTasks[index].completedDate = savedTask.completedDate
                }
            }
        } catch {
            print("Failed to load daily tasks: \(error)")
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
            print("Failed to save daily task progress: \(error)")
        }
    }
    
    private func loadProgress() {
        guard let data = UserDefaults.standard.data(forKey: progressKey) else { return }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            progress = try decoder.decode(DailyTaskProgress.self, from: data)
        } catch {
            print("Failed to load daily task progress: \(error)")
            progress = DailyTaskProgress()
        }
    }
    
    func clearAllData() {
        UserDefaults.standard.removeObject(forKey: saveKey)
        UserDefaults.standard.removeObject(forKey: progressKey)
        UserDefaults.standard.synchronize()
        
        progress = DailyTaskProgress()
        setupInitialTasks()
        updateDailyBonusAvailability()
    }
}
