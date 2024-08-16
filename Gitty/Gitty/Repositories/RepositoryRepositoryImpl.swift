import Foundation

final class RepositoryRepositoryImpl: RepositoryRepository {
    private let api: any GitHubAPI

    init(api: any GitHubAPI) {
        self.api = api
    }

    func searchRepositories(query: String) async throws -> [GitHubRepository] {
        try await api.searchRepositories(query: query, page: 1, perPage: 30)
    }
}
