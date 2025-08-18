import SwiftUI

struct CellView: View {
    
    // MARK: - Properties
    
    let cell: GridCell
    let cellSize: CGFloat
    let onTap: () -> Void
    
    // MARK: - Computed Properties
    
    private var fontSize: CGFloat {
        max(4, cellSize * 0.6)
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: onTap) {
            Text(cell.char)
                .font(.system(size: fontSize, weight: .bold, design: .monospaced))
                .foregroundColor(.green1)
                .frame(width: cellSize, height: cellSize)
                .background(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 1)
                        .stroke(.green2, lineWidth: 2)
                )
        }
        .disabled(cell.isDisabled)
        .animation(.easeInOut(duration: 0.15), value: cell.isSelected)
        .animation(.easeInOut(duration: 0.2), value: cell.isCorrect)
        .animation(.easeInOut(duration: 0.2), value: cell.isDisabled)
    }
    
    // MARK: - Color Computed Properties
    
    private var backgroundColor: Color {
        if cell.isDisabled {
            return .red.opacity(0.8)
        } else if let isCorrect = cell.isCorrect {
            return isCorrect ? .green.opacity(0.8) : .red.opacity(0.8)
        } else if cell.isSelected {
            return .blue.opacity(0.8)
        } else {
            return .gray.opacity(0.2)
        }
    }
}

// MARK: - Convenience Initializer

extension CellView {
    init(cell: GridCell, onTap: @escaping () -> Void) {
        self.cell = cell
        self.cellSize = 8
        self.onTap = onTap
    }
}

#Preview {
    HStack(spacing: 5) {
        CellView(
            cell: {
                var cell = GridCell(row: 0, col: 4, char: "E")
                cell.isDisabled = true
                return cell
            }(),
            cellSize: 20,
            onTap: {}
        )
        
        CellView(
            cell: GridCell(row: 0, col: 5, char: "F"),
            cellSize: 20,
            onTap: {}
        )
    }
}
