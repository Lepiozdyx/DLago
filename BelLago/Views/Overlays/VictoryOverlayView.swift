//
//  VictoryOverlayView.swift
//  BelLago
//
//  Created by Alex on 15.08.2025.
//


import SwiftUI

struct VictoryOverlayView: View {
    
    // MARK: - Properties
    
    let levelConfig: LevelConfig
    let onMenu: () -> Void
    let onNextLevel: () -> Void
    
    // MARK: - State
    
    @State private var animateConfetti = false
    @State private var animateScale = false
    
    // MARK: - Computed Properties
    
    private var hasNextLevel: Bool {
        levelConfig.id < 5
    }
    
    private var congratulationMessage: String {
        if levelConfig.id == 5 {
            return "🎉 All Levels Complete! 🎉"
        } else {
            return "🎉 Level \(levelConfig.id) Complete! 🎉"
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            // Confetti effect
            confettiOverlay
            
            // Content
            VStack(spacing: 30) {
                // Congratulations
                congratulationsSection
                
                // Reward info
                rewardSection
                
                // Buttons
                VStack(spacing: 20) {
                    if hasNextLevel {
                        nextLevelButton
                    }
                    menuButton
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            )
            .scaleEffect(animateScale ? 1.0 : 0.8)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.8)))
        .onAppear {
            withAnimation(.bouncy(duration: 0.6)) {
                animateScale = true
            }
            
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                animateConfetti = true
            }
        }
    }
    
    // MARK: - Components
    
    private var congratulationsSection: some View {
        VStack(spacing: 16) {
            Text(congratulationMessage)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text("You found the hidden word!")
                .font(.headline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var rewardSection: some View {
        HStack(spacing: 12) {
            Image(systemName: "bitcoinsign.circle.fill")
                .font(.title2)
                .foregroundColor(.yellow)
            
            Text("+100 coins")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.yellow.opacity(0.1))
//                .stroke(.yellow.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var nextLevelButton: some View {
        Button(action: onNextLevel) {
            HStack(spacing: 12) {
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title3)
                
                Text("NEXT LEVEL")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                LinearGradient(
                    colors: [.green, .blue],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .shadow(color: .green.opacity(0.4), radius: 10, x: 0, y: 5)
        }
    }
    
    private var menuButton: some View {
        Button(action: onMenu) {
            HStack(spacing: 12) {
                Image(systemName: "house.fill")
                    .font(.title3)
                
                Text("MENU")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.primary)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(.ultraThinMaterial)
//                    .stroke(.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
    
    private var confettiOverlay: some View {
        ZStack {
            ForEach(0..<20, id: \.self) { index in
                confettiPiece(index: index)
            }
        }
    }
    
    private func confettiPiece(index: Int) -> some View {
        let colors: [Color] = [.red, .blue, .green, .yellow, .purple, .orange, .pink]
        let randomColor = colors[index % colors.count]
        let randomSize = CGFloat.random(in: 4...8)
        let randomX = CGFloat.random(in: -100...100)
        let randomDelay = Double.random(in: 0...1)
        
        return Circle()
            .fill(randomColor)
            .frame(width: randomSize, height: randomSize)
            .offset(
                x: randomX,
                y: animateConfetti ? 800 : -100
            )
            .animation(
                .linear(duration: 3.0)
                .delay(randomDelay)
                .repeatForever(autoreverses: false),
                value: animateConfetti
            )
    }
}

#Preview {
    let config = LevelConfig(
        id: 3,
        wordLength: 4,
        poolSize: 12,
        wordPool: ["WORD", "GAME", "PLAY", "FIND"]
    )
    
    return ZStack {
        // Mock game background
        LinearGradient(
            colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        VictoryOverlayView(
            levelConfig: config,
            onMenu: { print("Menu") },
            onNextLevel: { print("Next Level") }
        )
    }
}
