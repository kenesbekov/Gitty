import Foundation

final class UsersProviderImpl: UsersProvider {
    private let networkClient: NetworkClient = DependencyContainer.shared.resolve()

    func get(matching query: String, page: Int, perPage: Int) async throws -> GetUsersResponse {
        let endpoint = "/search/users?q=\(query)&page=\(page)&per_page=\(perPage)"
        return try await networkClient.request(endpoint)
    }
}
