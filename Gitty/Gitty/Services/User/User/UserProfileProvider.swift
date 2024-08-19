import Foundation

protocol UserProfileProvider: AnyObject, Sendable {
    func getMe() async throws
    func get(for user: User) async throws -> UserProfile
}
