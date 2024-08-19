import Foundation

protocol UsersProvider: AnyObject, Sendable {
    func get(matching query: String, page: Int, perPage: Int) async throws -> GetUsersResponse
}
