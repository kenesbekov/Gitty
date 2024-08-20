import SwiftUI

final class OAuthHandlerImpl: @preconcurrency OAuthHandler {
    @MainActor
    func handleOAuthCallback(url: URL, appStateManager: AppStateManagerImpl) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems,
              let code = queryItems.first(where: { $0.name == "code" })?.value else {
            print("Invalid callback URL or missing code.")
            return
        }

        @Injected var accessTokenProvider: AccessTokenProvider
        @Injected var userProfileProvider: UserProfileProvider

        appStateManager.state = .loading
        Task {
            do {
                try await accessTokenProvider.get(for: code)
                try await userProfileProvider.getMe()
                
                appStateManager.state = .home
            } catch {
                appStateManager.state = .login
                print("Error during OAuth callback: \(error.localizedDescription)")
            }
        }
    }
}
