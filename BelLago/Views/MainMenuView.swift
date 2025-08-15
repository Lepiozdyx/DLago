//
//  MainMenuView.swift
//  BelLago
//
//  Created by Alex on 15.08.2025.
//


import SwiftUI

struct MainMenuView: View {
    
    // MARK: - Properties
    
    @StateObject private var appState = AppStateManager.shared
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Top Bar with Coins
                topBar
                
                Spacer()
                
                // Game Title
                gameTitle
                
                Spacer()
                
                // Play Button
                playButton
                
                Spacer()
            }
            .background(
                LinearGradient(
                    colors: [.blue.opacity(0.1), .purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
        }
    }
    
    // MARK: - Components
    
    private var topBar: some View {
        HStack {
            Spacer()
            
            // Coins Display
            HStack(spacing: 8) {
                Image(systemName: "bitcoinsign.circle.fill")
                    .foregroundColor(.yellow)
                    .font(.title2)
                
                Text("\(appState.coins)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
    }
    
    private var gameTitle: some View {
        VStack(spacing: 16) {
            Text("Find the")
                .font(.largeTitle)
                .fontWeight(.light)
                .foregroundColor(.primary)
            
            Text("Hidden Word")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text("Discover secret words in the grid")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var playButton: some View {
        NavigationLink(destination: LevelSelectionView()) {
            HStack(spacing: 12) {
                Image(systemName: "play.fill")
                    .font(.title2)
                
                Text("PLAY")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
        }
        .padding(.horizontal, 40)
        .padding(.bottom, 60)
    }
}

#Preview {
    MainMenuView()
}