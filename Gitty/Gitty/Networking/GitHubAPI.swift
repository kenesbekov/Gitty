import Foundation

protocol GitHubAPI: AnyObject {
    func validateToken(_ token: String) async throws -> Bool
    func fetchGitHubUserProfile() async throws -> GitHubUserProfile
    func fetchAccessToken(authorizationCode: String) async throws -> String

    func searchUsers(query: String, page: Int, perPage: Int) async throws -> GitHubUserSearchResponse
    func fetchUserProfile(for user: GitHubUser) async throws -> GitHubUserProfile
    func fetchUserRepositories(user: GitHubUserProfile) async throws -> [GitHubRepository]

    func searchRepositories(query: String, sort: SortOption, order: OrderOption, page: Int, perPage: Int) async throws -> [GitHubRepository]
    func searchRepositories(query: String, page: Int, perPage: Int) async throws -> [GitHubRepository]
}
