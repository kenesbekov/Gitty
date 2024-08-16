import Foundation

protocol RepositoryRepository {
    func searchRepositories(query: String) async throws -> [GitHubRepository]
}
