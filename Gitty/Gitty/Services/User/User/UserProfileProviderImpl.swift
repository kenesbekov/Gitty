import Foundation

final class UserProfileProviderImpl: UserProfileProvider {
    private let networkClient: NetworkClient = DependencyContainer.shared.resolve()

    func get(for username: String) async throws -> UserProfile {
        let endpoint = "/users/\(username)"
        return try await networkClient.request(endpoint)
    }
}
