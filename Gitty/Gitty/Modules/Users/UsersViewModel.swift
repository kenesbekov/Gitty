import Foundation
import SwiftUI

@MainActor
final class UsersViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var users: [User] = []
    @Published var paginationState: PaginationState = .default

    @Injected var userProfileProvider: UserProfileProvider
    @Injected var usersProvider: UsersProvider
    @Injected var historyProvider: UserHistoryProvider

    private var paginationManager = PaginationManager()

    func search() {
        guard paginationManager.shouldLoadMore(isLoading: paginationState == .loading) else { return }

        Task {
            paginationManager.reset()
            await performSearch(page: 1)
        }
    }

    func loadMoreUsers() {
        guard paginationManager.shouldLoadMore(isLoading: paginationState == .loading || paginationState == .paginating) else {
            return
        }

        Task {
            paginationManager.loadNextPage()
            await performSearch(page: paginationManager.currentPage)
        }
    }

    func addToHistory(user: User) {
        historyProvider.add(user)
    }

    func deleteToken(appStateManager: AppStateManager) {
        appStateManager.logout()
    }

    private func performSearch(page: Int) async {
        guard !searchQuery.isEmpty else {
            paginationState = .default
            return
        }

        do {
            paginationState = page == 1 ? .loading : .paginating
            let searchResponse = try await usersProvider.get(matching: searchQuery, page: page, perPage: 30)
            var fetchedUsers = searchResponse.items

            for (index, user) in fetchedUsers.enumerated() {
                do {
                    let userProfile = try await userProfileProvider.get(for: user)
                    fetchedUsers[index].followers = userProfile.followers
                } catch {
                    print("Failed to fetch profile for \(user.login): \(error.localizedDescription)")
                    fetchedUsers[index].followers = 0
                }
            }

            if searchResponse.items.isEmpty {
                paginationManager.setHasMorePages(to: false)
            } else {
                if page == 1 {
                    users = fetchedUsers.sorted { ($0.followers ?? 0) > ($1.followers ?? 0) }
                } else {
                    users.append(contentsOf: fetchedUsers.sorted { ($0.followers ?? 0) > ($1.followers ?? 0) })
                }
            }

            paginationState = users.isEmpty
                ? .noResults
                : .success
        } catch {
            paginationState = .error(error.localizedDescription)
            if page == 1 {
                users = []
            }
        }
    }
}
