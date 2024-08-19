import Foundation
import SwiftUI

@MainActor
final class UsersViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var isPaginationLoading = false
    @Published var hasError = false

    @Injected private var userProfileProvider: UserProfileProvider
    @Injected private var usersProvider: UsersProvider
    @Injected private var historyProvider: UserHistoryProvider

    private var currentPage = 1
    private var hasMorePages = true

    func performSearch() {
        guard !isLoading && !isPaginationLoading else {
            return
        }

        Task {
            await getUsers(query: searchQuery, page: 1)
        }
    }

    func loadMoreUsers() {
        guard hasMorePages, !isLoading, !isPaginationLoading else {
            return
        }

        currentPage += 1
        Task {
            await getUsers(query: searchQuery, page: currentPage)
        }
    }

    private func getUsers(query: String, page: Int) async {
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
            let searchResponse = try await usersProvider.get(matching: query, page: page, perPage: 30)
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

            if fetchedUsers.isEmpty {
                hasMorePages = false
            } else {
                if page == 1 {
                    users = fetchedUsers
                } else {
                    users.append(contentsOf: fetchedUsers)
                }
            }

            sortUsersByFollowers()
            markViewedUsers()
            hasError = false
        } catch {
            hasError = true
            users = []
        }
    }

    private func sortUsersByFollowers() {
        users.sort { ($0.followers ?? 0) > ($1.followers ?? 0) }
    }

    private func markViewedUsers() {
        let viewedUsers = historyProvider.users
        users = users.map { user in
            var updatedUser = user
            if viewedUsers.contains(where: { $0.id == user.id }) {
                updatedUser.isViewed = true
            }
            return updatedUser
        }
    }

    func addToHistory(user: User) {
        guard let index = users.firstIndex(where: { $0.id == user.id }) else {
            return
        }
        users[index].isViewed = true
        historyProvider.add(user)
    }

    func deleteToken(appStateManager: AppStateManager) {
        appStateManager.logout()
    }
}
