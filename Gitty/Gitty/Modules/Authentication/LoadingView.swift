import SwiftUI

struct LoadingView: View {
    let gradientColors = [Color.accentColor.opacity(0.3), Color.clear]

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
                    .progressViewStyle(.circular)
                    .scaleEffect(1.5)

                Text("Loading...")
                    .font(.headline)
            }
        }
    }
}
