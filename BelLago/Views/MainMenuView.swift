import SwiftUI

struct MainMenuView: View {
    
    // MARK: - Properties
    
    @StateObject private var appState = AppStateManager.shared
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
 
                VStack {
                    ScoreboardView(coins: appState.coins)
                    Spacer()
                    logo
                    Spacer()
                    playButton
                    Spacer()
                }
                .padding()
            }
        }
    }
    
    // MARK: - Components
    
    private var logo: some View {
        Image(.iconLogo)
            .resizable()
            .scaledToFit()
            .frame(width: 120)
            .overlay(alignment: .bottom) {
                Image(.titleName)
                    .resizable()
                    .scaledToFit()
            }
    }

    private var playButton: some View {
        NavigationLink(destination: LevelSelectionView()) {
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
                        Text("Play")
                            .cyberFont(20)
                    }
            }
        }
    }
}

#Preview {
    MainMenuView()
}
