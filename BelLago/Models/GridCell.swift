import Foundation

struct GridCell: Identifiable, Codable {
    let id: String
    let row: Int
    let col: Int
    let char: String
    let isPartOfAnyWord: Bool
    var isSelected: Bool
    var isDisabled: Bool
    var isCorrect: Bool?
    
    init(row: Int, col: Int, char: String, isPartOfAnyWord: Bool = false) {
        self.id = "\(row)-\(col)"
        self.row = row
        self.col = col
        self.char = char
        self.isPartOfAnyWord = isPartOfAnyWord
        self.isSelected = false
        self.isDisabled = false
        self.isCorrect = nil
    }
    
    // MARK: - Computed Properties
    
    var position: GridPosition {
        GridPosition(row: row, col: col)
    }
    
    var accessibilityLabel: String {
        "Row \(row + 1) Column \(col + 1): \(char)"
    }
}
