import SwiftUI

// MARK: - Constants

private enum Constants {
    static let debounceInterval = UInt64(0.5 * 1_000_000_000)
}

// MARK: - UsersViewModel

@MainActor
final class UsersViewModel: ObservableObject {
    typealias UserProfileDict = [String: Int]
    typealias UserProfileResult = (String, Int)

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

    @Injected private var usersProvider: UsersProvider
    @Injected private var profileProvider: UserProfileProvider
    @Injected private var historyProvider: UserHistoryProvider

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

    func markAsViewed(for user: User) {
        guard let index = users.firstIndex(where: { $0.id == user.id }) else {
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

            let newUsers = try await usersProvider.get(matching: searchQuery, page: page, limit: 30)
            let usernames = newUsers.map { $0.login }
            let userProfiles = try await getUserProfiles(for: usernames)

            let updatedUsers = updateUsers(newUsers, withProfiles: userProfiles)
            users = updateUserList(users, with: updatedUsers, forPage: page)

            users.sort { ($0.followers ?? 0) > ($1.followers ?? 0) }
            handlePaginationState(newUsers: newUsers)
        } catch {
            handleError(error)
        }
    }

    nonisolated private func getUserProfiles(for usernames: [String]) async throws -> UserProfileDict {
        var profiles = UserProfileDict()

        try await withThrowingTaskGroup(of: UserProfileResult.self) { [profileProvider] group in
            for username in usernames {
                group.addTask {
                    let userProfile = try await profileProvider.get(for: username)
                    return (username, userProfile.followers)
                }
            }

            for try await (username, followers) in group {
                profiles[username] = followers
            }
        }

        return profiles
    }

    private func updateUsers(_ newUsers: [User], withProfiles profiles: UserProfileDict) -> [User] {
        let viewedUsers = historyProvider.users

        return newUsers.map { user -> User in
            var updatedUser = user
            if viewedUsers.contains(where: { $0.id == user.id }) {
                updatedUser.isViewed = true
            }
            updatedUser.followers = profiles[user.login] ?? 0
            return updatedUser
        }
    }

    private func updateUserList(_ existingUsers: [User], with newUsers: [User], forPage page: Int) -> [User] {
        guard page != 1 else {
            return newUsers
        }

        var existingUserDict = Dictionary(uniqueKeysWithValues: existingUsers.map { ($0.login, $0) })

        for updatedUser in newUsers {
            existingUserDict[updatedUser.login] = updatedUser
        }

        return Array(existingUserDict.values)
    }

    private func handlePaginationState(newUsers: [User]) {
        if newUsers.isEmpty {
            paginationManager.setHasMorePages(to: false)
            paginationState = users.isEmpty ? .noResults : .success
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
