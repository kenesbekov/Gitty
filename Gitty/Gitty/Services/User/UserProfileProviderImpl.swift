import Foundation

final class UserProfileProviderImpl: UserProfileProvider {
    @Injected private var tokenValidator: TokenValidator
    @Injected private var networkClient: NetworkClient

    func getMe() async throws {
        let token = try await retrieveAndValidateToken()

        let endpoint = "/user"
        let headers = ["Authorization": "token \(token)"]
        let _: UserProfile = try await networkClient.request(endpoint, headers: headers)
    }

    func get(for user: User) async throws -> UserProfile {
        let endpoint = "/users/\(user.login)"
        return try await networkClient.request(endpoint)
    }

    private func retrieveAndValidateToken() async throws -> String {
        guard let token = try KeychainService.shared.retrieveToken() else {
            throw URLError(.userAuthenticationRequired)
        }

        let isValid = try await tokenValidator.validate(token)
        if !isValid {
            try KeychainService.shared.deleteToken()
            throw URLError(.userAuthenticationRequired)
        }

        return token
    }
}
