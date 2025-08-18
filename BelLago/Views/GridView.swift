import SwiftUI

struct GridView: View {
    
    // MARK: - Properties
    
    let grid: [GridCell]
    let onCellTap: (GridPosition) -> Void
    
    // MARK: - Constants
    
    private let gridRows = 20
    private let gridCols = 40
    private let totalCells = 800
    private let minCellSize: CGFloat = 14
    private let maxCellSize: CGFloat = 24
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            let availableSize = calculateAvailableSize(geometry: geometry)
            let cellSize = calculateOptimalCellSize(availableSize: availableSize)
            let spacing = max(0.5, cellSize * 0.1)
            let gridColumns = Array(repeating: GridItem(.fixed(cellSize), spacing: spacing), count: gridCols)
            
            VStack {
                LazyVGrid(columns: gridColumns, spacing: spacing) {
                    ForEach(0..<min(grid.count, totalCells), id: \.self) { index in
                        CellView(
                            cell: grid[index],
                            cellSize: cellSize,
                            onTap: {
                                onCellTap(grid[index].position)
                            }
                        )
                    }
                }
                .frame(
                    width: calculateGridWidth(cellSize: cellSize, spacing: spacing),
                    height: calculateGridHeight(cellSize: cellSize, spacing: spacing)
                )
                .padding(6)
                .background(
                    RoundedRectangle(cornerRadius: 2)
                        .fill(LinearGradient(colors: [.gray, .black, .black, .black], startPoint: .topLeading, endPoint: .bottomTrailing))
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    // MARK: - Helper Methods
    
    private func calculateAvailableSize(geometry: GeometryProxy) -> CGSize {
        let padding: CGFloat = 40 // Total horizontal and vertical padding
        let availableWidth = geometry.size.width - padding
        let availableHeight = geometry.size.height - padding
        
        return CGSize(width: max(0, availableWidth), height: max(0, availableHeight))
    }
    
    private func calculateOptimalCellSize(availableSize: CGSize) -> CGFloat {
        // Calculate cell size based on available space
        let cellSizeByWidth = availableSize.width / CGFloat(gridCols + gridCols - 1) // Include spacing
        let cellSizeByHeight = availableSize.height / CGFloat(gridRows + gridRows - 1) // Include spacing
        
        // Use the smaller dimension to ensure grid fits
        let optimalSize = min(cellSizeByWidth, cellSizeByHeight)
        
        // Clamp to min and max bounds
        return max(minCellSize, min(maxCellSize, optimalSize))
    }
    
    private func calculateGridWidth(cellSize: CGFloat, spacing: CGFloat) -> CGFloat {
        return CGFloat(gridCols) * cellSize + CGFloat(gridCols - 1) * spacing
    }
    
    private func calculateGridHeight(cellSize: CGFloat, spacing: CGFloat) -> CGFloat {
        return CGFloat(gridRows) * cellSize + CGFloat(gridRows - 1) * spacing
    }
}

#Preview {
    let sampleGrid = (0..<800).map { index in
        let position = GridPosition.from(linearIndex: index)
        let chars = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J"]
        return GridCell(
            row: position.row,
            col: position.col,
            char: chars.randomElement() ?? "A"
        )
    }
    
    return GridView(
        grid: sampleGrid,
        onCellTap: { _ in }
    )
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(BackgroundView())
}
