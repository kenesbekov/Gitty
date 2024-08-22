import Foundation

final class AccessTokenProviderImpl: AccessTokenProvider {
    private let networkClient: NetworkClient = DependencyContainer.shared.resolve()
    private let keychainManager: KeychainManager = DependencyContainer.shared.resolve()

    func get(for authorizationCode: String) async throws {
        let endpoint = "/login/oauth/access_token"
        let bodyComponents = [
            "client_id": APIConstants.clientID,
            "client_secret": APIConstants.clientSecret,
            "code": authorizationCode,
            "redirect_uri": APIConstants.redirectURI
        ]

        guard let body = makeBody(from: bodyComponents) else {
            throw URLError(.cannotParseResponse)
        }

        let headers = ["Content-Type": "application/x-www-form-urlencoded"]

        do {
            let response: OAuthTokenResponse = try await networkClient.request(
                endpoint,
                method: .post,
                body: body,
                headers: headers,
                isOAuthRequest: true
            )
            try keychainManager.saveToken(response.accessToken)
        } catch let KeychainError.keychainError(status: status) {
            print("Failed to fetch access token: \(status)")
        }
    }

    private func makeBody(from components: [String: String]) -> Data? {
        let bodyString = components
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")

        return bodyString.data(using: .utf8)
    }
}
