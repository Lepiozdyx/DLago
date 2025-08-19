import SwiftUI

struct HelperView: View {
    
    // MARK: - Properties
    
    @StateObject private var helperManager = AppStateManager.shared.helperManager
    
    // MARK: - Body
    
    var body: some View {
        // Only show the helper when there's both a message and texture
        if let message = helperManager.currentMessage,
           let textureID = helperManager.currentTextureID {
            
            VStack(alignment: .leading, spacing: -40) {
                // Helper Image
                helperImage(textureID: textureID)
                
                // Message Bubble
                messageBubble(message: message)
            }
            .onTapGesture {
                helperManager.skip()
            }
            .transition(.asymmetric(
                insertion: .move(edge: .leading).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            ))
        }
    }
    
    // MARK: - Components
    
    private func helperImage(textureID: String) -> some View {
        Image(textureID)
            .resizable()
            .scaledToFit()
            .frame(height: 180)
    }
    
    private func messageBubble(message: String) -> some View {
        VStack(spacing: 6) {
            Text(message)
                .cyberFont(12)
            
            // Skip hint
            HStack {
                Spacer()
                Text("Tap to skip")
                    .font(.system(size: 10))
                    .foregroundColor(.green2)
            }
        }
        .padding()
        .background(
            Image(.frame3)
                .resizable()
        )
        .frame(maxWidth: 250)
    }
}

#Preview {
    HStack {
        HelperView()
        Spacer()
    }
    .onAppear {
        AppStateManager.shared.helperManager.showMessage(for: .levelStart)
    }
}
