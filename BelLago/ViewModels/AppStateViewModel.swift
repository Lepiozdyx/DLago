import Foundation

@MainActor
final class AppStateViewModel: ObservableObject {
    
    enum FetchStates {
        case fetch
        case download
        case loading
    }
    
    @Published private(set) var appState: FetchStates = .fetch
    
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func stateCheck() {
        Task { @MainActor in
            do {
                if networkManager.targetURL != nil {
                    appState = .download
                    return
                }
                
                let shouldShowWebView = try await networkManager.checkInitialURL()
                
                if shouldShowWebView {
                    appState = .download
                } else {
                    appState = .loading
                }
                
            } catch {
                appState = .loading
            }
        }
    }
}
