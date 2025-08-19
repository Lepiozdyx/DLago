import Foundation

enum HelperTrigger: String, Codable, CaseIterable {
    case firstStart = "firstStart"
    case levelStart = "levelStart"
    case submitFail = "submitFail"
    case victory = "victory"
    case defeat = "defeat"
    
    // MARK: - Computed Properties
    
    var messageCategory: String {
        switch self {
        case .firstStart:
            return "onboarding"
        case .levelStart:
            return "onboarding"
        case .submitFail:
            return "encouragement"
        case .victory:
            return "victory"
        case .defeat:
            return "defeat"
        }
    }
    
    var shouldShowImmediately: Bool {
        switch self {
        case .firstStart, .levelStart, .victory, .defeat:
            return true
        case .submitFail:
            return false // Can be delayed or skipped if too frequent
        }
    }
    
    var priority: Int {
        switch self {
        case .firstStart:
            return 5
        case .victory, .defeat:
            return 4
        case .levelStart:
            return 3
        case .submitFail:
            return 1
        }
    }
}
