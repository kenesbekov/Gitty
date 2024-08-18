import SwiftUI

struct ContentView: View {
    let api: GitHubAPI
    let repositoryHistory: RepositoryHistory
    let userHistory: UserHistory

    @EnvironmentObject private var appStateManager: AppStateManager

    var body: some View {
        NavigationView {
            switch appStateManager.state {
            case .home:
                TabBarView(api: api, repositoryHistory: repositoryHistory, userHistory: userHistory)
                    .environmentObject(appStateManager)
            case .login:
                LoginView()
            case .loading:
                LoadingView()
            }
        }
    }
}
