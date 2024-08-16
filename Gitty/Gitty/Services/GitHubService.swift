import Foundation

protocol GitHubService {
    func fetchUserProfile(accessToken: String) async throws -> GitHubUserProfile
}
