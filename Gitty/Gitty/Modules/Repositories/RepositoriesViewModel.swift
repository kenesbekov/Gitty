import SwiftUI

// MARK: - Constants

private enum Constants {
    static let debounceInterval = UInt64(0.5 * 1_000_000_000)
}

// MARK: - RepositoriesViewModel

@MainActor
final class RepositoriesViewModel: ObservableObject {
    @Published var searchQuery: String = "" {
        didSet {
            guard searchQuery != oldValue else {
                return
            }
            
            debounceSearch()
        }
    }
    @Published var repositories: [Repository] = []
    @Published var paginationState: PaginationState = .default
    @Published var selectedSortKind: RepositorySortKind = .forks

    @Injected private var repositoriesProvider: RepositoriesProvider
    @Injected private var historyProvider: RepositoryHistoryProvider

    private var currentSearchTask: Task<Void, Never>?
    private var debounceTask: Task<Void, Never>?
    private var paginationManager = PaginationManager()

    func refreshed() {
        Task {
            await search()
        }
    }

    func loadMore() async {
        guard paginationManager.shouldLoadMore(
            isLoading: paginationState == .loading || paginationState == .paginating
        ) else {
            return
        }

        paginationManager.loadNextPage()
        await get(searchQuery: searchQuery, page: paginationManager.currentPage)
    }

    func markAsViewed(at index: Int) {
        guard repositories.indices.contains(index) else {
            return
        }

        repositories[index].isViewed = true
        historyProvider.add(repositories[index])
    }

    func deleteToken(appStateManager: AppStateManagerImpl) {
        appStateManager.logout()
    }

    private func debounceSearch() {
        debounceTask?.cancel()

        debounceTask = Task {
            try? await Task.sleep(nanoseconds: Constants.debounceInterval)
            await search()
        }
    }

    private func search() async {
        currentSearchTask?.cancel()

        guard !searchQuery.isEmpty else {
            paginationState = .default
            repositories = []
            return
        }

        currentSearchTask = Task {
            paginationManager.reset()
            await get(searchQuery: searchQuery, page: 1)
        }
    }

    private func get(searchQuery: String, page: Int) async {
        guard !searchQuery.isEmpty else {
            paginationState = .default
            return
        }

        do {
            paginationState = page == 1 ? .loading : .paginating

            let newRepositories = try await repositoriesProvider.get(
                matching: searchQuery,
                sort: selectedSortKind,
                page: page,
                limit: 30
            )
            let viewedRepositories = historyProvider.repositories

            let updatedRepositories = updateViewedStatus(for: newRepositories, with: viewedRepositories)
            updateRepositoriesList(with: updatedRepositories, page: page)

            handlePaginationState(for: newRepositories)

        } catch {
            handleError(error)
        }
    }

    private func updateViewedStatus(for repositories: [Repository], with viewedRepositories: [Repository]) -> [Repository] {
        repositories.map { repo in
            var updatedRepo = repo
            if viewedRepositories.contains(where: { $0.id == repo.id }) {
                updatedRepo.isViewed = true
            }
            return updatedRepo
        }
    }

    private func updateRepositoriesList(with newRepositories: [Repository], page: Int) {
        if newRepositories.isEmpty {
            paginationManager.setHasMorePages(to: false)
            paginationState = repositories.isEmpty ? .noResults : .success
        } else {
            if page == 1 {
                repositories = newRepositories
            } else {
                repositories.append(contentsOf: newRepositories)
            }
            paginationState = .success
        }
    }

    private func handlePaginationState(for newRepositories: [Repository]) {
        if newRepositories.isEmpty {
            paginationManager.setHasMorePages(to: false)
            paginationState = repositories.isEmpty ? .noResults : .success
        } else {
            paginationState = .success
        }
    }

    private func handleError(_ error: Error) {
        guard currentSearchTask?.isCancelled == true else {
            return
        }

        paginationState = .error("An error occurred: \(error.localizedDescription)")
    }
}
