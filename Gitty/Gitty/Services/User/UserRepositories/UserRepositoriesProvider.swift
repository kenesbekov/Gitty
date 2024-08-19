import Foundation

protocol UserRepositoriesProvider: AnyObject, Sendable {
    func get(for user: UserProfile) async throws -> [Repository]
}
