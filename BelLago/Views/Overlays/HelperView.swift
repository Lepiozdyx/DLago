import SwiftUI

struct HelperView: View {
    
    // MARK: - Properties
    
    @StateObject private var helperManager = AppStateManager.shared.helperManager
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: -40) {
            // Helper Image
            helperImage
            
            // Message Bubble
            if let message = helperManager.currentMessage {
                messageBubble(message: message)
            }
        }
        .onTapGesture {
            helperManager.skip()
        }
    }
    
    // MARK: - Components
    
    private var helperImage: some View {
        Group {
            if let textureID = helperManager.currentTextureID {
                Image(textureID)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(.robot2)
                    .resizable()
                    .scaledToFit()
            }
        }
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
