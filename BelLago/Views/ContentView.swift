import SwiftUI

struct ContentView: View {
    
    @StateObject private var state = AppStateViewModel()
        
    var body: some View {
        Group {
            switch state.appState {
            case .fetch:
                LoadingView()
                
            case .download:
                if let url = state.networkManager.targetURL {
                    WKWebViewManager(url: url, webManager: state.networkManager)
                    
                } else {
                    WKWebViewManager(url: NetworkManager.initialURL, webManager: state.networkManager)
                }
                
            case .loading:
                MainMenuView()
            }
        }
        .onAppear {
            state.stateCheck()
        }
    }
}

#Preview {
    ContentView()
}
