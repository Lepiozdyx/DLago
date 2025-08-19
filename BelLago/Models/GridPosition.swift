import Foundation

struct GridPosition: Codable, Hashable {
    let row: Int // 0..19
    let col: Int // 0..39
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
    
    // MARK: - Computed Properties
    
    var isValid: Bool {
        row >= 0 && row < 20 && col >= 0 && col < 40
    }
    
    var linearIndex: Int {
        row * 40 + col
    }
    
    // MARK: - Static Methods
    
    static func from(linearIndex: Int) -> GridPosition {
        let row = linearIndex / 40
        let col = linearIndex % 40
        return GridPosition(row: row, col: col)
    }
}
