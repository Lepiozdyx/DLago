import SwiftUI

struct CellView: View {
    
    // MARK: - Properties
    
    let cell: GridCell
    let onTap: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        Button(action: onTap) {
            Text(cell.char)
                .font(.system(size: 6, weight: .medium, design: .monospaced))
                .foregroundColor(textColor)
                .frame(width: 8, height: 8)
                .background(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 1)
                        .stroke(borderColor, lineWidth: 0.5)
                )
        }
        .disabled(cell.isDisabled)
        .animation(.easeInOut(duration: 0.15), value: cell.isSelected)
        .animation(.easeInOut(duration: 0.2), value: cell.isCorrect)
        .animation(.easeInOut(duration: 0.2), value: cell.isDisabled)
    }
    
    // MARK: - Computed Properties
    
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

#Preview {
    VStack(spacing: 10) {
        HStack(spacing: 10) {
            // Normal cell
            CellView(
                cell: GridCell(row: 0, col: 0, char: "A"),
                onTap: {}
            )
            
            // Selected cell
            CellView(
                cell: {
                    var cell = GridCell(row: 0, col: 1, char: "B")
                    cell.isSelected = true
                    return cell
                }(),
                onTap: {}
            )
            
            // Correct cell
            CellView(
                cell: {
                    var cell = GridCell(row: 0, col: 2, char: "C")
                    cell.isCorrect = true
                    return cell
                }(),
                onTap: {}
            )
            
            // Incorrect cell
            CellView(
                cell: {
                    var cell = GridCell(row: 0, col: 3, char: "D")
                    cell.isCorrect = false
                    return cell
                }(),
                onTap: {}
            )
            
            // Disabled cell
            CellView(
                cell: {
                    var cell = GridCell(row: 0, col: 4, char: "E")
                    cell.isDisabled = true
                    return cell
                }(),
                onTap: {}
            )
        }
        
        Text("Normal, Selected, Correct, Incorrect, Disabled")
            .font(.caption)
            .foregroundColor(.secondary)
    }
    .padding()
    .background(.gray.opacity(0.1))
}
