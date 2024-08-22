import Foundation

protocol UserProfileProvider: AnyObject, Sendable {
    func get(for username: String) async throws -> UserProfile
}
