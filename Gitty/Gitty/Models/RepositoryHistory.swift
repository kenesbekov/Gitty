import Foundation

protocol RepositoryHistory {
    func addRepository(_ repository: GitHubRepository)
    func loadHistory() -> [GitHubRepository]
}
