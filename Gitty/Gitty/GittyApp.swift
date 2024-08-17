import SwiftUI

@main
struct GittyApp: App {
    private let api = GitHubAPIImpl()
    private let repositoryHistory = RepositoryHistoryImpl()
    private let userHistory = UserHistoryImpl()

    @StateObject private var appRouter = AppRouter()
    @StateObject private var appStater = AppStater()

    var body: some Scene {
        WindowGroup {
            ContentView(api: api, repositoryHistory: repositoryHistory, userHistory: userHistory)
                .environmentObject(appRouter)
                .environmentObject(appStater)
                .onOpenURL { url in
                    OAuthHandler.handleOAuthCallback(url: url, api: api, appStater: appStater)
                }
        }
    }
}
