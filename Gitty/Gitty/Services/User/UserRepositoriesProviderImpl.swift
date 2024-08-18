import Foundation

final class UserRepositoriesProviderImpl: UserRepositoriesProvider {
    @Injected private var networkClient: NetworkClient

    func get(for user: UserProfile) async throws -> [Repository] {
        let endpoint = "/users/\(user.login)/repos"
        return try await networkClient.request(endpoint)
    }
}
