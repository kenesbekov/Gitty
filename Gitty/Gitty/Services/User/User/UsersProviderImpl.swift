import Foundation

final class UsersProviderImpl: UsersProvider {
    private let networkClient: NetworkClient = DependencyContainer.shared.resolve()

    func get(matching query: String, page: Int, perPage: Int) async throws -> [User] {
        let endpoint = "/search/users?q=\(query)&page=\(page)&per_page=\(perPage)"
        let response: GetUsersResponse = try await networkClient.request(endpoint)
        return response.items
    }
}
