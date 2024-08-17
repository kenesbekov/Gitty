import SwiftUI

struct LoadingView: View {
    @EnvironmentObject private var appStater: AppStater

    var body: some View {
        VStack {
            ProgressView("Loading...")
        }
    }
}
