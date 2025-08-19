import SwiftUI

struct PauseOverlayView: View {
    
    // MARK: - Properties
    
    let onResume: () -> Void
    let onRetry: () -> Void
    let onMenu: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.black, .black.opacity(0.8), .purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            FrameView(title: .titleLevels, height: 300, frameName: .frame5)
            
            // Content
            VStack(spacing: 15) {
                resumeButton
                retryButton
                menuButton
            }
        }
        .transition(.opacity.combined(with: .scale(scale: 0.8)))
        .animation(.easeInOut(duration: 0.3), value: true)
    }
    
    // MARK: - Components
    
    private var resumeButton: some View {
        Button(action: onResume) {
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
                        Text("Resume")
                            .cyberFont(20)
                    }
            }
        }
        .playTap()
    }
    
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
                        Text("Retry")
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
    PauseOverlayView(
        onResume: { print("Resume") },
        onRetry: { print("Retry") },
        onMenu: { print("Menu") }
    )
}
