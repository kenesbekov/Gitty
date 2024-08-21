import Foundation

protocol RepositoriesProvider: AnyObject, Sendable {
    func get(
        matching query: String,
        sort: RepositorySortKind,
        page: Int,
        limit: Int
    ) async throws -> [Repository]

    func get(
        userLogin: String,
        page: Int,
        limit: Int
    ) async throws -> [Repository]
}
