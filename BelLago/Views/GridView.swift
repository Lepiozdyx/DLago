import SwiftUI

struct GridView: View {
    
    // MARK: - Properties
    
    let grid: [GridCell]
    let onCellTap: (GridPosition) -> Void
    
    // MARK: - Constants
    
    private let gridColumns = Array(repeating: GridItem(.fixed(8), spacing: 1), count: 40)
    private let gridRows = 20
    private let totalCells = 800
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView([.horizontal, .vertical], showsIndicators: false) {
                LazyVGrid(columns: gridColumns, spacing: 1) {
                    ForEach(0..<min(grid.count, totalCells), id: \.self) { index in
                        CellView(
                            cell: grid[index],
                            onTap: {
                                onCellTap(grid[index].position)
                            }
                        )
                    }
                }
                .padding(8)
            }
            .frame(
                width: min(geometry.size.width, CGFloat(40 * 8 + 39 + 16)), // 40 cells * 8 width + 39 spacing + padding
                height: min(geometry.size.height, CGFloat(20 * 8 + 19 + 16)) // 20 rows * 8 height + 19 spacing + padding
            )
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            .clipped()
        }
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
    .background(.gray.opacity(0.1))
}
