import SwiftUI

struct FrameView: View {
    let title: ImageResource
    let height: CGFloat
    var frameName: ImageResource = .frame3
    
    var body: some View {
        VStack(spacing: -20) {
            Image(.frame7)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 45)
                .overlay {
                    Image(title)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 25)
                        .offset(y: -5)
                }
                .zIndex(1)
            
            Image(frameName)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: height)
        }
    }
}

#Preview {
    FrameView(title: .titleLevels, height: 300)
}
