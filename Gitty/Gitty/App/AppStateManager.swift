import Foundation
import Security

@MainActor
final class AppStateManager: ObservableObject {
    @Published var state: AppState
    @Injected private var tokenValidator: TokenValidator

    init() {
        state = .loading
        retrieveTokenFromKeychain()
    }

    func logout() {
        try? KeychainService.shared.deleteToken()
        state = .login
    }

    private func retrieveTokenFromKeychain() {
        do {
            guard let token = try KeychainService.shared.retrieveToken() else {
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
