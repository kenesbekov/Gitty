import SwiftUI

@main
struct GittyApp: App {
    @StateObject private var appStateManager = AppStateManager()

    init() {
        DependencyContainer.shared.registerServices()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appStateManager)
                .onOpenURL(perform: handleOAuthCallback)
        }
    }

    private func handleOAuthCallback(url: URL) {
        @Injected var handler: OAuthHandler
        handler.handleOAuthCallback(url: url, appStateManager: appStateManager)
    }
}
