import SwiftUI

struct ScoreboardView: View {
    let coins: Int
    
    var body: some View {
        Image(.scoreboard)
            .resizable()
            .scaledToFit()
            .frame(width: 160)
            .overlay {
                Text("\(coins)")
                    .cyberFont(20)
                    .offset(x: 10)
            }
    }
}

#Preview {
    ScoreboardView(coins: 999)
}
