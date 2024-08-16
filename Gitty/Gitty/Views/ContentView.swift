import SwiftUI

struct ContentView: View {
    let api: GitHubAPI
    @EnvironmentObject private var appRouter: AppRouter

    var body: some View {
        NavigationView {
            switch appRouter.currentDestination {
            case .home:
                RepositorySearchView(api: api)
            case .repositoryDetail(let repository):
                RepositoryDetailView(repository: repository)
            case .none:
                LoginView()
            }
        }
    }
}
