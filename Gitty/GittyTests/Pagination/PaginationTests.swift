import Testing
@testable import Gitty

struct PaginationManagerTests {
    private let paginationManager = PaginationManager()

    @Test("Check Initial State")
    func initialState() {
        #expect(paginationManager.currentPage == 1)
        #expect(paginationManager.hasMorePages)
    }

    @Test("Reset pagination")
    func resetPagination() {
        paginationManager.loadNextPage()
        paginationManager.setHasMorePages(to: false)

        paginationManager.reset()

        #expect(paginationManager.currentPage == 1)
        #expect(paginationManager.hasMorePages)
    }

    @Test("Load next page")
    func loadNextPage() {
        paginationManager.loadNextPage()

        #expect(paginationManager.currentPage == 2)

        paginationManager.loadNextPage()

        #expect(paginationManager.currentPage == 3)
    }

    @Test("Set has more pages")
    func setHasMorePages() {
        paginationManager.setHasMorePages(to: false)

        #expect(!paginationManager.hasMorePages)

        paginationManager.setHasMorePages(to: true)

        #expect(paginationManager.hasMorePages)
    }

    @Test("Should load more")
    func shouldLoadMore() {
        #expect(paginationManager.shouldLoadMore(isLoading: false))
        #expect(!paginationManager.shouldLoadMore(isLoading: true))

        paginationManager.setHasMorePages(to: false)
        #expect(!paginationManager.shouldLoadMore(isLoading: false))
    }
}
