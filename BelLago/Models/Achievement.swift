import Foundation

enum AchievementType: String, Codable, CaseIterable {
    case firstGuess = "firstGuess"
    case codeBreaker = "codeBreaker"
    case persistence = "persistence"
    case traveler = "traveler"
    case perfection = "perfection"
    
    var achievement: Achievement {
        switch self {
        case .firstGuess:
            return Achievement(
                id: "first_guess",
                type: .firstGuess,
                title: "First Guess",
                description: "Make your first attempt at cracking the code",
                iconName: "image1",
                coinReward: 10
            )
        case .codeBreaker:
            return Achievement(
                id: "code_breaker",
                type: .codeBreaker,
                title: "Code Breaker",
                description: "Complete the first level",
                iconName: "image2",
                coinReward: 10
            )
        case .persistence:
            return Achievement(
                id: "persistence",
                type: .persistence,
                title: "Persistence",
                description: "Make 10 attempts on any level and get game over",
                iconName: "image3",
                coinReward: 10
            )
        case .traveler:
            return Achievement(
                id: "traveler",
                type: .traveler,
                title: "Traveler",
                description: "Unlock all levels in the game",
                iconName: "image4",
                coinReward: 10
            )
        case .perfection:
            return Achievement(
                id: "perfection",
                type: .perfection,
                title: "Perfection",
                description: "Guess the code on the first try",
                iconName: "image5",
                coinReward: 10
            )
        }
    }
}

struct Achievement: Identifiable, Codable, Hashable {
    let id: String
    let type: AchievementType
    let title: String
    let description: String
    let iconName: String
    let coinReward: Int
    var isUnlocked: Bool
    var isClaimed: Bool
    
    init(id: String, type: AchievementType, title: String, description: String, iconName: String, coinReward: Int, isUnlocked: Bool = false, isClaimed: Bool = false) {
        self.id = id
        self.type = type
        self.title = title
        self.description = description
        self.iconName = iconName
        self.coinReward = coinReward
        self.isUnlocked = isUnlocked
        self.isClaimed = isClaimed
    }
    
    var canClaim: Bool {
        isUnlocked && !isClaimed
    }
    
    var isComplete: Bool {
        isUnlocked && isClaimed
    }
}

struct AchievementProgress: Codable {
    var totalSubmits: Int = 0
    var completedLevels: Set<Int> = []
    var totalGameOvers: Int = 0
    var perfectWins: Int = 0
    var unlockedLevels: Set<Int> = [1]
    
    mutating func recordSubmit() {
        totalSubmits += 1
    }
    
    mutating func recordLevelCompletion(_ level: Int, attemptsUsed: Int) {
        completedLevels.insert(level)
        if attemptsUsed == 1 {
            perfectWins += 1
        }
    }
    
    mutating func recordGameOver() {
        totalGameOvers += 1
    }
    
    mutating func recordLevelUnlock(_ level: Int) {
        unlockedLevels.insert(level)
    }
}
