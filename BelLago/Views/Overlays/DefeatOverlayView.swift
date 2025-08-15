//
//  DefeatOverlayView.swift
//  BelLago
//
//  Created by Alex on 15.08.2025.
//


import SwiftUI

struct DefeatOverlayView: View {
    
    // MARK: - Properties
    
    let onMenu: () -> Void
    let onRetry: () -> Void
    
    // MARK: - State
    
    @State private var animateScale = false
    @State private var animateIcon = false
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.black.opacity(0.6)
                .ignoresSafeArea()
            
            // Content
            VStack(spacing: 30) {
                // Defeat icon and message
                defeatSection
                
                // Encouragement message
                encouragementSection
                
                // Buttons
                VStack(spacing: 20) {
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
            .scaleEffect(animateScale ? 1.0 : 0.8)
        }
        .transition(.opacity.combined(with: .scale(scale: 0.8)))
        .onAppear {
            withAnimation(.bouncy(duration: 0.6)) {
                animateScale = true
            }
            
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                animateIcon = true
            }
        }
    }
    
    // MARK: - Components
    
    private var defeatSection: some View {
        VStack(spacing: 16) {
            // Defeat icon
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 60))
                .foregroundColor(.red)
                .scaleEffect(animateIcon ? 1.1 : 1.0)
            
            Text("Out of Attempts")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
    }
    
    private var encouragementSection: some View {
        VStack(spacing: 8) {
            Text("Don't give up!")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            Text("Every puzzle is a learning experience.\nTry again with a fresh perspective.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
    }
    
    private var retryButton: some View {
        Button(action: onRetry) {
            HStack(spacing: 12) {
                Image(systemName: "arrow.clockwise")
                    .font(.title3)
                
                Text("TRY AGAIN")
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
            .shadow(color: .orange.opacity(0.4), radius: 10, x: 0, y: 5)
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
        
        DefeatOverlayView(
            onMenu: { print("Menu") },
            onRetry: { print("Retry") }
        )
    }
}
