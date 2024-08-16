import Foundation

final class GitHubServiceImpl: GitHubService {
    private let api: any GitHubAPI

    init(api: any GitHubAPI) {
        self.api = api
    }

    func fetchUserProfile(accessToken: String) async throws -> GitHubUserProfile {
        try await api.fetchGitHubUserProfile(accessToken: accessToken)
    }
}
