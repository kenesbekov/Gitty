import Foundation
import Security

final class AppStateManager: ObservableObject {
    @Published var state: AppState
    
    init() {
        state = .loading
        retrieveTokenFromKeychain()
    }
    
    private func retrieveTokenFromKeychain() {
        do {
            if let token = try KeychainService.shared.retrieveToken() {
                // Token found, transition to home state
                print("Token found: \(token)")
                state = .home
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
