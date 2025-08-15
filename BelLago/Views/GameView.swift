//
//  GameView.swift
//  BelLago
//
//  Created by Alex on 15.08.2025.
//

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
            // Background
            backgroundGradient
            
            // Main Content
            VStack(spacing: 0) {
                // Top Bar
                topBar
                
                // Game Content
                ZStack {
                    if viewModel.gameState.showsLoadingIndicator {
                        // Loading Indicator
                        loadingView
                    } else {
                        // Grid and Submit Button
                        gameContent
                        
                        // Helper View (overlay on left side)
                        helperOverlay
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
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var topBar: some View {
        HStack {
            // Pause Button
            Button(action: {
                if viewModel.gameState.canInteractWithGrid {
                    showPauseOverlay = true
                }
            }) {
                Image(systemName: "pause.circle.fill")
                    .font(.title2)
                    .foregroundColor(viewModel.gameState.canInteractWithGrid ? .blue : .gray)
            }
            .disabled(!viewModel.gameState.canInteractWithGrid)
            
            Spacer()
            
            // Word Length Indicator
            Text("Code: \(levelConfig.wordLength) letters")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Spacer()
            
            // Attempts Counter
            HStack(spacing: 4) {
                Image(systemName: "heart.fill")
                    .font(.caption)
                    .foregroundColor(.red)
                
                Text("\(viewModel.attemptsRemaining)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial)
    }
    
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            
            Text("Generating puzzle...")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Placing words and filling grid")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .opacity(0.8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20))
        .padding(40)
    }
    
    private var gameContent: some View {
        VStack(spacing: 20) {
            // Grid View
            Spacer()
            
            GridView(
                grid: viewModel.grid,
                onCellTap: viewModel.selectCell
            )
            .disabled(!viewModel.gameState.canInteractWithGrid)
            .opacity(viewModel.gameState.isReadyToPlay ? 1.0 : 0.5)
            
            Spacer()
            
            // Submit Button
            submitButton
        }
        .padding(.horizontal, 20)
    }
    
    private var submitButton: some View {
        Button(action: viewModel.submitSelection) {
            HStack(spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3)
                
                Text("SUBMIT")
                    .font(.headline)
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        viewModel.isSubmitEnabled ?
                        LinearGradient(
                            colors: [.green, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        ) :
                        LinearGradient(
                            colors: [.gray.opacity(0.5), .gray.opacity(0.3)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .shadow(
                color: viewModel.isSubmitEnabled ? .green.opacity(0.3) : .clear,
                radius: viewModel.isSubmitEnabled ? 6 : 0,
                x: 0,
                y: viewModel.isSubmitEnabled ? 3 : 0
            )
        }
        .disabled(!viewModel.isSubmitEnabled)
        .padding(.bottom, 30)
        .animation(.easeInOut(duration: 0.2), value: viewModel.isSubmitEnabled)
    }
    
    private var helperOverlay: some View {
        VStack {
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
