import SwiftUI

struct UserSearchView: View {
    let api: GitHubAPI
    let history: UserHistory

    @EnvironmentObject private var appRouter: AppRouter
    @State private var query = ""
    @State private var users: [GitHubUser] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search users", text: $query, onCommit: {
                    Task {
                        await searchUsers(query: query)
                    }
                })
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

                if isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if users.isEmpty {
                    Text("No users found")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(users) { user in
                        Button {
                            appRouter.navigateTo(.userRepositories(user))
                        } label: {
                            VStack(alignment: .leading) {
                                Text(user.login)
                                    .font(.headline)

                                if let followers = user.followers {
                                    Text("Followers: \(followers)")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Search Users")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: UserHistoryView(history: history)) {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                }
            }
            .padding()
        }
    }

    private func searchUsers(query: String) async {
        defer {
            isLoading = false
        }

        do {
            isLoading = true
            let searchResponse = try await api.searchUsers(query: query, page: 1, perPage: 30)
            var fetchedUsers = searchResponse.items

            // Fetch followers count for each user
            for (index, user) in fetchedUsers.enumerated() {
                do {
                    let userProfile = try await api.fetchUserProfile(for: user)
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
