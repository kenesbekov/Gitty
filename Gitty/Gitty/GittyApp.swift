import SwiftUI

@main
struct GittyApp: App {
    private let api = GitHubAPIImpl()
    private let repositoryHistory = RepositoryHistoryImpl()
    private let userHistory = UserHistoryImpl()

    @StateObject private var appStateManager = AppStateManager()

    init() {
        DependencyContainer.shared.register(GitHubAPIImpl(), forType: GitHubAPI.self)
        DependencyContainer.shared.register(RepositoryHistoryImpl(), forType: RepositoryHistory.self)
    }

    var body: some Scene {
        WindowGroup {
            ContentView(api: api, repositoryHistory: repositoryHistory, userHistory: userHistory)
                .environmentObject(appStateManager)
                .onOpenURL { url in
                    OAuthHandler.handleOAuthCallback(url: url, api: api, appStateManager: appStateManager)
                }
        }
    }
}
