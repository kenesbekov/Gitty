import Foundation

final class TokenValidatorImpl: TokenValidator {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClientImpl()) {
        self.networkClient = networkClient
    }

    func validate(_ token: String) async throws -> Bool {
        let endpoint = "/user"
        let headers = ["Authorization": "token \(token)"]

        do {
            let _: UserProfile = try await networkClient.fetch(
                endpoint,
                method: "GET",
                body: nil,
                headers: headers,
                isOAuthRequest: false
            )
            return true
        } catch {
            return false
        }
    }
}
