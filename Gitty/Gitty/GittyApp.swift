import SwiftUI

@main
struct GittyApp: App {
    @StateObject private var appStateManager = AppStateManager()

    init() {
        DependencyContainer.shared.register(RepositoryHistoryProviderImpl(), forType: RepositoryHistoryProvider.self)
        DependencyContainer.shared.register(UserHistoryProviderImpl(), forType: UserHistoryProvider.self)

        DependencyContainer.shared.register(TokenValidatorImpl(), forType: TokenValidator.self)
        DependencyContainer.shared.register(AccessTokenProviderImpl(), forType: AccessTokenProvider.self)
        DependencyContainer.shared.register(UserProfileProviderImpl(), forType: UserProfileProvider.self)
        DependencyContainer.shared.register(UsersProviderImpl(), forType: UsersProvider.self)
        DependencyContainer.shared.register(UserRepositoriesProviderImpl(), forType: UserRepositoriesProvider.self)
        DependencyContainer.shared.register(RepositoriesProviderImpl(), forType: RepositoriesProvider.self)
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
