import SwiftUI

struct DailyTaskCardView: View {
    
    // MARK: - Properties
    
    let dailyTask: DailyTask
    let onClaim: () -> Void
    
    // MARK: - State
    
    @State private var animateIcon = false
    @State private var animateClaim = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            // Task Icon
            taskIcon
            
            // Description
            Image(.frame5)
                .resizable()
                .frame(width: 120, height: 70)
                .overlay {
                    Text(dailyTask.description)
                        .cyberFont(10)
                        .padding(.horizontal)
                }
            
            // Claim Button
            claimButton
        }
        .opacity(dailyTask.isCompleted ? 1.0 : 0.6)
        .scaleEffect(dailyTask.isFinished ? 1.0 : 0.95)
        .animation(.easeInOut(duration: 0.3), value: dailyTask.isCompleted)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: dailyTask.isFinished)
        .onAppear {
            if dailyTask.canClaim {
                startClaimAnimation()
            }
        }
        .onChange(of: dailyTask.canClaim) { canClaim in
            if canClaim {
                startClaimAnimation()
            } else {
                animateClaim = false
            }
        }
    }
    
    // MARK: - Components
    
    private var taskIcon: some View {
        ZStack {
            Image(dailyTask.iconName)
                .resizable()
                .scaledToFit()
                .frame(height: 80)
                .scaleEffect(animateIcon ? 1.0 : 0.95)
                .animation(
                    dailyTask.isCompleted ? 
                        .easeInOut(duration: 1.0).repeatForever(autoreverses: true) :
                        .easeInOut(duration: 0.3),
                    value: animateIcon
                )
                .onAppear {
                    if dailyTask.isCompleted {
                        animateIcon = true
                    }
                }
            
            // Completion checkmark
            if dailyTask.isFinished {
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
                
                Text("\(dailyTask.coinReward)")
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
        .disabled(!dailyTask.canClaim)
        .opacity(dailyTask.canClaim ? 1.0 : 0.7)
        .animation(.easeInOut(duration: 0.3), value: dailyTask.canClaim)
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
        DailyTaskCardView(
            dailyTask: {
                var task = DailyTaskType.gameStarted.dailyTask
                task.isCompleted = false
                return task
            }(),
            onClaim: { print("Claimed!") }
        )
        
        DailyTaskCardView(
            dailyTask: {
                var task = DailyTaskType.shopVisited.dailyTask
                task.isCompleted = true
                task.isClaimed = false
                return task
            }(),
            onClaim: { print("Claimed!") }
        )
        
        DailyTaskCardView(
            dailyTask: {
                var task = DailyTaskType.purchaseMade.dailyTask
                task.isCompleted = true
                task.isClaimed = true
                return task
            }(),
            onClaim: { print("Claimed!") }
        )
    }
}
