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
