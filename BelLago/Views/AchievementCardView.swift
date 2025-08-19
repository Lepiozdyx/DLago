import SwiftUI

struct AchievementCardView: View {
    
    // MARK: - Properties
    
    let achievement: Achievement
    let onClaim: () -> Void
    
    // MARK: - State
    
    @State private var animateIcon = false
    @State private var animateClaim = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // Achievement Icon
            achievementIcon
            
            // Description
            Image(.frame5)
                .resizable()
                .frame(width: 120, height: 70)
                .overlay {
                    Text(achievement.description)
                        .cyberFont(10)
                        .padding(.horizontal)
                }
            
            // Claim Button
            claimButton
        }
        .opacity(achievement.isUnlocked ? 1.0 : 0.6)
        .scaleEffect(achievement.isComplete ? 1.0 : 0.95)
        .animation(.easeInOut(duration: 0.3), value: achievement.isUnlocked)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: achievement.isComplete)
        .onAppear {
            if achievement.canClaim {
                startClaimAnimation()
            }
        }
        .onChange(of: achievement.canClaim) { canClaim in
            if canClaim {
                startClaimAnimation()
            } else {
                animateClaim = false
            }
        }
    }
    
    // MARK: - Components
    
    private var achievementIcon: some View {
        ZStack {
            Image(achievement.iconName)
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .scaleEffect(animateIcon ? 1.0 : 0.95)
                .animation(
                    achievement.isUnlocked ? 
                        .easeInOut(duration: 1.0).repeatForever(autoreverses: true) :
                        .easeInOut(duration: 0.3),
                    value: animateIcon
                )
                .onAppear {
                    if achievement.isUnlocked {
                        animateIcon = true
                    }
                }
            
            // Completion checkmark
            if achievement.isComplete {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.green1)
                    .background(Circle().fill(.green2))
                    .offset(x: 25, y: 25)
            }
        }
    }
    
    private var claimButton: some View {
        Button {
            onClaim()
            // Add haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
        } label: {
            HStack(spacing: 4) {
                Image(.coin)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 12)
                
                Text("\(achievement.coinReward)")
                    .cyberFont(14)
                
                Image(.coin)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 12)
            }
            .padding()
            .background(
                Image(.frame2)
                    .resizable()
                    .frame(width: 110, height: 30)
            )
            .scaleEffect(animateClaim ? 1.0 : 0.95)
            .animation(
                animateClaim ? 
                    .easeInOut(duration: 0.8).repeatForever(autoreverses: true) :
                    .easeInOut(duration: 0.2),
                value: animateClaim
            )
        }
        .disabled(!achievement.canClaim)
        .opacity(achievement.canClaim ? 1.0 : 0.7)
        .animation(.easeInOut(duration: 0.3), value: achievement.canClaim)
        .playTap()
    }
    
    // MARK: - Helper Methods
    
    private func startClaimAnimation() {
        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
            animateClaim = true
        }
    }
}

#Preview {
    HStack(spacing: 20) {
        AchievementCardView(
            achievement: {
                var achievement = AchievementType.perfection.achievement
                achievement.isUnlocked = false
                return achievement
            }(),
            onClaim: { print("Claimed!") }
        )
        
        AchievementCardView(
            achievement: {
                var achievement = AchievementType.codeBreaker.achievement
                achievement.isUnlocked = true
                achievement.isClaimed = false
                return achievement
            }(),
            onClaim: { print("Claimed!") }
        )
        
        AchievementCardView(
            achievement: {
                var achievement = AchievementType.firstGuess.achievement
                achievement.isUnlocked = true
                achievement.isClaimed = true
                return achievement
            }(),
            onClaim: { print("Claimed!") }
        )
    }
}
