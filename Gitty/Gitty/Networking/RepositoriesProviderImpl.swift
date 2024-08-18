import Foundation

final class RepositoriesProviderImpl: RepositoriesProvider {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClientImpl()) {
        self.networkClient = networkClient
    }

    func get(
        matching query: String,
        sort: SortOption,
        order: OrderOption,
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
        let response: GetRepositoriesResponse = try await networkClient.fetch(
            endpoint,
            method: "GET",
            body: nil,
            headers: nil,
            isOAuthRequest: false
        )

        return response.items
    }

    func get(
        userLogin: String,
        page: Int,
        perPage: Int
    ) async throws -> [Repository] {
        let endpoint = "/users/\(userLogin)/repos?page=\(page)&per_page=\(perPage)"
        let response: GetRepositoriesResponse = try await networkClient.fetch(
            endpoint,
            method: "GET",
            body: nil,
            headers: nil,
            isOAuthRequest: false
        )

        return response.items
    }
}
