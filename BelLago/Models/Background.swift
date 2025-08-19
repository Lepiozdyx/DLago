import Foundation

enum BackgroundType: String, Codable, CaseIterable {
    case bg0 = "bg0"
    case bg1 = "bg1" 
    case bg2 = "bg2"
    case bg3 = "bg3"
    case bg4 = "bg4"
    
    var background: Background {
        switch self {
        case .bg0:
            return Background(
                id: "bg0",
                type: .bg0,
                name: "Default",
                imageName: "bg0",
                previewImageName: "bg0_Preview",
                price: 0,
                isDefault: true
            )
        case .bg1:
            return Background(
                id: "bg1",
                type: .bg1,
                name: "Neon",
                imageName: "bg1",
                previewImageName: "bg1_Preview",
                price: 100
            )
        case .bg2:
            return Background(
                id: "bg2",
                type: .bg2,
                name: "Galaxy",
                imageName: "bg2",
                previewImageName: "bg2_Preview",
                price: 100
            )
        case .bg3:
            return Background(
                id: "bg3",
                type: .bg3,
                name: "Matrix",
                imageName: "bg3",
                previewImageName: "bg3_Preview",
                price: 100
            )
        case .bg4:
            return Background(
                id: "bg4",
                type: .bg4,
                name: "Shelter",
                imageName: "bg4",
                previewImageName: "bg4_Preview",
                price: 100
            )
        }
    }
}

struct Background: Identifiable, Codable, Hashable {
    let id: String
    let type: BackgroundType
    let name: String
    let imageName: String
    let previewImageName: String
    let price: Int
    let isDefault: Bool
    var isPurchased: Bool
    var isActive: Bool
    
    init(id: String, type: BackgroundType, name: String, imageName: String, previewImageName: String, price: Int, isDefault: Bool = false, isPurchased: Bool = false, isActive: Bool = false) {
        self.id = id
        self.type = type
        self.name = name
        self.imageName = imageName
        self.previewImageName = previewImageName
        self.price = price
        self.isDefault = isDefault
        self.isPurchased = isPurchased || isDefault
        self.isActive = isActive
    }
    
    var buttonState: BackgroundButtonState {
        if isActive {
            return .used
        } else if isPurchased {
            return .use
        } else {
            return .purchase
        }
    }
}

enum BackgroundButtonState {
    case purchase
    case use
    case used
    
    var title: String {
        switch self {
        case .purchase:
            return "100"
        case .use:
            return "Use"
        case .used:
            return "Used"
        }
    }
    
    var isEnabled: Bool {
        switch self {
        case .purchase, .use:
            return true
        case .used:
            return false
        }
    }
}

struct BackgroundProgress: Codable {
    var purchasedBackgrounds: Set<String> = ["bg0"]
    var activeBackground: String = "bg0"
    
    mutating func purchaseBackground(_ backgroundId: String) {
        purchasedBackgrounds.insert(backgroundId)
    }
    
    mutating func setActiveBackground(_ backgroundId: String) {
        activeBackground = backgroundId
    }
    
    func isPurchased(_ backgroundId: String) -> Bool {
        purchasedBackgrounds.contains(backgroundId)
    }
}
