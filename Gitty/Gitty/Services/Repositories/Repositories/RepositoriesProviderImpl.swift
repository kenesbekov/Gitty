import Foundation

final class RepositoriesProviderImpl: RepositoriesProvider {
    private let networkClient: NetworkClient = DependencyContainer.shared.resolve()

    func get(
        matching query: String,
        sort: RepositorySortKind,
        page: Int,
        perPage: Int
    ) async throws -> [Repository] {
        let sortValue: String
        let orderValue: String

        switch sort {
        case .stars:
            sortValue = "stars"
        case .forks:
            sortValue = "forks"
        case .updated:
            sortValue = "updated"
        }

        let endpoint = "/search/repositories?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&sort=\(sortValue)&order=desc&page=\(page)&per_page=\(perPage)"
        let response: GetRepositoriesResponse = try await networkClient.request(endpoint)

        return response.items
    }

    func get(
        userLogin: String,
        page: Int,
        perPage: Int
    ) async throws -> [Repository] {
        let endpoint = "/users/\(userLogin)/repos?page=\(page)&per_page=\(perPage)"
        let response: GetRepositoriesResponse = try await networkClient.request(endpoint)
        return response.items
    }
}
