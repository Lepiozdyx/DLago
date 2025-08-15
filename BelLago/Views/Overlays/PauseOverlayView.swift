//
//  PauseOverlayView.swift
//  BelLago
//
//  Created by Alex on 15.08.2025.
//


import SwiftUI

struct PauseOverlayView: View {
    
    // MARK: - Properties
    
    let onResume: () -> Void
    let onRetry: () -> Void
    let onMenu: () -> Void
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            // Content
            VStack(spacing: 30) {
                // Title
                Text("Game Paused")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                // Buttons
                VStack(spacing: 20) {
                    resumeButton
                    retryButton
                    menuButton
                }
            }
            .padding(40)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
            )
        }
        .transition(.opacity.combined(with: .scale(scale: 0.8)))
        .animation(.easeInOut(duration: 0.3), value: true)
    }
    
    // MARK: - Components
    
    private var resumeButton: some View {
        Button(action: onResume) {
            HStack(spacing: 12) {
                Image(systemName: "play.fill")
                    .font(.title3)
                
                Text("RESUME")
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
            .shadow(color: .green.opacity(0.3), radius: 8, x: 0, y: 4)
        }
    }
    
    private var retryButton: some View {
        Button(action: onRetry) {
            HStack(spacing: 12) {
                Image(systemName: "arrow.clockwise")
                    .font(.title3)
                
                Text("RETRY")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                LinearGradient(
                    colors: [.orange, .red],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .shadow(color: .orange.opacity(0.3), radius: 8, x: 0, y: 4)
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
}

#Preview {
    ZStack {
        // Mock game background
        LinearGradient(
            colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        
        PauseOverlayView(
            onResume: { print("Resume") },
            onRetry: { print("Retry") },
            onMenu: { print("Menu") }
        )
    }
}
