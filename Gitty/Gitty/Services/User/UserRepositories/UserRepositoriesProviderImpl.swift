import Foundation

final class UserRepositoriesProviderImpl: UserRepositoriesProvider {
    private let networkClient: NetworkClient = DependencyContainer.shared.resolve()

    func get(for user: UserProfile) async throws -> [Repository] {
        let endpoint = "/users/\(user.login)/repos"
        return try await networkClient.request(endpoint)
    }
}
