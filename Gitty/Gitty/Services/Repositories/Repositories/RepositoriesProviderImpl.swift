import Foundation

final class RepositoriesProviderImpl: RepositoriesProvider {
    @Injected private var networkClient: NetworkClient

    func get(
        matching query: String,
        sort: SortKind,
        order: OrderKind,
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

        switch order {
        case .ascending:
            orderValue = "asc"
        case .descending:
            orderValue = "desc"
        }

        let endpoint = "/search/repositories?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&sort=\(sortValue)&order=\(orderValue)&page=\(page)&per_page=\(perPage)"
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
