import Foundation
import SwiftUI

struct OAuthHandler {
    static func handleOAuthCallback(url: URL, api: GitHubAPI, appStateManager: AppStateManager) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems,
              let code = queryItems.first(where: { $0.name == "code" })?.value else {
            print("Invalid callback URL or missing code.")
            return
        }

        Task {
            do {
                let accessToken = try await api.fetchAccessToken(authorizationCode: code)
                let userProfile = try await api.fetchGitHubUserProfile()

                // Handle successful OAuth login
                appStateManager.state = .home

                // Store user profile and access token as needed
                print("Access token: \(accessToken)")
                print("User profile: \(userProfile)")
            } catch {
                print("Error during OAuth callback: \(error.localizedDescription.utf8)")
            }
        }
    }
}
