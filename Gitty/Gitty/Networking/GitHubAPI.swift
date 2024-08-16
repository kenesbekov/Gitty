import Foundation

protocol GitHubAPI: AnyObject {
    func searchRepositories(query: String, page: Int, perPage: Int) async throws -> [GitHubRepository]
    func fetchAccessToken(authorizationCode: String) async throws -> String
    func fetchGitHubUserProfile(accessToken: String) async throws -> GitHubUserProfile
}
