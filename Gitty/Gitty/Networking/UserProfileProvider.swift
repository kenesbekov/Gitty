import Foundation

protocol UserProfileProvider: AnyObject {
    func getMe() async throws -> UserProfile
    func get(for user: User) async throws -> UserProfile
}
