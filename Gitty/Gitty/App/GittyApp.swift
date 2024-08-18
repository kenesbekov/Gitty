import SwiftUI

@main
struct GittyApp: App {
    @StateObject private var appStateManager = AppStateManager()

    init() {
        DependencyContainer.shared.registerAuthenticationServices()
        DependencyContainer.shared.registerRepositoryServices()
        DependencyContainer.shared.registerHistoryServices()
        DependencyContainer.shared.registerUserServices()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appStateManager)
                .onOpenURL { url in
                    let handler: OAuthHandler = DependencyContainer.shared.resolve()
                    handler.handleOAuthCallback(url: url, appStateManager: appStateManager)
                }
        }
    }
}
