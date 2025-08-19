import SwiftUI

struct BackgroundView: View {
    
    // MARK: - Properties
    
    @StateObject private var appState = AppStateManager.shared
    
    // MARK: - Body
    
    var body: some View {
        Image(appState.getCurrentBackgroundImageName())
            .resizable()
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 0.5), value: appState.getCurrentBackgroundImageName())
    }
}

#Preview {
    BackgroundView()
}
