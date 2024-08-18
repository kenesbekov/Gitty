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
        guard !isLoading && !isPaginationLoading else { return }
        Task {
            await fetchRepositories(query: searchQuery, page: 1)
        }
    }

    func loadMoreRepositories() {
        guard hasMorePages, !isLoading, !isPaginationLoading else { return }
        currentPage += 1
        Task {
            await fetchRepositories(query: searchQuery, page: currentPage)
        }
    }

    private func fetchRepositories(query: String, page: Int) async {
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
            let sortOption: SortOption = .forks // You can make this dynamic if needed
            let orderOption: OrderOption = .descending // You can make this dynamic if needed
            let newRepositories = try await repositoriesProvider.get(
                matching: query,
                sort: sortOption,
                order: orderOption,
                page: page,
                perPage: 30
            )
            if newRepositories.isEmpty {
                hasMorePages = false
            } else {
                if page == 1 {
                    repositories = newRepositories
                } else {
                    repositories.append(contentsOf: newRepositories)
                }
            }
            hasError = false
        } catch {
            hasError = true
        }
    }

    func markRepositoryAsViewed(at index: Int) {
        guard index >= 0 && index < repositories.count else { return }
        repositories[index].isViewed = true
        historyProvider.add(repositories[index])
    }

    func deleteToken() {
//        appStateManager.logout()
    }
}
