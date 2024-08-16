import Foundation
import SwiftUI

struct OAuthHandler {
    static func handleOAuthCallback(url: URL, api: GitHubAPI, appRouter: AppRouter) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems,
              let code = queryItems.first(where: { $0.name == "code" })?.value else {
            print("Invalid callback URL or missing code.")
            return
        }

        Task {
            do {
                let accessToken = try await api.fetchAccessToken(authorizationCode: code)
                let userProfile = try await api.fetchGitHubUserProfile(accessToken: accessToken)

                // Handle successful OAuth login
                appRouter.navigateTo(.home)  // Ensure `.home` is a valid case in `Destination`

                // Store user profile and access token as needed
                print("Access token: \(accessToken)")
                print("User profile: \(userProfile)")
            } catch {
                print("Error during OAuth callback: \(error.localizedDescription.utf8)")
            }
        }
    }
}
