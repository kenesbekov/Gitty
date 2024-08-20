import Foundation

@MainActor
protocol AppStateManager: ObservableObject {
    func logout()
}

@MainActor
final class AppStateManagerImpl: AppStateManager {
    @Published var state: AppState
    @Injected private var tokenValidator: TokenValidator
    @Injected private var keychainManager: KeychainManager

    init() {
        state = .loading
        retrieveTokenFromKeychain()
    }

    func logout() {
        try? keychainManager.deleteToken()
        state = .login
    }

    private func retrieveTokenFromKeychain() {
        do {
            guard let token = try keychainManager.retrieveToken() else {
                state = .login
                return
            }

            Task {
                let isValid = try await tokenValidator.validate(token)

                if isValid {
                    state = .home
                } else {
                    logout()
                }
            }
        } catch {
            state = .login
        }
    }
}
