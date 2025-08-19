import Foundation

enum DailyTaskType: String, Codable, CaseIterable {
    case gameStarted = "gameStarted"
    case shopVisited = "shopVisited"
    case purchaseMade = "purchaseMade"
    case allBackgroundsPurchased = "allBackgroundsPurchased"
    case playTime15Minutes = "playTime15Minutes"
    case winWithLessThan3Attempts = "winWithLessThan3Attempts"
    
    var dailyTask: DailyTask {
        switch self {
        case .gameStarted:
            return DailyTask(
                id: "game_started",
                type: .gameStarted,
                title: "Start Game",
                description: "Launch the game and start playing",
                iconName: "icon_award",
                coinReward: 10
            )
        case .shopVisited:
            return DailyTask(
                id: "shop_visited",
                type: .shopVisited,
                title: "Visit Shop",
                description: "Browse the in-game shop",
                iconName: "icon_award",
                coinReward: 10
            )
        case .purchaseMade:
            return DailyTask(
                id: "purchase_made",
                type: .purchaseMade,
                title: "Make Purchase",
                description: "Buy something from the shop",
                iconName: "icon_award",
                coinReward: 10
            )
        case .allBackgroundsPurchased:
            return DailyTask(
                id: "all_backgrounds_purchased",
                type: .allBackgroundsPurchased,
                title: "Collector",
                description: "Purchase all available backgrounds",
                iconName: "icon_award",
                coinReward: 10
            )
        case .playTime15Minutes:
            return DailyTask(
                id: "play_time_15_minutes",
                type: .playTime15Minutes,
                title: "Time Master",
                description: "Spend your first 15 minutes in game",
                iconName: "icon_award",
                coinReward: 10
            )
        case .winWithLessThan3Attempts:
            return DailyTask(
                id: "win_with_less_than_3_attempts",
                type: .winWithLessThan3Attempts,
                title: "Quick Solver",
                description: "Win a level using less than 3 attempts",
                iconName: "icon_award",
                coinReward: 10
            )
        }
    }
}

struct DailyTask: Identifiable, Codable, Hashable {
    let id: String
    let type: DailyTaskType
    let title: String
    let description: String
    let iconName: String
    let coinReward: Int
    var isCompleted: Bool
    var isClaimed: Bool
    var completedDate: Date?
    
    init(id: String, type: DailyTaskType, title: String, description: String, iconName: String, coinReward: Int, isCompleted: Bool = false, isClaimed: Bool = false, completedDate: Date? = nil) {
        self.id = id
        self.type = type
        self.title = title
        self.description = description
        self.iconName = iconName
        self.coinReward = coinReward
        self.isCompleted = isCompleted
        self.isClaimed = isClaimed
        self.completedDate = completedDate
    }
    
    var canClaim: Bool {
        isCompleted && !isClaimed
    }
    
    var isFinished: Bool {
        isCompleted && isClaimed
    }
}

struct DailyTaskProgress: Codable {
    var hasReceivedDailyBonus: Bool = false
    var lastDailyBonusDate: Date?
    var gameStarted: Bool = false
    var shopVisited: Bool = false
    var purchaseMade: Bool = false
    var allBackgroundsPurchased: Bool = false
    var playTime15Minutes: Bool = false // Decorative only
    var winWithLessThan3Attempts: Bool = false // Decorative only
    
    mutating func recordGameStarted() {
        gameStarted = true
    }
    
    mutating func recordShopVisited() {
        shopVisited = true
    }
    
    mutating func recordPurchaseMade() {
        purchaseMade = true
    }
    
    mutating func recordAllBackgroundsPurchased() {
        allBackgroundsPurchased = true
    }
    
    mutating func recordDailyBonusReceived() {
        hasReceivedDailyBonus = true
        lastDailyBonusDate = Date()
    }
    
    var canReceiveDailyBonus: Bool {
        guard let lastDate = lastDailyBonusDate else { return true }
        
        let calendar = Calendar.current
        let now = Date()
        
        // Check if it's a new day since last bonus
        return !calendar.isDate(lastDate, inSameDayAs: now)
    }
    
    func isTaskCompleted(_ taskType: DailyTaskType) -> Bool {
        switch taskType {
        case .gameStarted:
            return gameStarted
        case .shopVisited:
            return shopVisited
        case .purchaseMade:
            return purchaseMade
        case .allBackgroundsPurchased:
            return allBackgroundsPurchased
        case .playTime15Minutes:
            return playTime15Minutes
        case .winWithLessThan3Attempts:
            return winWithLessThan3Attempts
        }
    }
}
