import SwiftUI

struct VictoryOverlayView: View {
    
    // MARK: - Properties
    
    let levelConfig: LevelConfig
    let onMenu: () -> Void
    let onNextLevel: () -> Void
    
    // MARK: - State
    
    @State private var animateConfetti = false
    @State private var animateScale = false
    
    // MARK: - Computed Properties
    
    private var hasNextLevel: Bool {
        levelConfig.id < 5
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.black, .black.opacity(0.8), .purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            HStack {
                Image(.robot3)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                
                Spacer()
            }
            
            FrameView(title: .titleWin, height: 250, frameName: .frame5)
            
            // Confetti effect
            confettiOverlay
            
            // Content
            VStack(spacing: 25) {
                // Reward info
                rewardSection
                
                // Buttons
                VStack(spacing: 15) {
                    if hasNextLevel {
                        nextLevelButton
                    }
                    menuButton
                }
            }
            .scaleEffect(animateScale ? 1.0 : 0.8)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.8)))
        .onAppear {
            withAnimation(.bouncy(duration: 0.6)) {
                animateScale = true
            }
            
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                animateConfetti = true
            }
        }
    }
    
    // MARK: - Components
    
    private var rewardSection: some View {
        ScoreboardView(coins: 100)
    }
    
    private var nextLevelButton: some View {
        Button(action: onNextLevel) {
            HStack {
                Image(.frame1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .overlay {
                        Image(.iconPlay)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                    }
                    .offset(x: 30)
                    .zIndex(1)
                
                Image(.frame2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .overlay {
                        Text("Next level")
                            .cyberFont(20)
                    }
            }
        }
    }
    
    private var menuButton: some View {
        Button(action: onMenu) {
            HStack {
                Image(.back)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .offset(x: 30)
                    .zIndex(1)
                
                Image(.frame2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .overlay {
                        Text("Menu")
                            .cyberFont(20)
                    }
            }
        }
    }
    
    private var confettiOverlay: some View {
        ZStack {
            ForEach(0..<20, id: \.self) { index in
                confettiPiece(index: index)
            }
        }
    }
    
    private func confettiPiece(index: Int) -> some View {
        let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange, .pink]
        let randomColor = colors[index % colors.count]
        let randomSize = CGFloat.random(in: 4...8)
        let randomX = CGFloat.random(in: -100...100)
        let randomDelay = Double.random(in: 0...1)
        
        return Circle()
            .fill(randomColor)
            .frame(width: randomSize, height: randomSize)
            .offset(
                x: randomX,
                y: animateConfetti ? 800 : -100
            )
            .animation(
                .linear(duration: 3.0)
                .delay(randomDelay)
                .repeatForever(autoreverses: false),
                value: animateConfetti
            )
    }
}

#Preview {
    let config = LevelConfig(
        id: 3,
        wordLength: 4,
        poolSize: 12,
        wordPool: ["WORD", "GAME", "PLAY", "FIND"]
    )
    
    VictoryOverlayView(
        levelConfig: config,
        onMenu: { print("Menu") },
        onNextLevel: { print("Next Level") }
    )
}
