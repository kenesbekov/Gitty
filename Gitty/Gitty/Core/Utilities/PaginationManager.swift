import Foundation

final class PaginationManager {
    private(set) var currentPage: Int
    private(set) var hasMorePages: Bool

    init(currentPage: Int = 1, hasMorePages: Bool = true) {
        self.currentPage = currentPage
        self.hasMorePages = hasMorePages
    }

    func reset() {
        currentPage = 1
        hasMorePages = true
    }

    func loadNextPage() {
        currentPage += 1
    }

    func setHasMorePages(to hasMorePages: Bool) {
        self.hasMorePages = hasMorePages
    }

    func shouldLoadMore(isLoading: Bool) -> Bool {
        !isLoading && hasMorePages
    }
}
