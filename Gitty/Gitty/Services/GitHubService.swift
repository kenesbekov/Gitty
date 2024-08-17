import Foundation

protocol GitHubService {
    func fetchUserProfile() async throws -> GitHubUserProfile
}
