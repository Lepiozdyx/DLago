import SwiftUI

struct DefeatOverlayView: View {
    
    // MARK: - Properties
    
    let onMenu: () -> Void
    let onRetry: () -> Void
    
    // MARK: - State
    
    @State private var animateScale = false
    @State private var animateIcon = false
    
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
                Image(.robot5)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                
                Spacer()
            }
            
            FrameView(title: .titleGameover, height: 250, frameName: .frame5)
            
            // Content
            VStack(spacing: 15) {
                retryButton
                menuButton
            }
            .scaleEffect(animateScale ? 1.0 : 0.8)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.8)))
        .onAppear {
            withAnimation(.bouncy(duration: 0.6)) {
                animateScale = true
            }
            
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                animateIcon = true
            }
        }
    }
    
    // MARK: - Components
    
    private var retryButton: some View {
        Button(action: onRetry) {
            HStack {
                Image(.frame1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .overlay {
                        Image(systemName: "arrow.circlepath")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundStyle(.white.opacity(0.45))
                    }
                    .offset(x: 30)
                    .zIndex(1)
                
                Image(.frame2)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .overlay {
                        Text("Try again")
                            .cyberFont(20)
                    }
            }
        }
        .playTap()
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
        .playTap()
    }
}

#Preview {
    ZStack {
        // Mock game background
        LinearGradient(
            colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        DefeatOverlayView(
            onMenu: { print("Menu") },
            onRetry: { print("Retry") }
        )
    }
}
