//
//  HelperManager.swift
//  BelLago
//
//  Created by Alex on 15.08.2025.
//


import SwiftUI

class HelperManager: ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var currentMessage: String?
    @Published var currentTextureID: String?
    @Published var isVisible: Bool = false
    
    // MARK: - Private Properties
    
    private let textures: [String] = [
        "helper_texture_1",
        "helper_texture_2", 
        "helper_texture_3",
        "helper_texture_4",
        "helper_texture_5"
    ]
    
    private let messages: [HelperTrigger: [String]] = [
        .firstStart: [
            "Welcome to Find the Hidden Word! Tap cells to select letters and find the secret word.",
            "Your goal is to find the hidden word on this grid. Good luck!",
            "Look carefully - there's a secret word waiting to be discovered!"
        ],
        .levelStart: [
            "A new challenge awaits! Find the hidden word in this grid.",
            "Ready for the next level? The word is hiding somewhere here.",
            "Time to put your word-finding skills to the test!"
        ],
        .submitFail: [
            "Not quite right, but don't give up!",
            "Keep trying! The correct word is still out there.",
            "Almost there! Try a different combination.",
            "Don't worry, you'll find it soon!",
            "Every attempt gets you closer to the answer."
        ],
        .victory: [
            "Excellent work! You found the hidden word!",
            "Congratulations! Your word-finding skills are impressive!",
            "Amazing! You cracked the code!",
            "Well done! Ready for the next challenge?"
        ],
        .defeat: [
            "Don't worry, you can try again!",
            "Every puzzle is a learning experience. Give it another shot!",
            "Sometimes the best strategy is to take a fresh approach.",
            "Ready to tackle this challenge again?"
        ]
    ]
    
    // MARK: - Public Methods
    
    func showMessage(for trigger: HelperTrigger) {
        currentTextureID = randomTexture()
        currentMessage = randomMessage(for: trigger)
        isVisible = true
    }
    
    func skip() {
        isVisible = false
        currentMessage = nil
        currentTextureID = nil
    }
    
    func randomTexture() -> String {
        textures.randomElement() ?? "helper_texture_1"
    }
    
    func randomMessage(for trigger: HelperTrigger) -> String {
        let triggerMessages = messages[trigger] ?? []
        return triggerMessages.randomElement() ?? "Good luck!"
    }
    
    func hideHelper() {
        withAnimation(.easeOut(duration: 0.3)) {
            isVisible = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.currentMessage = nil
            self.currentTextureID = nil
        }
    }
}
