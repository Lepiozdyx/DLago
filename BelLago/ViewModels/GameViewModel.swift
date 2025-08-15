import Foundation

class GameViewModel: ObservableObject, Identifiable {
    
    // MARK: - Properties
    
    let id = UUID()
    let levelConfig: LevelConfig
    
    // MARK: - Published Properties
    
    @Published var grid: [GridCell] = []
    @Published var attemptsRemaining: Int = 10
    @Published var selectedSequence: [GridPosition] = []
    @Published var isSubmitEnabled: Bool = false
    @Published var gameState: GameState = .idle
    
    // MARK: - Private Properties
    
    private(set) var password: String = ""
    private var distractors: [String] = []
    private var placements: [String: [GridPosition]] = [:]
    private let trashCharacters: [String] = ["!","@","#","$","%","^","&","*","(",")","_","+","[","]","{","}","|",";","'","\"",",",".","/","<",">","?"]
    private let maxPlacementAttempts = 100
    
    // MARK: - Constants
    
    private let gridRows = 20
    private let gridCols = 40
    private var totalCells: Int { gridRows * gridCols }
    
    // MARK: - Initialization
    
    init(levelConfig: LevelConfig) {
        self.levelConfig = levelConfig
        setupGrid()
    }
    
    // MARK: - Public Methods
    
    func startLevel() {
        Task {
            await generateGameField()
            await MainActor.run {
                gameState = .playing
                showHelperMessage(for: .levelStart)
            }
        }
    }
    
    func resetLevel() {
        attemptsRemaining = 10
        selectedSequence.removeAll()
        isSubmitEnabled = false
        gameState = .idle
        password = ""
        distractors.removeAll()
        placements.removeAll()
        setupGrid()
        startLevel()
    }
    
    func selectCell(at position: GridPosition) {
        guard gameState.canInteractWithGrid else { return }
        guard position.isValid else { return }
        
        let index = position.linearIndex
        guard index < grid.count else { return }
        guard !grid[index].isDisabled else { return }
        
        if grid[index].isSelected {
            // Remove from sequence and deselect
            selectedSequence.removeAll { $0 == position }
            grid[index].isSelected = false
        } else {
            // Add to sequence and select
            selectedSequence.append(position)
            grid[index].isSelected = true
        }
        
        updateSubmitButtonState()
    }
    
    func submitSelection() {
        guard gameState == .playing else { return }
        guard selectedSequence.count == password.count else { return }
        
        gameState = .evaluating
        
        let result = evaluateSelection(selectedSequence)
        
        if result.isCorrect {
            handleVictory()
        } else {
            markCorrectPositions(result.correctPositions)
            lockIncorrectCells(result.incorrectPositions)
            attemptsRemaining -= 1
            
            if attemptsRemaining <= 0 {
                handleDefeat()
            } else {
                gameState = .playing
                showHelperMessage(for: .submitFail)
            }
        }
        
        clearSelection()
    }
    
    func evaluateSelection(_ selected: [GridPosition]) -> (isCorrect: Bool, correctPositions: [GridPosition], incorrectPositions: [GridPosition]) {
        let selectedString = selected.compactMap { position in
            let index = position.linearIndex
            guard index < grid.count else { return nil }
            return grid[index].char
        }.joined()
        
        let isCorrect = selectedString == password
        
        guard let passwordPositions = placements[password] else {
            return (isCorrect: false, correctPositions: [], incorrectPositions: selected)
        }
        
        let correctPositions = selected.filter { passwordPositions.contains($0) }
        let incorrectPositions = selected.filter { !passwordPositions.contains($0) }
        
        return (isCorrect: isCorrect, correctPositions: correctPositions, incorrectPositions: incorrectPositions)
    }
    
    func handleVictory() {
        gameState = .won
        showHelperMessage(for: .victory)
        AppStateManager.shared.completeLevel(levelConfig.id)
    }
    
    func handleDefeat() {
        gameState = .lost
        showHelperMessage(for: .defeat)
    }
    
    // MARK: - Private Methods
    
    private func setupGrid() {
        grid = (0..<totalCells).map { index in
            let position = GridPosition.from(linearIndex: index)
            return GridCell(row: position.row, col: position.col, char: "")
        }
    }
    
    private func generateGameField() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.placeWordsOnGrid()
                await self.fillTrashCharacters()
            }
        }
    }
    
    private func placeWordsOnGrid() async {
        let result = await Task.detached {
            let shuffledPool = self.levelConfig.wordPool.shuffled()
            let password = shuffledPool.first ?? ""
            let distractors = Array(shuffledPool.dropFirst())
            
            let allWords = [password] + distractors
            var placedWords: [String: [GridPosition]] = [:]
            var occupiedPositions: Set<GridPosition> = []
            
            for word in allWords {
                if let positions = self.findValidPlacement(for: word, avoiding: occupiedPositions) {
                    placedWords[word] = positions
                    occupiedPositions.formUnion(positions)
                }
            }
            
            return (password: password, distractors: distractors, placements: placedWords)
        }.value
        
        await MainActor.run {
            self.password = result.password
            self.distractors = result.distractors
            self.placements = result.placements
            self.updateGridWithPlacements()
        }
    }
    
    private func findValidPlacement(for word: String, avoiding occupied: Set<GridPosition>) -> [GridPosition]? {
        let characters = Array(word).map(String.init)
        
        for _ in 0..<maxPlacementAttempts {
            // Try horizontal placement
            if let horizontalPositions = tryHorizontalPlacement(characters: characters, avoiding: occupied) {
                return horizontalPositions
            }
            
            // Try vertical placement
            if let verticalPositions = tryVerticalPlacement(characters: characters, avoiding: occupied) {
                return verticalPositions
            }
        }
        
        return nil
    }
    
    private func tryHorizontalPlacement(characters: [String], avoiding occupied: Set<GridPosition>) -> [GridPosition]? {
        let row = Int.random(in: 0..<gridRows)
        let maxStartCol = gridCols - characters.count
        guard maxStartCol >= 0 else { return nil }
        
        let startCol = Int.random(in: 0...maxStartCol)
        
        let positions = (0..<characters.count).map { index in
            GridPosition(row: row, col: startCol + index)
        }
        
        // Check if any position is occupied
        if positions.contains(where: { occupied.contains($0) }) {
            return nil
        }
        
        return positions
    }
    
    private func tryVerticalPlacement(characters: [String], avoiding occupied: Set<GridPosition>) -> [GridPosition]? {
        let col = Int.random(in: 0..<gridCols)
        let maxStartRow = gridRows - characters.count
        guard maxStartRow >= 0 else { return nil }
        
        let startRow = Int.random(in: 0...maxStartRow)
        
        let positions = (0..<characters.count).map { index in
            GridPosition(row: startRow + index, col: col)
        }
        
        // Check if any position is occupied
        if positions.contains(where: { occupied.contains($0) }) {
            return nil
        }
        
        return positions
    }
    
    private func updateGridWithPlacements() {
        for (word, positions) in placements {
            let characters = Array(word).map(String.init)
            for (index, position) in positions.enumerated() {
                let gridIndex = position.linearIndex
                if gridIndex < grid.count {
                    grid[gridIndex] = GridCell(
                        row: position.row,
                        col: position.col,
                        char: characters[index],
                        isPartOfAnyWord: true
                    )
                }
            }
        }
    }
    
    private func fillTrashCharacters() async {
        await MainActor.run {
            for index in 0..<grid.count {
                if grid[index].char == "" {
                    let randomChar = trashCharacters.randomElement() ?? "?"
                    let position = GridPosition.from(linearIndex: index)
                    grid[index] = GridCell(
                        row: position.row,
                        col: position.col,
                        char: randomChar,
                        isPartOfAnyWord: false
                    )
                }
            }
        }
    }
    
    private func markCorrectPositions(_ positions: [GridPosition]) {
        for position in positions {
            let index = position.linearIndex
            if index < grid.count {
                grid[index].isCorrect = true
                grid[index].isSelected = false
            }
        }
    }
    
    private func lockIncorrectCells(_ positions: [GridPosition]) {
        for position in positions {
            let index = position.linearIndex
            if index < grid.count {
                grid[index].isCorrect = false
                grid[index].isDisabled = true
                grid[index].isSelected = false
            }
        }
    }
    
    private func clearSelection() {
        selectedSequence.removeAll()
        for index in 0..<grid.count {
            if grid[index].isSelected && grid[index].isCorrect != true {
                grid[index].isSelected = false
            }
        }
        updateSubmitButtonState()
    }
    
    private func updateSubmitButtonState() {
        isSubmitEnabled = selectedSequence.count == password.count && gameState == .playing
    }
    
    private func showHelperMessage(for trigger: HelperTrigger) {
        AppStateManager.shared.helperManager.showMessage(for: trigger)
    }
}
