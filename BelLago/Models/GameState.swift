//
//  GameState.swift
//  BelLago
//
//  Created by Alex on 15.08.2025.
//

import Foundation

enum GameState: String, Codable, CaseIterable {
    case idle = "idle"
    case loading = "loading"
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
        case .idle, .loading, .won, .lost, .evaluating:
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
        case .idle, .loading, .playing, .evaluating:
            return false
        }
    }
    
    var showsLoadingIndicator: Bool {
        self == .loading
    }
    
    var isReadyToPlay: Bool {
        switch self {
        case .playing, .paused:
            return true
        case .idle, .loading, .won, .lost, .evaluating:
            return false
        }
    }
}
