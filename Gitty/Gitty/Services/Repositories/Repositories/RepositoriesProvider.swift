import Foundation

protocol RepositoriesProvider: AnyObject, Sendable {
    func get(
        matching query: String,
        sort: SortKind,
        order: OrderKind,
        page: Int,
        perPage: Int
    ) async throws -> [Repository]

    func get(
        userLogin: String,
        page: Int,
        perPage: Int
    ) async throws -> [Repository]
}
