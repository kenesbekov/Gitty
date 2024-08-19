import Foundation

enum PaginationState: Equatable {
    case `default`
    case loading
    case paginating
    case error(String)
    case noResults
    case success
}
