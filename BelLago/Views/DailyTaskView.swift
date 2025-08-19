import SwiftUI

struct DailyTaskView: View {
    
    // MARK: - Properties
    
    @StateObject private var appState = AppStateManager.shared
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    
    @State private var showDailyBonusAnimation = false
    @State private var showClaimAnimation = false
    @State private var claimedTaskName = ""
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            topBar
            
            // Main Content
            dailyTasksContent
            
            // Daily bonus animation overlay
            if showDailyBonusAnimation {
                dailyBonusAnimationOverlay
            }
            
            // Claim animation overlay
            if showClaimAnimation {
                claimAnimationOverlay
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            handleDailyBonus()
            appState.dailyTaskManager.checkAllTasks()
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
    
    private var dailyTasksContent: some View {
        ZStack {
            FrameView(title: .titleTasks, height: 280) // Using same frame as other screens
                .overlay {
                    // Daily Tasks ScrollView
                    dailyTasksScrollView
                        .padding(.top, 30)
                        .padding(.horizontal)
                }
        }
    }
    
    private var dailyTasksScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(appState.dailyTaskManager.dailyTasks, id: \.id) { dailyTask in
                    DailyTaskCardView(
                        dailyTask: dailyTask,
                        onClaim: {
                            claimTask(dailyTask.type)
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var dailyBonusAnimationOverlay: some View {
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
                            .rotationEffect(.degrees(showDailyBonusAnimation ? 360 : 0))
                            .scaleEffect(showDailyBonusAnimation ? 1.2 : 0.8)
                            .animation(
                                .easeInOut(duration: 0.6)
                                .delay(Double(index) * 0.1)
                                .repeatCount(2, autoreverses: true),
                                value: showDailyBonusAnimation
                            )
                    }
                }
                
                VStack(spacing: 10) {
                    Text("DAILY BONUS!")
                        .cyberFont(24)
                    
                    Text("+10 COINS")
                        .cyberFont(18)
                        .foregroundColor(.green2)
                }
                .scaleEffect(showDailyBonusAnimation ? 1.1 : 0.9)
                .animation(.easeInOut(duration: 0.5), value: showDailyBonusAnimation)
            }
        }
        .transition(.opacity)
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
                
                VStack(spacing: 10) {
                    Text("TASK COMPLETED!")
                        .cyberFont(20)
                    
                    Text(claimedTaskName)
                        .cyberFont(16)
                        .foregroundColor(.green2)
                }
                .scaleEffect(showClaimAnimation ? 1.1 : 0.9)
                .animation(.easeInOut(duration: 0.5), value: showClaimAnimation)
            }
        }
        .transition(.opacity)
    }
    
    // MARK: - Methods
    
    private func handleDailyBonus() {
        // Check if player can receive daily bonus
        if appState.dailyTaskManager.canReceiveDailyBonus {
            let bonusAmount = appState.dailyTaskManager.claimDailyBonus()
            if bonusAmount > 0 {
                appState.addCoins(bonusAmount)
                
                // Play success sound
                appState.soundManager.playSuccess()
                
                // Show daily bonus animation
                withAnimation(.easeInOut(duration: 0.3)) {
                    showDailyBonusAnimation = true
                }
                
                // Hide animation after delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        showDailyBonusAnimation = false
                    }
                }
            }
        }
    }
    
    private func claimTask(_ taskType: DailyTaskType) {
        // Check if task can be claimed
        guard let dailyTask = appState.dailyTaskManager.dailyTasks.first(where: { $0.type == taskType }),
              dailyTask.canClaim else { return }
        
        // Play success sound
        appState.soundManager.playSuccess()
        
        // Show claim animation
        claimedTaskName = dailyTask.title
        withAnimation(.easeInOut(duration: 0.3)) {
            showClaimAnimation = true
        }
        
        // Claim the task and get coins
        appState.claimDailyTask(taskType)
        
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
        DailyTaskView()
    }
    .onAppear {
        // Setup preview data
        let manager = AppStateManager.shared.dailyTaskManager
        
        // Complete some tasks for preview
        var tasks = manager.dailyTasks
        if tasks.count > 0 {
            tasks[0].isCompleted = true
            tasks[0].isClaimed = false
        }
        if tasks.count > 1 {
            tasks[1].isCompleted = true
            tasks[1].isClaimed = true
        }
        if tasks.count > 2 {
            tasks[2].isCompleted = false
        }
        
        manager.dailyTasks = tasks
    }
}
