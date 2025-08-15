//
//  LevelSelectionView.swift
//  BelLago
//
//  Created by Alex on 15.08.2025.
//


import SwiftUI

struct LevelSelectionView: View {
    
    // MARK: - Properties
    
    @StateObject private var appState = AppStateManager.shared
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Level Configurations
    
    private let levelConfigs: [LevelConfig] = [
        LevelConfig(
            id: 1,
            wordLength: 2,
            poolSize: 8,
            wordPool: ["AB", "CD", "EF", "GH", "IJ", "KL", "MN", "OP"],
            displayName: "Level 1"
        ),
        LevelConfig(
            id: 2,
            wordLength: 3,
            poolSize: 10,
            wordPool: ["CAT", "DOG", "SUN", "BAT", "HAT", "RUN", "FUN", "CUP", "TOP", "BIG"],
            displayName: "Level 2"
        ),
        LevelConfig(
            id: 3,
            wordLength: 4,
            poolSize: 12,
            wordPool: ["WORD", "GAME", "PLAY", "FIND", "LOOK", "TEAM", "FAST", "GOOD", "BEST", "COOL", "NICE", "WORK"],
            displayName: "Level 3"
        ),
        LevelConfig(
            id: 4,
            wordLength: 5,
            poolSize: 14,
            wordPool: ["HAPPY", "WORLD", "QUICK", "SMART", "LIGHT", "BEACH", "MUSIC", "DANCE", "POWER", "MAGIC", "SPACE", "DREAM", "PEACE", "HEART"],
            displayName: "Level 4"
        ),
        LevelConfig(
            id: 5,
            wordLength: 6,
            poolSize: 18,
            wordPool: ["WISDOM", "FRIEND", "NATURE", "WONDER", "BEAUTY", "GALAXY", "FUTURE", "PLANET", "ENERGY", "DRAGON", "KNIGHT", "CASTLE", "MASTER", "LEGEND", "SPIRIT", "BRIDGE", "CHANCE", "JOURNEY"],
            displayName: "Level 5"
        )
    ]
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 30) {
            // Title
            titleSection
            
            Spacer()
            
            // Level Buttons
            levelButtonsSection
            
            Spacer()
        }
        .navigationTitle("Level Selection")
        .navigationBarTitleDisplayMode(.large)
        .background(
            LinearGradient(
                colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
    
    // MARK: - Components
    
    private var titleSection: some View {
        VStack(spacing: 8) {
            Text("Choose Your Challenge")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Each level increases word length")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.top, 20)
    }
    
    private var levelButtonsSection: some View {
        LazyVGrid(columns: gridColumns, spacing: 20) {
            ForEach(levelConfigs) { config in
                levelButton(for: config)
            }
        }
        .padding(.horizontal, 30)
    }
    
    private var gridColumns: [GridItem] {
        [
            GridItem(.flexible(), spacing: 20),
            GridItem(.flexible(), spacing: 20)
        ]
    }
    
    private func levelButton(for config: LevelConfig) -> some View {
        let isUnlocked = appState.isLevelUnlocked(config.id)
        
        return Group {
            if isUnlocked {
                NavigationLink(destination: GameView(levelConfig: config)) {
                    levelButtonContent(for: config, isUnlocked: true)
                }
            } else {
                Button(action: {}) {
                    levelButtonContent(for: config, isUnlocked: false)
                }
                .disabled(true)
            }
        }
    }
    
    private func levelButtonContent(for config: LevelConfig, isUnlocked: Bool) -> some View {
        VStack(spacing: 12) {
            // Lock/Level Icon
            Group {
                if isUnlocked {
                    Text("\(config.id)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.largeTitle)
                }
            }
            .foregroundColor(isUnlocked ? .white : .gray)
            
            // Level Info
            VStack(spacing: 4) {
                Text(config.displayName)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("\(config.wordLength) letters")
                    .font(.caption)
                    .opacity(0.8)
            }
            .foregroundColor(isUnlocked ? .white : .gray)
        }
        .frame(width: 120, height: 120)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    isUnlocked ?
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ) :
                    LinearGradient(
                        colors: [.gray.opacity(0.3), .gray.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .shadow(
            color: isUnlocked ? .blue.opacity(0.3) : .clear,
            radius: isUnlocked ? 8 : 0,
            x: 0,
            y: isUnlocked ? 4 : 0
        )
        .scaleEffect(isUnlocked ? 1.0 : 0.95)
    }
}

#Preview {
    NavigationStack {
        LevelSelectionView()
    }
}