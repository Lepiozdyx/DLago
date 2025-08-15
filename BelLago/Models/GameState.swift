//
//  GameState.swift
//  BelLago
//
//  Created by Alex on 15.08.2025.
//


import Foundation

enum GameState: String, Codable, CaseIterable {
    case idle = "idle"
    case playing = "playing"
    case paused = "paused"
    case won = "won"
    case lost = "lost"
    case evaluating = "evaluating"
    
    // MARK: - Computed Properties
    
    var isGameActive: Bool {
        switch self {
        case .playing, .paused:
            return true
        case .idle, .won, .lost, .evaluating:
            return false
        }
    }
    
    var canInteractWithGrid: Bool {
        self == .playing
    }
    
    var showsOverlay: Bool {
        switch self {
        case .paused, .won, .lost:
            return true
        case .idle, .playing, .evaluating:
            return false
        }
    }
}