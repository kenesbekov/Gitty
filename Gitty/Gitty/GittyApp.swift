import SwiftUI

@main
struct GittyApp: App {
    private let api = GitHubAPIImpl()
    private let repositoryHistory = RepositoryHistoryImpl()
    private let userHistory = UserHistoryImpl()

    @StateObject private var appRouter = AppRouter()

    var body: some Scene {
        WindowGroup {
            ContentView(api: api, repositoryHistory: repositoryHistory, userHistory: userHistory)
                .environmentObject(appRouter)
                .onOpenURL { url in
                    OAuthHandler.handleOAuthCallback(url: url, api: api, appRouter: appRouter)
                }
        }
    }
}
