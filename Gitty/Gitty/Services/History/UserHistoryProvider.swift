import Foundation

protocol UserHistoryProvider: AnyObject {
    var users: [User] { get }

    func add(_ user: User)
    func clear()
}


