import SwiftUI

struct AchievementsView: View {
    
    // MARK: - Properties
    
    @StateObject private var appState = AppStateManager.shared
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    
    @State private var showClaimAnimation = false
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            topBar
            
            // Main Content
            achievementsContent
            
            // Claim animation overlay
            if showClaimAnimation {
                claimAnimationOverlay
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            appState.achievementManager.checkAllAchievements()
        }
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
                
                Spacer()
                
                ScoreboardView(coins: appState.coins)
            }
            Spacer()
        }
        .padding()
    }
    
    private var achievementsContent: some View {
        ZStack {
            FrameView(title: .titleAchievements, height: 280)
                .overlay {
                    // Achievements ScrollView
                    achievementsScrollView
                        .padding(.top, 30)
                        .padding(.horizontal)
                }
        }
    }
    
    private var achievementsScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(appState.achievementManager.achievements, id: \.id) { achievement in
                    AchievementCardView(
                        achievement: achievement,
                        onClaim: {
                            claimAchievement(achievement.type)
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var claimAnimationOverlay: some View {
        ZStack {
            LinearGradient(
                colors: [.black, .black.opacity(0.8), .purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Coin animation
                HStack(spacing: 10) {
                    ForEach(0..<3, id: \.self) { index in
                        Image(.coin)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                            .rotationEffect(.degrees(showClaimAnimation ? 360 : 0))
                            .scaleEffect(showClaimAnimation ? 1.2 : 0.8)
                            .animation(
                                .easeInOut(duration: 0.6)
                                .delay(Double(index) * 0.1)
                                .repeatCount(2, autoreverses: true),
                                value: showClaimAnimation
                            )
                    }
                }
                
                Text("REWARD CLAIMED!")
                    .cyberFont(24)
                    .scaleEffect(showClaimAnimation ? 1.1 : 0.9)
                    .animation(.easeInOut(duration: 0.5), value: showClaimAnimation)
            }
        }
        .transition(.opacity)
    }
    
    // MARK: - Methods
    
    private func claimAchievement(_ type: AchievementType) {
        // Check if achievement can be claimed
        guard let achievement = appState.achievementManager.achievements.first(where: { $0.type == type }),
              achievement.canClaim else { return }
        
        // Play success sound
        appState.soundManager.playSuccess()
        
        // Show claim animation
        withAnimation(.easeInOut(duration: 0.3)) {
            showClaimAnimation = true
        }
        
        // Claim the achievement and get coins
        appState.claimAchievement(type)
        
        // Hide animation after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showClaimAnimation = false
            }
        }
    }
}

#Preview {
    NavigationStack {
        AchievementsView()
    }
    .onAppear {
        // Setup preview data
        let manager = AppStateManager.shared.achievementManager
        
        // Unlock some achievements for preview
        var achievements = manager.achievements
        achievements[0].isUnlocked = true
        achievements[0].isClaimed = false
        achievements[1].isUnlocked = true
        achievements[1].isClaimed = true
        achievements[2].isUnlocked = false
        
        manager.achievements = achievements
    }
}
