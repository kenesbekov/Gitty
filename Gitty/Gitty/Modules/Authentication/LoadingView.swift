import SwiftUI

struct LoadingView: View {
    let gradientColors = [Color.accent.opacity(0.3), Color.clear]

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)

                Text("Loading...")
                    .font(.headline)
            }
        }
    }
}
