import Foundation

protocol RepositoryHistory {
    var repositories: [GitHubRepository] { get }

    func add(_ repository: GitHubRepository)
}
