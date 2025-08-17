import SwiftUI

struct FrameView: View {
    let title: ImageResource
    let height: CGFloat
    
    var body: some View {
        VStack(spacing: -20) {
            Image(.frame7)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 45)
                .overlay {
                    Image(.titleLevels)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 25)
                        .offset(y: -5)
                }
                .zIndex(1)
            
            Image(.frame3)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: height)
        }
    }
}

#Preview {
    FrameView(title: .titleLevels, height: 300)
}
