import Foundation

final class RepositoriesProviderImpl: RepositoriesProvider {
    private let networkClient: NetworkClient = DependencyContainer.shared.resolve()

    func get(
        matching query: String,
        sort: RepositorySortKind,
        page: Int,
        limit: Int
    ) async throws -> [Repository] {
        let endpoint = makeSearchRepositoriesEndpoint(query: query, sort: sort, page: page, limit: limit)
        let response: GetRepositoriesResponse = try await networkClient.request(endpoint)
        return response.items
    }

    func get(userLogin: String, page: Int, limit: Int) async throws -> [Repository] {
        let endpoint = makeUserRepositoriesEndpoint(userLogin: userLogin, page: page, limit: limit)
        let response: GetRepositoriesResponse = try await networkClient.request(endpoint)
        return response.items
    }

    private func makeSearchRepositoriesEndpoint(
        query: String,
        sort: RepositorySortKind,
        page: Int,
        limit: Int
    ) -> String {
        let sortValue: String = switch sort {
        case .stars:
            "stars"
        case .forks:
            "forks"
        case .updated:
            "updated"
        }

        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return "/search/repositories?q=\(encodedQuery)&sort=\(sortValue)&order=desc&page=\(page)&per_page=\(limit)"
    }

    private func makeUserRepositoriesEndpoint(userLogin: String, page: Int, limit: Int) -> String {
        "/users/\(userLogin)/repos?page=\(page)&per_page=\(limit)"
    }
}
