import Foundation
import SwiftUI

@MainActor
final class RepositoriesViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var repositories: [Repository] = []
    @Published var isLoading = false
    @Published var isPaginationLoading = false
    @Published var hasError = false

    @Injected private var repositoriesProvider: RepositoriesProvider
    @Injected private var historyProvider: RepositoryHistoryProvider

    private var currentPage = 1
    private var hasMorePages = true

    func performSearch() {
        guard !isLoading && !isPaginationLoading else {
            return
        }

        Task {
            await getRepositories(query: searchQuery, page: 1)
        }
    }

    func loadMoreRepositories() {
        guard hasMorePages, !isLoading, !isPaginationLoading else {
            return
        }

        currentPage += 1
        Task {
            await getRepositories(query: searchQuery, page: currentPage)
        }
    }

    private func getRepositories(query: String, page: Int) async {
        defer {
            isLoading = false
            isPaginationLoading = false
        }

        if page == 1 {
            isLoading = true
        } else {
            isPaginationLoading = true
        }

        do {
            let sortKind: SortKind = .forks // You can make this dynamic if needed
            let orderKind: OrderKind = .descending // You can make this dynamic if needed
            let newRepositories = try await repositoriesProvider.get(
                matching: query,
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
                hasMorePages = false
            } else {
                if page == 1 {
                    repositories = updatedRepositories
                } else {
                    repositories.append(contentsOf: updatedRepositories)
                }
            }
            hasError = false
        } catch {
            hasError = true
        }
    }

    func markRepositoryAsViewed(at index: Int) {
        guard index >= 0 && index < repositories.count else {
            return
        }

        repositories[index].isViewed = true
        historyProvider.add(repositories[index])
    }

    func deleteToken(appStateManager: AppStateManager) {
        appStateManager.logout()
    }
}
