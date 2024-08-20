import Foundation

protocol UserProfileProvider: AnyObject, Sendable {
    func get(for user: User) async throws -> UserProfile
}
