import Foundation

protocol UsersProvider: AnyObject, Sendable {
    func get(matching query: String, page: Int, limit: Int) async throws -> [User]
}
