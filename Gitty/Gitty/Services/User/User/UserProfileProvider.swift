import Foundation

protocol UserProfileProvider: AnyObject {
    func getMe() async throws
    func get(for user: User) async throws -> UserProfile
}
