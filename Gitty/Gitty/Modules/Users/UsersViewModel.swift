import SwiftUI

// MARK: - Constants

private enum Constants {
    static let debounceInterval = UInt64(0.5 * 1_000_000_000)
}

// MARK: - UsersViewModel

@MainActor
final class UsersViewModel: ObservableObject {
    @Published var searchQuery: String = "" {
        didSet {
            guard searchQuery != oldValue else {
                return
            }

            debounceSearch()
        }
    }
    @Published var users: [User] = []
    @Published var paginationState: PaginationState = .default

    private let usersProvider: UsersProvider
    private let historyProvider: UserHistoryProvider

    private var currentSearchTask: Task<Void, Never>?
    private var debounceTask: Task<Void, Never>?
    private var paginationManager = PaginationManager()

    /// Initializes the view model with custom providers for testing purposes.
    init(
        usersProvider: UsersProvider,
        historyProvider: UserHistoryProvider
    ) {
        self.usersProvider = usersProvider
        self.historyProvider = historyProvider
    }

    init() {
        @Injected var usersProvider: UsersProvider
        self.usersProvider = usersProvider

        @Injected var historyProvider: UserHistoryProvider
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
        guard users.indices.contains(index) else {
            return
        }

        users[index].isViewed = true
        historyProvider.add(users[index])
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
            users = []
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

            let newUsers = try await usersProvider.get(
                matching: searchQuery,
                page: page,
                perPage: 30
            )

            let viewedUsers = historyProvider.users

            let updatedUsers = newUsers.map { user in
                var updatedUser = user
                if viewedUsers.contains(where: { $0.id == user.id }) {
                    updatedUser.isViewed = true
                }
                return updatedUser
            }

            if newUsers.isEmpty {
                paginationManager.setHasMorePages(to: false)
                paginationState = users.isEmpty ? .noResults : .success
            } else {
                if page == 1 {
                    users = updatedUsers
                } else {
                    users.append(contentsOf: updatedUsers)
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


//@MainActor
//final class UsersViewModel: ObservableObject {
//    @Published var searchQuery = ""
//    @Published var users: [User] = []
//    @Published var paginationState: PaginationState = .default
//
//    @Injected private var profileProvider: UserProfileProvider
//    @Injected private var usersProvider: UsersProvider
//    @Injected private var historyProvider: UserHistoryProvider
//
//    private var paginationManager = PaginationManager()
//
//    func search() async {
//        guard paginationManager.shouldLoadMore(isLoading: paginationState == .loading) else { return }
//
//        paginationManager.reset()
//        await performSearch(page: 1)
//    }
//
//    func loadMoreUsers() async {
//        guard paginationManager.shouldLoadMore(isLoading: paginationState == .loading || paginationState == .paginating) else {
//            return
//        }
//
//        paginationManager.loadNextPage()
//        await performSearch(page: paginationManager.currentPage)
//    }
//
//    func addToHistory(user: User) {
//        historyProvider.add(user)
//    }
//
//    func deleteToken(appStateManager: AppStateManagerImpl) {
//        appStateManager.logout()
//    }
//
//    private func performSearch(page: Int) async {
//        guard !searchQuery.isEmpty else {
//            paginationState = .default
//            return
//        }
//
//        do {
//            paginationState = page == 1 ? .loading : .paginating
//            let searchResponse = try await usersProvider.get(matching: searchQuery, page: page, perPage: 30)
//            var fetchedUsers = searchResponse.items
//
//            for (index, user) in fetchedUsers.enumerated() {
//                do {
//                    let userProfile = try await profileProvider.get(for: user)
//                    fetchedUsers[index].followers = userProfile.followers
//                } catch {
//                    print("Failed to fetch profile for \(user.login): \(error.localizedDescription)")
//                    fetchedUsers[index].followers = 0
//                }
//            }
//
//            if searchResponse.items.isEmpty {
//                paginationManager.setHasMorePages(to: false)
//            } else {
//                if page == 1 {
//                    users = fetchedUsers.sorted { ($0.followers ?? 0) > ($1.followers ?? 0) }
//                } else {
//                    users.append(contentsOf: fetchedUsers.sorted { ($0.followers ?? 0) > ($1.followers ?? 0) })
//                }
//            }
//
//            paginationState = users.isEmpty
//                ? .noResults
//                : .success
//        } catch {
//            paginationState = .error(error.localizedDescription)
//            if page == 1 {
//                users = []
//            }
//        }
//    }
//}
