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
    private var timeoutTask: Task<Void, Never>?
    private let maxLoadingTime: TimeInterval = 10.0
    
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func stateCheck() {
        timeoutTask?.cancel()
        
        Task { @MainActor in
            do {
                if networkManager.targetURL != nil {
                    updateState(.download)
                    return
                }
                
                let shouldShowWebView = try await networkManager.checkInitialURL()
                
                if shouldShowWebView {
                    updateState(.download)
                } else {
                    updateState(.loading)
                }
                
            } catch {
                updateState(.loading)
            }
        }
        
        startTimeoutTask()
    }
    
    private func updateState(_ newState: FetchStates) {
        timeoutTask?.cancel()
        timeoutTask = nil
        
        appState = newState
    }
    
    private func startTimeoutTask() {
        timeoutTask = Task { @MainActor in
            do {
                try await Task.sleep(nanoseconds: UInt64(maxLoadingTime * 1_000_000_000))
                
                if self.appState == .fetch {
                    self.appState = .loading
                }
            } catch {}
        }
    }
    
    deinit {
        timeoutTask?.cancel()
    }
}
