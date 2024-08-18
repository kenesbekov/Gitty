import SwiftUI

@main
struct GittyApp: App {
    @StateObject private var appStateManager = AppStateManager()

    init() {
        DependencyContainer.shared.register(GitHubAPIImpl(), forType: GitHubAPI.self)
        DependencyContainer.shared.register(RepositoryHistoryImpl(), forType: RepositoryHistory.self)
        DependencyContainer.shared.register(UserHistoryImpl(), forType: UserHistory.self)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appStateManager)
                .onOpenURL { url in
                    OAuthHandler.handleOAuthCallback(url: url, appStateManager: appStateManager)
                }
        }
    }
}
