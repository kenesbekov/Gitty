import Foundation

final class UserProfileProviderImpl: UserProfileProvider {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClientImpl()) {
        self.networkClient = networkClient
    }

    func getMe() async throws -> UserProfile {
        let accessToken = try KeychainService.shared.retrieveToken()
        guard let token = accessToken else {
            throw URLError(.userAuthenticationRequired)
        }

        let isValid = try await TokenValidatorImpl(networkClient: networkClient).validate(token)
        if !isValid {
            try KeychainService.shared.deleteToken()
            throw URLError(.userAuthenticationRequired)
        }

        let endpoint = "/user"
        let headers = ["Authorization": "token \(token)"]
        return try await networkClient.fetch(endpoint, method: "GET", body: nil, headers: headers, isOAuthRequest: false)
    }

    func get(for user: User) async throws -> UserProfile {
        let endpoint = "/users/\(user.login)"
        return try await networkClient.fetch(endpoint, method: "GET", body: nil, headers: nil, isOAuthRequest: false)
    }
}
