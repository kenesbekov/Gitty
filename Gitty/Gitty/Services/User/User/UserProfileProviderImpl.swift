import Foundation

final class UserProfileProviderImpl: UserProfileProvider {
    private let networkClient: NetworkClient = DependencyContainer.shared.resolve()

    func get(for user: User) async throws -> UserProfile {
        let endpoint = "/users/\(user.login)"
        return try await networkClient.request(endpoint)
    }
}
