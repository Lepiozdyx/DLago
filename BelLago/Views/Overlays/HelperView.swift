//
//  HelperView.swift
//  BelLago
//
//  Created by Alex on 15.08.2025.
//


import SwiftUI

struct HelperView: View {
    
    // MARK: - Properties
    
    @StateObject private var helperManager = AppStateManager.shared.helperManager
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Helper Image
            helperImage
            
            // Message Bubble
            if let message = helperManager.currentMessage {
                messageBubble(message: message)
            }
        }
        .frame(maxWidth: 200)
        .onTapGesture {
            helperManager.skip()
        }
    }
    
    // MARK: - Components
    
    private var helperImage: some View {
        Group {
            if let textureID = helperManager.currentTextureID {
                Image(textureID)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
            }
        }
        .frame(width: 60, height: 60)
        .background(
            Circle()
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
    
    private func messageBubble(message: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(message)
                .font(.caption)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
            
            // Skip hint
            HStack {
                Spacer()
                Text("Tap to skip")
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .opacity(0.7)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
        )
        .overlay(
            // Speech bubble tail
            Path { path in
                path.move(to: CGPoint(x: 20, y: 0))
                path.addLine(to: CGPoint(x: 30, y: -8))
                path.addLine(to: CGPoint(x: 40, y: 0))
            }
            .fill(.ultraThinMaterial)
            .frame(width: 20, height: 8)
            .offset(y: -8),
            alignment: .topLeading
        )
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.1)
            .ignoresSafeArea()
        
        VStack {
            HStack {
                HelperView()
                Spacer()
            }
            Spacer()
        }
        .padding()
    }
    .onAppear {
        AppStateManager.shared.helperManager.showMessage(for: .levelStart)
    }
}