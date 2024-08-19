import Foundation

protocol UserHistoryProvider: AnyObject, Sendable {
    var users: [User] { get }

    func add(_ user: User)
}
