import Foundation
import SwiftUI

@MainActor
final class UsersViewModel: ObservableObject {
    @Published var searchQuery = ""
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    @Injected var userProfileProvider: UserProfileProvider
    @Injected var usersProvider: UsersProvider
    @Injected var historyProvider: UserHistoryProvider

    func searchUsers() {
        Task {
            await performSearch()
        }
    }

    func addToHistory(user: User) {
        historyProvider.add(user)
    }

    private func performSearch() async {
        defer {
            isLoading = false
        }

        do {
            isLoading = true
            let searchResponse = try await usersProvider.get(matching: searchQuery, page: 1, perPage: 30)
            var fetchedUsers = searchResponse.items

            // Fetch followers count for each user
            for (index, user) in fetchedUsers.enumerated() {
                do {
                    let userProfile = try await userProfileProvider.get(for: user)
                    fetchedUsers[index].followers = userProfile.followers
                } catch {
                    print("Failed to fetch profile for \(user.login): \(error.localizedDescription)")
                    fetchedUsers[index].followers = 0 // Default to 0 if failed
                }
            }

            // Sort users by followers count in descending order
            users = fetchedUsers.sorted { ($0.followers ?? 0) > ($1.followers ?? 0) }
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            users = []
        }
    }
}
