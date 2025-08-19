import SwiftUI

struct MainMenuView: View {
    
    // MARK: - Properties
    
    @StateObject private var appState = AppStateManager.shared
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ZStack {
                BackgroundView()
                
                HStack {
                    Image(.robot2)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250)
                    
                    Spacer()
                    
                    VStack(spacing: 15) {
                        settingsButton
                        dailyTaskButton
                        achievementsButton
                        shopButton
                    }
                    .padding()
                }
 
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
    
    private var achievementsButton: some View {
        NavigationLink(destination: AchievementsView()) {
            HStack {
                Image(.frame1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .overlay {
                        Image(.iconTrophy)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                    }
            }
        }
    }
    
    private var settingsButton: some View {
        NavigationLink(destination: AchievementsView()) {
            HStack {
                Image(.frame1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .overlay {
                        Image(.iconGear)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                    }
            }
        }
    }
    
    private var shopButton: some View {
        NavigationLink(destination: AchievementsView()) {
            HStack {
                Image(.frame1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .overlay {
                        Image(.iconCart)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                    }
            }
        }
    }
    
    private var dailyTaskButton: some View {
        NavigationLink(destination: AchievementsView()) {
            HStack {
                Image(.frame1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .overlay {
                        Image(.iconCubes)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                    }
            }
        }
    }
}

#Preview {
    MainMenuView()
}
