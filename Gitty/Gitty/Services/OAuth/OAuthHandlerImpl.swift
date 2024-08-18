import Foundation
import SwiftUI

final class OAuthHandlerImpl: @preconcurrency OAuthHandler {
    @MainActor
    func handleOAuthCallback(url: URL, appStateManager: AppStateManager) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems,
              let code = queryItems.first(where: { $0.name == "code" })?.value else {
            print("Invalid callback URL or missing code.")
            return
        }

        // Resolve dependencies
        let accessTokenProvider: AccessTokenProvider = DependencyContainer.shared.resolve()
        let userProfileProvider: UserProfileProvider = DependencyContainer.shared.resolve()

        appStateManager.state = .loading
        Task {
            do {
                let accessToken = try await accessTokenProvider.get(for: code)
                let userProfile = try await userProfileProvider.getMe()
                
                // Handle successful OAuth login
                appStateManager.state = .home
                
                // Store user profile and access token as needed
                print("Access token: \(accessToken)")
                print("User profile: \(userProfile)")
            } catch {
                appStateManager.state = .login
                print("Error during OAuth callback: \(error.localizedDescription)")
            }
        }
    }
}
