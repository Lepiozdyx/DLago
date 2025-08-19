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
        ZStack {
            BackgroundView()
            
            topBar
            
            // Level Buttons
            levelButtonsSection
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Components
    
    private var topBar: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(.back)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                }
                .playTap()

                Spacer()
            }
            Spacer()
        }
        .padding()
    }
    
    private var levelButtonsSection: some View {
        ZStack {
            FrameView(title: .titleLevels, height: 280)
            
            HStack(spacing: 10) {
                ForEach(levelConfigs) { config in
                    levelButton(for: config)
                }
            }
        }
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
        Group {
            if isUnlocked {
                Text("\(config.id)")
                    .cyberFont(40)
            } else {
                Image(.iconLock)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 40)
            }
        }
        .foregroundColor(isUnlocked ? .white : .gray)
        .frame(width: 100, height: 120)
        .background(
            Image(.frame6)
                .resizable()
                .scaledToFit()
        )
        .scaleEffect(isUnlocked ? 1.0 : 0.85)
        .opacity(isUnlocked ? 1.0 : 0.8)
    }
}

#Preview {
    NavigationStack {
        LevelSelectionView()
    }
}
