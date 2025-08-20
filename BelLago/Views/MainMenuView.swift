import SwiftUI

struct MainMenuView: View {
    
    // MARK: - Properties
    
    @StateObject private var appState = AppStateManager.shared
    @Environment(\.scenePhase) private var scenePhase
    
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
                    
                    VStack(spacing: 10) {
                        settingsButton
                        dailyTaskButton
                        achievementsButton
                        shopButton
                    }
                    .padding(.trailing)
                }
 
                VStack {
                    ScoreboardView(coins: appState.coins)
                    Spacer()
                    logo
                    Spacer()
                    Spacer()
                    playButton
                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            if appState.soundManager.isMusicEnabled {
                appState.soundManager.playMusic()
            }
            OrientationManager.shared.lockLandscape()
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .active:
                if appState.soundManager.isMusicEnabled {
                    appState.soundManager.playMusic()
                }
                OrientationManager.shared.lockLandscape()
            case .background, .inactive:
                appState.soundManager.stopMusic()
            @unknown default:
                break
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
        .playTap()
    }
    
    private var settingsButton: some View {
        NavigationLink(destination: SettingsView()) {
            HStack {
                Image(.frame1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70)
                    .overlay {
                        Image(.iconGear)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                    }
            }
        }
        .playTap()
    }
    
    private var dailyTaskButton: some View {
        NavigationLink(destination: DailyTaskView()) {
            HStack {
                Image(.frame1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70)
                    .overlay {
                        Image(.iconCubes)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                    }
            }
        }
        .playTap()
    }
    
    private var achievementsButton: some View {
        NavigationLink(destination: AchievementsView()) {
            HStack {
                Image(.frame1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70)
                    .overlay {
                        Image(.iconTrophy)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                    }
            }
        }
        .playTap()
    }
    
    private var shopButton: some View {
        NavigationLink(destination: ShopView()) {
            HStack {
                Image(.frame1)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70)
                    .overlay {
                        Image(.iconCart)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30)
                    }
            }
        }
        .playTap()
    }
    
}

#Preview {
    MainMenuView()
}
