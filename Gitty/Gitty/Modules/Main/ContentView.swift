import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var appStateManager: AppStateManagerImpl

    var body: some View {
        NavigationView {
            switch appStateManager.state {
            case .home:
                TabBarView()
                    .environmentObject(appStateManager)
            case .login:
                LoginView()
            case .loading:
                LoadingView()
            }
        }
    }
}
