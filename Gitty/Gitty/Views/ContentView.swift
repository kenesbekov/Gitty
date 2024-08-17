import SwiftUI

struct ContentView: View {
    let api: GitHubAPI
    let repositoryHistory: RepositoryHistory
    let userHistory: UserHistory

    @EnvironmentObject private var appRouter: AppRouter

    var body: some View {
        NavigationView {
            switch appRouter.currentDestination {
            case .home:
                HomeView(api: api, history: repositoryHistory)
            case .repositoryDetail(let repository):
                RepositoryDetailView(repository: repository)
            case .userRepositories(let userProfile):
                UserRepositoriesView(api: api, user: userProfile)
            case .userHistory:
                UserHistoryView(userHistory: userHistory)
            case .none:
                LoginView()
            }
        }
    }
}
