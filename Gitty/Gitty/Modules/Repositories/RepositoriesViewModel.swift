import Foundation
import SwiftUI

@MainActor
final class RepositoriesViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var repositories: [Repository] = []
    @Published var paginationState: PaginationState = .default

    @Injected private var repositoriesProvider: RepositoriesProvider
    @Injected private var historyProvider: RepositoryHistoryProvider

    private var paginationManager = PaginationManager()

    func search() {
        guard paginationManager.shouldLoadMore(isLoading: paginationState == .loading) else { return }

        Task {
            paginationManager.reset()
            await getRepositories(searchQuery: searchQuery, page: 1)
        }
    }

    func loadMoreRepositories() {
        guard paginationManager.shouldLoadMore(isLoading: paginationState == .loading || paginationState == .paginating) else {
            return
        }

        Task {
            paginationManager.loadNextPage()
            await getRepositories(searchQuery: searchQuery, page: paginationManager.currentPage)
        }
    }

    private func getRepositories(searchQuery: String, page: Int) async {
        guard !searchQuery.isEmpty else {
            paginationState = .default
            return
        }

        do {
            paginationState = page == 1 ? .loading : .paginating

            let sortKind: SortKind = .forks
            let orderKind: OrderKind = .descending
            let newRepositories = try await repositoriesProvider.get(
                matching: searchQuery,
                sort: sortKind,
                order: orderKind,
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
            } else {
                if page == 1 {
                    repositories = updatedRepositories
                } else {
                    repositories.append(contentsOf: updatedRepositories)
                }
            }

            paginationState = repositories.isEmpty
                ? .noResults
                : .success
        } catch {
            paginationState = .error(error.localizedDescription)
        }
    }

    func markRepositoryAsViewed(at index: Int) {
        guard index >= 0 && index < repositories.count else { return }
        repositories[index].isViewed = true
        historyProvider.add(repositories[index])
    }

    func deleteToken(appStateManager: AppStateManager) {
        appStateManager.logout()
    }
}
