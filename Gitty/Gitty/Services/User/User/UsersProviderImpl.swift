import Foundation

final class UsersProviderImpl: UsersProvider {
    private let networkClient: NetworkClient = DependencyContainer.shared.resolve()

    func get(matching query: String, page: Int, limit: Int) async throws -> [User] {
        let endpoint = "/search/users?q=\(query)&page=\(page)&per_page=\(limit)"
        let response: GetUsersResponse = try await networkClient.request(endpoint)
        return response.items
    }
}
