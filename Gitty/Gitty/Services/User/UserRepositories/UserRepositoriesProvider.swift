import Foundation

protocol UserRepositoriesProvider: AnyObject {
    func get(for user: UserProfile) async throws -> [Repository]
}
