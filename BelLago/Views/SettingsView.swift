import SwiftUI

struct SettingsView: View {
    
    // MARK: - Properties
    
    @ObservedObject private var appState = AppStateManager.shared
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - State
    
    @State private var animateSettings = false
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            topBar
            
            // Main Content
            settingsContent
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5).delay(0.2)) {
                animateSettings = true
            }
        }
    }
    
    // MARK: - Components
    
    private var topBar: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(.back)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                }
                .playTap()
                
                Spacer()
            }
            Spacer()
        }
        .padding()
    }
    
    private var settingsContent: some View {
        ZStack {
            FrameView(title: .titleSettings, height: 280)
                .overlay {
                    settingsButtons
                        .padding(.top, 30)
                }
        }
        .scaleEffect(animateSettings ? 1.0 : 0.8)
        .opacity(animateSettings ? 1.0 : 0.0)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: animateSettings)
    }
    
    private var settingsButtons: some View {
        VStack(spacing: 30) {
            // Sound Settings
            VStack {
                Image(.titleSounds)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 15)
                
                soundSettingButton
            }
            
            // Music Settings
            VStack {
                Image(.titleMusic)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 15)
                
                musicSettingButton
            }
        }
    }
    
    private var soundSettingButton: some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                appState.soundManager.toggleSound()
            }
        } label: {
            Image(.frame4)
                .resizable()
                .scaledToFit()
                .frame(width: 60)
                .overlay {
                    if appState.soundManager.isSoundEnabled {
                        Image(.dot)
                            .resizable()
                            .scaledToFit()
                            .padding(8)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: appState.soundManager.isSoundEnabled)
        }
    }
    
    private var musicSettingButton: some View {
        Button {
            if appState.soundManager.isSoundEnabled {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    appState.soundManager.toggleMusic()
                }
            }
        } label: {
            Image(.frame4)
                .resizable()
                .scaledToFit()
                .frame(width: 60)
                .overlay {
                    if appState.soundManager.isMusicEnabled {
                        Image(.dot)
                            .resizable()
                            .scaledToFit()
                            .padding(8)
                            .transition(.scale.combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: appState.soundManager.isMusicEnabled)
        }
        .disabled(!appState.soundManager.isSoundEnabled)
        .opacity(appState.soundManager.isSoundEnabled ? 1.0 : 0.7)
        .animation(.easeInOut(duration: 0.3), value: appState.soundManager.isSoundEnabled)
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
