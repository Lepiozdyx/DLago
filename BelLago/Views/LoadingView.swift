import SwiftUI

struct LoadingView: View {
    
    @State private var animateLogo = false
    @State private var loading: CGFloat = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.gray.opacity(0.7), .gray.opacity(0.5), .gray.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            Image(.logotype)
                .resizable()
                .scaledToFit()
                .opacity(0.2)
                .padding()
            
            VStack {
                Spacer()
                
                Image(.logotype)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .scaleEffect(animateLogo ? 1.05 : 0.95)
                    .animation(
                        .easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                        value: animateLogo
                    )
                
                Spacer()
                
                Rectangle()
                    .foregroundStyle(.lago.opacity(0.2))
                    .frame(maxWidth: 250, maxHeight: 20)
                    .overlay {
                        Rectangle()
                            .stroke(.lago, lineWidth: 3)
                    }
                    .overlay(alignment: .leading) {
                        Rectangle()
                            .foregroundStyle(.lago)
                            .frame(width: 248 * loading, height: 18)
                            .padding(.horizontal, 1)
                    }
            }
            .padding()
        }
        .onAppear {
            withAnimation(.linear(duration: 1.5)) {
                loading = 1
            }
            animateLogo.toggle()
        }
    }
}

#Preview {
    LoadingView()
}
