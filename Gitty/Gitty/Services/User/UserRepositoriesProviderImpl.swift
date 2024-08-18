import Foundation

final class UserRepositoriesProviderImpl: UserRepositoriesProvider {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClientImpl()) {
        self.networkClient = networkClient
    }

    func get(for user: UserProfile) async throws -> [Repository] {
        let endpoint = "/users/\(user.login)/repos"
        return try await networkClient.fetch(endpoint, method: "GET", body: nil, headers: nil, isOAuthRequest: false)
    }
}
