import Foundation
import Security

@MainActor
final class AppStateManager: ObservableObject {
    private let api: GitHubAPI

    @Published var state: AppState
    
    init(api: GitHubAPI = GitHubAPIImpl()) {
        self.api = api
        state = .loading
        retrieveTokenFromKeychain()
    }

    private func retrieveTokenFromKeychain() {
        do {
            if let token = try KeychainService.shared.retrieveToken() {
                Task {
                    let isValid = try await api.validateToken(token)

                    if isValid {
                        // Token is valid, transition to home state
                        print("Token is valid: \(token)")
                        state = .home
                    } else {
                        // Token is invalid, delete it and transition to login state
                        try KeychainService.shared.deleteToken()
                        print("Token is invalid. Deleting token.")
                        state = .login
                    }
                }
            } else {
                // No token found, remain in login state
                print("No token found.")
                state = .login
            }
        } catch {
            // Handle any Keychain errors
            print("Keychain error: \(error)")
            state = .login
        }
    }
}
