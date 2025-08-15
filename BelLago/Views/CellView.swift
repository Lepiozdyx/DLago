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
    
    private var cornerRadius: CGFloat {
        max(1, cellSize * 0.1)
    }
    
    private var strokeWidth: CGFloat {
        max(0.3, cellSize * 0.05)
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: onTap) {
            Text(cell.char)
                .font(.system(size: fontSize, weight: .medium, design: .monospaced))
                .foregroundColor(textColor)
                .frame(width: cellSize, height: cellSize)
                .background(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(borderColor, lineWidth: strokeWidth)
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
            return .red.opacity(0.7)
        } else if let isCorrect = cell.isCorrect {
            return isCorrect ? .green.opacity(0.8) : .red.opacity(0.7)
        } else if cell.isSelected {
            return .blue.opacity(0.8)
        } else {
            return .gray.opacity(0.2)
        }
    }
    
    private var textColor: Color {
        if cell.isDisabled {
            return .white
        } else if cell.isCorrect == true {
            return .white
        } else if cell.isCorrect == false {
            return .white
        } else if cell.isSelected {
            return .white
        } else {
            return .primary
        }
    }
    
    private var borderColor: Color {
        if cell.isSelected {
            return .blue
        } else if let isCorrect = cell.isCorrect {
            return isCorrect ? .green : .red
        } else {
            return .gray.opacity(0.4)
        }
    }
}

// MARK: - Convenience Initializer

extension CellView {
    init(cell: GridCell, onTap: @escaping () -> Void) {
        self.cell = cell
        self.cellSize = 8 // Default fallback size
        self.onTap = onTap
    }
}

#Preview {
    VStack(spacing: 10) {
        // Different cell sizes
        HStack(spacing: 10) {
            Text("Small (6pt)")
                .font(.caption2)
            HStack(spacing: 5) {
                CellView(
                    cell: GridCell(row: 0, col: 0, char: "A"),
                    cellSize: 6,
                    onTap: {}
                )
                
                CellView(
                    cell: {
                        var cell = GridCell(row: 0, col: 1, char: "B")
                        cell.isSelected = true
                        return cell
                    }(),
                    cellSize: 6,
                    onTap: {}
                )
            }
        }
        
        HStack(spacing: 10) {
            Text("Medium (10pt)")
                .font(.caption2)
            HStack(spacing: 5) {
                CellView(
                    cell: {
                        var cell = GridCell(row: 0, col: 2, char: "C")
                        cell.isCorrect = true
                        return cell
                    }(),
                    cellSize: 10,
                    onTap: {}
                )
                
                CellView(
                    cell: {
                        var cell = GridCell(row: 0, col: 3, char: "D")
                        cell.isCorrect = false
                        return cell
                    }(),
                    cellSize: 10,
                    onTap: {}
                )
            }
        }
        
        HStack(spacing: 10) {
            Text("Large (14pt)")
                .font(.caption2)
            HStack(spacing: 5) {
                CellView(
                    cell: {
                        var cell = GridCell(row: 0, col: 4, char: "E")
                        cell.isDisabled = true
                        return cell
                    }(),
                    cellSize: 14,
                    onTap: {}
                )
                
                CellView(
                    cell: GridCell(row: 0, col: 5, char: "F"),
                    cellSize: 14,
                    onTap: {}
                )
            }
        }
        
        Text("Responsive cell sizes with different states")
            .font(.caption)
            .foregroundColor(.secondary)
    }
    .padding()
    .background(.gray.opacity(0.1))
}
