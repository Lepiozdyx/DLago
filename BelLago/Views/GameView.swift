import SwiftUI

struct GameView: View {
    
    // MARK: - Properties
    
    let levelConfig: LevelConfig
    @StateObject private var appState = AppStateManager.shared
    @StateObject private var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    
    @State private var showPauseOverlay = false
    
    // MARK: - Initialization
    
    init(levelConfig: LevelConfig) {
        self.levelConfig = levelConfig
        self._viewModel = StateObject(wrappedValue: GameViewModel(levelConfig: levelConfig))
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            // Game Content
            ZStack {
                if viewModel.gameState.showsLoadingIndicator {
                    // Loading Indicator
                    loadingView
                } else {
                    // Top Bar
                    topBar
                    
                    // Grid and Submit Button
                    gameContent
                    
                    // Helper View
                    helperOverlay
                    
                    // Submit Button
                    if viewModel.isSubmitEnabled {
                        submitButton
                    }
                }
            }
            
            // Overlays
            if showPauseOverlay {
                PauseOverlayView(
                    onResume: { showPauseOverlay = false },
                    onRetry: {
                        showPauseOverlay = false
                        viewModel.resetLevel()
                    },
                    onMenu: {
                        showPauseOverlay = false
                        dismiss()
                    }
                )
            }
            
            if viewModel.gameState == .won {
                VictoryOverlayView(
                    levelConfig: levelConfig,
                    onMenu: { dismiss() },
                    onNextLevel: {
                        if levelConfig.id < 5 {
                            // Navigate to next level
                            dismiss()
                        } else {
                            dismiss()
                        }
                    }
                )
            }
            
            if viewModel.gameState == .lost {
                DefeatOverlayView(
                    onMenu: { dismiss() },
                    onRetry: { viewModel.resetLevel() }
                )
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            // Start level when view appears
            if viewModel.gameState == .idle {
                viewModel.startLevel()
            }
            
            // Show initial helper message if needed
            if appState.helperManager.currentMessage == nil {
                appState.helperManager.showMessage(for: .levelStart)
            }
        }
    }
    
    // MARK: - Components
    
    private var topBar: some View {
        VStack {
            HStack(alignment: .top) {
                // Pause Button
                Button {
                    if viewModel.gameState.canInteractWithGrid {
                        showPauseOverlay = true
                    }
                } label: {
                    Image(.back)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                }
                .disabled(!viewModel.gameState.canInteractWithGrid)
                
                Spacer()
                
                // Word Length Indicator
                Text("Code length: \(Array(repeating: "*", count: levelConfig.wordLength).joined(separator: " "))")
                    .cyberFont(14)
                
                Spacer()
                
                // Attempts Counter
                HStack(spacing: 4) {
                    Text("tries: ")
                        .cyberFont(14)
                    
                    Text("\(viewModel.attemptsRemaining)")
                        .cyberFont(14)
                }
            }
            Spacer()
        }
        .padding()
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(CircularProgressViewStyle(tint: .green1))
            
            Text("Loading...")
                .cyberFont(22)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image(.frame3)
                .resizable()
                .scaledToFit()
        )
        .padding(80)
    }
    
    private var gameContent: some View {
        GridView(
            grid: viewModel.grid,
            onCellTap: viewModel.selectCell
        )
        .disabled(!viewModel.gameState.canInteractWithGrid)
        .opacity(viewModel.gameState.isReadyToPlay ? 1.0 : 0.5)
        .padding(.top, 40)
    }
    
    private var submitButton: some View {
        VStack{
            Spacer()
            
            Button(action: viewModel.submitSelection) {
                Image(.frame2)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                    .overlay {
                        Text("Submit")
                            .cyberFont(20)
                    }
            }
            .disabled(!viewModel.isSubmitEnabled)
            .padding(.bottom)
            .animation(.easeInOut(duration: 0.3), value: viewModel.isSubmitEnabled)
        }
    }
    
    private var helperOverlay: some View {
        HStack {
            if appState.helperManager.isVisible {
                HelperView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .leading).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            }
            
            Spacer()
        }
        .animation(.easeInOut(duration: 0.4), value: appState.helperManager.isVisible)
    }
}

#Preview {
    let config = LevelConfig(
        id: 1,
        wordLength: 2,
        poolSize: 8,
        wordPool: ["AB", "CD", "EF", "GH", "IJ", "KL", "MN", "OP"]
    )
    
    return GameView(levelConfig: config)
}
