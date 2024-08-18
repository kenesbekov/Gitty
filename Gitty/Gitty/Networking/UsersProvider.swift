import Foundation

protocol UsersProvider: AnyObject {
    func get(matching query: String, page: Int, perPage: Int) async throws -> GetUsersResponse
}
