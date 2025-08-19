import SwiftUI

extension Text {
    func cyberFont(_ size: CGFloat) -> some View {
        self
            .font(.system(size: size, weight: .bold, design: .monospaced))
            .foregroundStyle(.green1)
            .shadow(color: .green2, radius: 1, x: 0.5, y: 0.5)
            .multilineTextAlignment(.center)
            .textCase(.uppercase)
    }
}

extension View {
    
    // MARK: - Sound Effects
    
    /// Adds tap sound effect to any view when tapped
    func playTap() -> some View {
        self.simultaneousGesture(
            TapGesture().onEnded {
                AppStateManager.shared.soundManager.playTap()
            }
        )
    }
    
    /// Adds success sound effect to any view when tapped
    func playSuccess() -> some View {
        self.simultaneousGesture(
            TapGesture().onEnded {
                AppStateManager.shared.soundManager.playSuccess()
            }
        )
    }
    
    /// Adds fail sound effect to any view when tapped
    func playFail() -> some View {
        self.simultaneousGesture(
            TapGesture().onEnded {
                AppStateManager.shared.soundManager.playFail()
            }
        )
    }
}
