import SwiftUI

@main
struct GittyApp: App {
    private let api = GitHubAPIImpl()
    @StateObject private var appRouter = AppRouter()

    var body: some Scene {
        WindowGroup {
            ContentView(api: api)
                .environmentObject(appRouter)
                .onOpenURL { url in
                    OAuthHandler.handleOAuthCallback(url: url, api: api, appRouter: appRouter)
                }
        }
    }
}
