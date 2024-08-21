import SwiftUI

@MainActor
final class RepositoriesViewModel: ObservableObject {
    @Published var searchQuery: String = "" {
        didSet {
            debounceSearch()
        }
    }
    @Published var repositories: [Repository] = []
    @Published var paginationState: PaginationState = .default
    @Published var selectedSortKind: RepositorySortKind = .forks

    private let repositoriesProvider: RepositoriesProvider
    private let historyProvider: RepositoryHistoryProvider

    private var currentSearchTask: Task<Void, Never>?
    private var debounceTask: Task<Void, Never>?
    private var paginationManager = PaginationManager()

    private let debounceInterval: TimeInterval = 0.5

    init(
        repositoriesProvider: RepositoriesProvider,
        historyProvider: RepositoryHistoryProvider
    ) {
        self.repositoriesProvider = repositoriesProvider
        self.historyProvider = historyProvider
    }

    init() {
        @Injected var repositoriesProvider: RepositoriesProvider
        self.repositoriesProvider = repositoriesProvider

        @Injected var historyProvider: RepositoryHistoryProvider
        self.historyProvider = historyProvider
    }

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
            try? await Task.sleep(nanoseconds: UInt64(debounceInterval * 1_000_000_000))
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
                perPage: 30
            )

            let viewedRepositories = historyProvider.repositories

            let updatedRepositories = newRepositories.map { repo in
                var updatedRepo = repo
                if viewedRepositories.contains(where: { $0.id == repo.id }) {
                    updatedRepo.isViewed = true
                }
                return updatedRepo
            }

            if newRepositories.isEmpty {
                paginationManager.setHasMorePages(to: false)
                paginationState = repositories.isEmpty ? .noResults : .success
            } else {
                if page == 1 {
                    repositories = updatedRepositories
                } else {
                    repositories.append(contentsOf: updatedRepositories)
                }
                paginationState = .success
            }
        } catch {
            guard currentSearchTask?.isCancelled == true else {
                return
            }

            paginationState = .error("An error occurred: \(error.localizedDescription)")
        }
    }
}
