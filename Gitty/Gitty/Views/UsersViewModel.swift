import Foundation
import SwiftUI

@MainActor
final class UsersViewModel: ObservableObject {
    @Published var query = ""
    @Published var users: [GitHubUser] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    @Inject var apiService: GitHubAPI
    @Inject var history: UserHistory

    func searchUsers() {
        Task {
            await performSearch()
        }
    }

    func addToHistory(user: GitHubUser) {
        history.add(user)
    }

    private func performSearch() async {
        defer {
            isLoading = false
        }

        do {
            isLoading = true
            let searchResponse = try await apiService.searchUsers(query: query, page: 1, perPage: 30)
            var fetchedUsers = searchResponse.items

            // Fetch followers count for each user
            for (index, user) in fetchedUsers.enumerated() {
                do {
                    let userProfile = try await apiService.fetchUserProfile(for: user)
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
