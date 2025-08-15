//
//  SavedProgress.swift
//  BelLago
//
//  Created by Alex on 15.08.2025.
//


import Foundation

struct SavedProgress: Codable {
    let unlockedLevels: [Int]
    let coins: Int
    let bestTimes: [Int: TimeInterval]
    let dateSaved: Date
    
    init(unlockedLevels: [Int] = [1], coins: Int = 0, bestTimes: [Int: TimeInterval] = [:], dateSaved: Date = Date()) {
        self.unlockedLevels = unlockedLevels
        self.coins = coins
        self.bestTimes = bestTimes
        self.dateSaved = dateSaved
    }
    
    // MARK: - Computed Properties
    
    var maxUnlockedLevel: Int {
        unlockedLevels.max() ?? 1
    }
    
    var totalLevelsCompleted: Int {
        unlockedLevels.count - 1 // Minus 1 because level 1 is unlocked by default
    }
    
    var hasCompletedAllLevels: Bool {
        unlockedLevels.contains(5)
    }
    
    // MARK: - Helper Methods
    
    func isLevelUnlocked(_ level: Int) -> Bool {
        unlockedLevels.contains(level)
    }
    
    func bestTime(for level: Int) -> TimeInterval? {
        bestTimes[level]
    }
}