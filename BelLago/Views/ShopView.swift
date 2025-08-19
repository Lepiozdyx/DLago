import SwiftUI

struct ShopView: View {
    
    // MARK: - Properties
    
    @StateObject private var appState = AppStateManager.shared
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    
    @State private var showPurchaseAnimation = false
    @State private var purchasedBackgroundName = ""
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            topBar
            
            // Main Content
            shopContent
            
            // Purchase animation overlay
            if showPurchaseAnimation {
                purchaseAnimationOverlay
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // Ensure background manager is properly initialized
            appState.backgroundManager.updateBackgroundStates()
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
    
    private var shopContent: some View {
        ZStack {
            FrameView(title: .titleShop, height: 280)
                .overlay {
                    // Backgrounds ScrollView
                    backgroundsScrollView
                        .padding(.top, 30)
                        .padding(.horizontal)
                }
        }
    }
    
    private var backgroundsScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(appState.backgroundManager.backgrounds, id: \.id) { background in
                    ShopCardView(
                        background: background,
                        userCoins: appState.coins,
                        onPurchase: {
                            purchaseBackground(background.type)
                        },
                        onUse: {
                            useBackground(background.type)
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
    }
    
    private var purchaseAnimationOverlay: some View {
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
                            .rotationEffect(.degrees(showPurchaseAnimation ? 360 : 0))
                            .scaleEffect(showPurchaseAnimation ? 1.2 : 0.8)
                            .animation(
                                .easeInOut(duration: 0.6)
                                .delay(Double(index) * 0.1)
                                .repeatCount(2, autoreverses: true),
                                value: showPurchaseAnimation
                            )
                    }
                }
                
                VStack(spacing: 10) {
                    Text("BACKGROUND PURCHASED!")
                        .cyberFont(20)
                    
                    Text(purchasedBackgroundName)
                        .cyberFont(16)
                        .foregroundColor(.green2)
                }
                .scaleEffect(showPurchaseAnimation ? 1.1 : 0.9)
                .animation(.easeInOut(duration: 0.5), value: showPurchaseAnimation)
            }
        }
        .transition(.opacity)
    }
    
    // MARK: - Methods
    
    private func purchaseBackground(_ backgroundType: BackgroundType) {
        let background = appState.backgroundManager.backgrounds.first { $0.type == backgroundType }
        guard let background = background,
              appState.canAffordBackground(backgroundType) else { return }
        
        // Attempt purchase through AppStateManager (handles coins and background state)
        if appState.purchaseBackground(backgroundType) {
            // Store background name for animation
            purchasedBackgroundName = background.name
            
            // Play success sound
            appState.soundManager.playSuccess()
            
            // Show purchase animation
            withAnimation(.easeInOut(duration: 0.3)) {
                showPurchaseAnimation = true
            }
            
            // Hide animation after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showPurchaseAnimation = false
                }
            }
        }
    }
    
    private func useBackground(_ backgroundType: BackgroundType) {
        appState.setActiveBackground(backgroundType)
        
        // Play tap sound
        appState.soundManager.playTap()
    }
}

#Preview {
    NavigationStack {
        ShopView()
    }
    .onAppear {
        // Setup preview data
        let manager = AppStateManager.shared.backgroundManager
        
        // Set some backgrounds as purchased for preview
        var backgrounds = manager.backgrounds
        if backgrounds.count > 1 {
            backgrounds[1].isPurchased = true
        }
        if backgrounds.count > 2 {
            backgrounds[2].isPurchased = false
        }
        
        manager.backgrounds = backgrounds
        
        // Set coins for preview
        AppStateManager.shared.addCoins(250)
    }
}
