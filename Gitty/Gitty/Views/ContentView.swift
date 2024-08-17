import SwiftUI

struct ContentView: View {
    let api: GitHubAPI
    let repositoryHistory: RepositoryHistory
    let userHistory: UserHistory

    @EnvironmentObject private var appRouter: AppRouter
    @EnvironmentObject private var appStater: AppStater

    var body: some View {
        NavigationView {
            switch appStater.state {
            case .home:
                HomeView(api: api, repositoryHistory: repositoryHistory, userHistory: userHistory)
            case .login:
                LoginView()
            case .loading:
                LoadingView()
            }
        }
    }
}
