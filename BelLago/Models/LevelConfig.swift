//
//  LevelConfig.swift
//  BelLago
//
//  Created by Alex on 15.08.2025.
//

import Foundation

struct LevelConfig: Codable, Identifiable {
    let id: Int
    let wordLength: Int
    let poolSize: Int
    let wordPool: [String]
    let displayName: String
    let createdAt: Date?
    
    init(id: Int, wordLength: Int, poolSize: Int, wordPool: [String], displayName: String? = nil, createdAt: Date? = nil) {
        self.id = id
        self.wordLength = wordLength
        self.poolSize = poolSize
        self.wordPool = wordPool
        self.displayName = displayName ?? "Level \(id)"
        self.createdAt = createdAt ?? Date()
    }
    
    // MARK: - Computed Properties for UI
    
    var isValid: Bool {
        !wordPool.isEmpty && 
        wordPool.allSatisfy { $0.count == wordLength } &&
        wordPool.count >= poolSize &&
        id > 0
    }
}
