import Foundation

protocol RepositoryHistoryProvider: AnyObject, Sendable {
    var repositories: [Repository] { get }

    func add(_ repository: Repository)
    func clear()
}
