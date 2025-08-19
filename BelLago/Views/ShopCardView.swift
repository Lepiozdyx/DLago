import SwiftUI

struct ShopCardView: View {
    
    // MARK: - Properties
    
    let background: Background
    let userCoins: Int
    let onPurchase: () -> Void
    let onUse: () -> Void
    
    // MARK: - State
    
    @State private var animatePreview = false
    @State private var animateButton = false
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 6) {
            // Background Preview
            backgroundPreview
            
            // Action Button
            actionButton
        }
        .opacity(background.isPurchased ? 1.0 : 0.8)
        .animation(.easeInOut(duration: 0.3), value: background.isPurchased)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: background.isActive)
        .onAppear {
            startAnimations()
        }
        .onChange(of: background.buttonState) { newState in
            if newState == .purchase && canAffordBackground {
                startButtonAnimation()
            } else {
                animateButton = false
            }
        }
    }
    
    // MARK: - Components
    
    private var backgroundPreview: some View {
        ZStack {
            Image(background.previewImageName)
                .resizable()
                .frame(width: 120, height: 160)
                .clipped()
                .cornerRadius(8)
                .scaleEffect(animatePreview ? 1.0 : 0.95)
                .animation(
                    background.isPurchased ? 
                        .easeInOut(duration: 2.0).repeatForever(autoreverses: true) :
                        .easeInOut(duration: 0.3),
                    value: animatePreview
                )
        }
    }
    
    private var actionButton: some View {
        Button {
            handleButtonTap()
        } label: {
            buttonContent
        }
        .disabled(!background.buttonState.isEnabled || (background.buttonState == .purchase && !canAffordBackground))
        .scaleEffect(animateButton ? 1.05 : 1.0)
        .animation(
            animateButton ? 
                .easeInOut(duration: 0.8).repeatForever(autoreverses: true) :
                .easeInOut(duration: 0.2),
            value: animateButton
        )
    }
    
    private var buttonContent: some View {
        Group {
            switch background.buttonState {
            case .purchase:
                purchaseButtonContent
            case .use:
                useButtonContent
            case .used:
                useButtonContent
            }
        }
        .frame(width: 110, height: 30)
        .background(
            Image(.frame2)
                .resizable()
        )
    }
    
    private var purchaseButtonContent: some View {
        HStack(spacing: 4) {
            Image(.coin)
                .resizable()
                .scaledToFit()
                .frame(height: 12)
            
            Text("\(background.price)")
                .cyberFont(14)
            
            Image(.coin)
                .resizable()
                .scaledToFit()
                .frame(height: 12)
        }
        .opacity(canAffordBackground ? 1.0 : 0.75)
    }
    
    private var useButtonContent: some View {
        Text(background.buttonState.title)
            .cyberFont(14)
    }
    
    // MARK: - Computed Properties
    
    private var canAffordBackground: Bool {
        userCoins >= background.price
    }
    
    // MARK: - Helper Methods
    
    private func handleButtonTap() {
        switch background.buttonState {
        case .purchase:
            if canAffordBackground {
                onPurchase()
                // Add haptic feedback
                let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
                impactFeedback.impactOccurred()
            }
        case .use:
            onUse()
            // Add haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .light)
            impactFeedback.impactOccurred()
        case .used:
            break
        }
    }
    
    private func startAnimations() {
        if background.isPurchased {
            animatePreview = true
        }
        
        if background.buttonState == .purchase && canAffordBackground {
            startButtonAnimation()
        }
    }
    
    private func startButtonAnimation() {
        withAnimation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
            animateButton = true
        }
    }
}

#Preview {
    HStack(spacing: 20) {
        ShopCardView(
            background: {
                var bg = BackgroundType.bg0.background
                bg.isActive = true
                return bg
            }(),
            userCoins: 150,
            onPurchase: {},
            onUse: {}
        )
        
        ShopCardView(
            background: {
                var bg = BackgroundType.bg1.background
                bg.isPurchased = true
                return bg
            }(),
            userCoins: 150,
            onPurchase: {},
            onUse: {}
        )
        
        ShopCardView(
            background: BackgroundType.bg2.background,
            userCoins: 50,
            onPurchase: {},
            onUse: {}
        )
    }
}
