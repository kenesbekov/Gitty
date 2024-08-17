import SwiftUI

struct ContentView: View {
    let api: GitHubAPI
    let history: RepositoryHistory

    var body: some View {
        NavigationView {
            switch appRouter.currentDestination {
            case .home:
                RepositorySearchView(api: api, history: history)
            case .repositoryDetail(let repository):
                RepositoryDetailView(repository: repository)
            case .none:
                LoginView()
            }
        }
    }
}
