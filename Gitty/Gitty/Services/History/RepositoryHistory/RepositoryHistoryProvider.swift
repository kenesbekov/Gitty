import Foundation

protocol RepositoryHistoryProvider {
    var repositories: [Repository] { get }

    func add(_ repository: Repository)
    func clear()
}
